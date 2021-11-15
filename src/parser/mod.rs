pub mod parse_tree;

use {
    crate::{
        Result,
        lexer::token::Token,
    },
    parse_tree::ParseTree
};

pub struct Parser {
    tokens: Vec<Token>
}

impl Parser {
    pub fn new(tokens: Vec<Token>) -> Result<Parser> {
        Ok(Parser { tokens })
    }


    pub fn parse(&mut self) -> Result<ParseTree> {
        let _max_index = self.tokens.len() - 1;
        todo!()
    }
}
