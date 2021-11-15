#![feature(box_syntax)]
#![feature(slice_pattern)]

mod cli;
mod file;

mod parser;
mod lexer;

use {
    structopt::StructOpt,
    std::error::Error,
    cli::Arguments,
};

pub type Result<T> = std::result::Result<T, Box<dyn Error>>;

/// Compilation Steps
///
/// * Read in command line arguments
/// * Tokenize input
/// * Parse code
/// * Semantically verify
/// * Apply optimization
/// * Convert to ir
/// * Generate output
fn main() -> Result<()> {
    let options = Arguments::from_args();

    let mut lexer = lexer::Lexer::new(options.input_file)?;
    let tokens = lexer.tokenize()?;

    let mut parser = parser::Parser::new(tokens)?;
    let parse_tree = parser.parse()?;

    println!("{:#?}", parse_tree);

    Ok(())
}
