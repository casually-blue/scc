use {
    std::{
        path::PathBuf,
        fs::File,
        error::Error,
        str::FromStr,
    },
    crate::Result
};

pub struct InputFile {
    backing_file: File,
}

impl InputFile {
    pub fn new(path: Box<PathBuf>) -> Result<Self> {
        let f = File::open(path.as_path())?;
        Ok(InputFile {backing_file: f})
    }

    pub fn get(&mut self) -> &mut File {
        &mut self.backing_file
    }
}

impl FromStr for InputFile {
    type Err = Box<dyn Error>;

    fn from_str(s: &str) -> Result<Self> {
        InputFile::new(box PathBuf::from(s))
    }
}

pub struct OutputFile {
    backing_file: File,
}

impl OutputFile {
    pub fn new(path: Box<PathBuf>) -> Result<Self> {
        let f = File::create(path.as_path())?;
        Ok(OutputFile{backing_file: f})
    }

    pub fn get(&mut self) -> &mut File {
        &mut self.backing_file
    }
}

impl FromStr for OutputFile {
    type Err = Box<dyn Error>;

    fn from_str(s: &str) -> Result<Self> {
        OutputFile::new(box PathBuf::from(s))
    }
}