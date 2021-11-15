use {
  structopt::StructOpt
};

use crate::file::{InputFile, OutputFile};

#[derive(StructOpt)]
#[structopt(name="scc", about="A compiler")]
pub struct Arguments {
    #[structopt(name = "input-file")]
    pub input_file: InputFile,

    #[structopt(name = "output-file", short="o", long="output", default_value = "a.out")]
    pub output_file: OutputFile,

    #[structopt(name = "verbose", short="v", long="verbose", parse(from_occurrences))]
    pub verbose: u8,
}


