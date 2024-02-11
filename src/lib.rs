use derive_more::{Display, Error, From};
use std::{borrow::{Borrow, BorrowMut}, cell::RefCell, cmp, rc::Rc};

use nvim_oxi::{
    api::{
        self, types::{WindowBorder, WindowConfig, WindowRelativeTo, WindowTitle, WindowTitlePosition}, Buffer, Window
    },
    module, Dictionary, Error as OxiError, Function, Result as OxiResult, String as OxiString, Float
};

#[derive(Debug, Default)]
pub enum MakeNoteState {
    #[default]
    Initial,
    WriteNote {
        window: Window,
        buffer: Buffer,
    },
    CheckNote {
        window: Window,
    },
    Save {
        window: Window,
    },
}

impl MakeNoteState {
    fn write_note() -> Result<Self, MakeNoteError> {
        let buffer = api::create_buf(false, true)?;

        let Some(ui) = api::list_uis().next() else {
            return Err(MakeNoteError::CannotGetUi);
        };
        let width = ui.width as u32;
        let height = ui.height as u32;

        let window_width = cmp::min(width - 20, width / 10 * 7);
        let window_height = cmp::min(height - 20, height / 10 * 8);

        let window_row = (height / 2) - (window_height / 2);
        let window_col = (width / 2) - (window_width / 2);

        let window_config = WindowConfig::builder()
            .relative(WindowRelativeTo::Editor)
            .border(WindowBorder::Single)
            .title(WindowTitle::SimpleString(OxiString::from("Write New Note")))
            .title_pos(WindowTitlePosition::Left)
            .width(window_width)
            .height(window_height)
            .row(window_row)
            .col(window_col)
            .build();
        let window = api::open_win(&buffer, false, &window_config)?;
        return Ok(Self::WriteNote { window, buffer });
    }
}

#[derive(Debug, Display, Error, From)]
pub enum MakeNoteError {
    InvalidStateTransition,
    CannotGetUi,
    OxiApiError(api::Error),
}

#[module]
fn scatternotes() -> OxiResult<Dictionary> {
    let make_note_state = Rc::new(RefCell::new(MakeNoteState::default()));

    let write_note_state = make_note_state.clone();
    let write_note = Function::from_fn(move |()| {
        let current_state = (write_note_state.borrow() as &RefCell<_>).borrow();
        match *current_state {
            MakeNoteState::Initial => {}
            MakeNoteState::WriteNote { .. } => return Ok(()),
            _ => return Err(MakeNoteError::InvalidStateTransition),
        };

        let new_state = MakeNoteState::write_note()?;
        let mut previous_state = (write_note_state.borrow() as &RefCell<_>).borrow_mut();
        *previous_state = new_state;
    
        return Ok(());
    });

    let check_note_state = make_note_state.clone();
    let check_note = Function::from_fn(move |()| {
        let current_state = (check_note_state.borrow() as &RefCell<_>).borrow();
        match *current_state {
            MakeNoteState::WriteNote { .. } => {}
            MakeNoteState::CheckNote { .. } => return Ok(()),
            _ => return Err(MakeNoteError::InvalidStateTransition),
        };
        return Ok(());
    });

    Ok(Dictionary::from_iter([
        ("write_note", write_note),
        ("check_note", check_note),
    ]))
}
