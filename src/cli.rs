use structopt::StructOpt;

fn parse_input_file(src: &str) -> Result<std::fs::File, std::io::Error> {
    std::fs::File::open(std::path::Path::new(src))
}

fn parse_output_file(src: &str) -> Result<std::fs::File, std::io::Error> {
    std::fs::File::create(std::path::Path::new(src))
}

#[derive(StructOpt)]
#[structopt(name="scc", about="A compiler")]
pub struct Arguments {
    #[structopt(name = "input-file", parse(try_from_str = parse_input_file))]
    pub input_file: std::fs::File,

    #[structopt(name = "output-file", short="o", long="output", parse(try_from_str = parse_output_file), default_value = "a.out")]
    pub output_file: std::fs::File,
}


