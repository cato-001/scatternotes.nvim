use nvim_oxi::{self as oxi};

#[oxi::module]
fn scatternotes() -> oxi::Result<u64> {
    Ok(34)
}
