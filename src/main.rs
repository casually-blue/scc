#![feature(box_syntax)]

mod utils;
mod cli;

use structopt::StructOpt;

fn main() -> Result<(), String> {
    let _options = cli::Arguments::from_args();

    Ok(())
}
