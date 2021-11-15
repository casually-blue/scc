pub mod token;

use {
    crate::{
        file::InputFile,
        Result,
    },
    token::Token
};

pub struct Lexer {

}

impl Lexer {
    pub fn new(code: InputFile) -> Result<Self> {
        todo!()
    }

    pub fn tokenize(&mut self) -> Result<Vec<Token>> {
        todo!()
    }
}
