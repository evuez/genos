use std::env;
use std::fs;
use std::fs::File;
use std::io::{Read, Seek, SeekFrom, BufReader};
use std::mem;

const CHUNK_SIZE: u64 = 65536;

fn compute_hash(file: File, fsize: u64) -> Result<String, std::io::Error> {
    let mut word: u64;
    let mut hash: u64 = fsize;
    let mut buffer = [0u8; 8];
    let mut reader = BufReader::with_capacity(CHUNK_SIZE as usize, file);

    for _ in 0..CHUNK_SIZE / 8 {
        try!(reader.read(&mut buffer));
        unsafe { word = mem::transmute(buffer); };
        hash = hash.wrapping_add(word);
    }

    try!(reader.seek(SeekFrom::Start(fsize - CHUNK_SIZE)));
    for _ in 0..CHUNK_SIZE / 8 {
        try!(reader.read(&mut buffer));
        unsafe { word = mem::transmute( buffer); };
        hash = hash.wrapping_add(word);
    }

    Ok(format!("{:01$x}", hash, 16))
}

fn main() {
    let fname = env::args().nth(1).unwrap();

    let fsize = fs::metadata(&fname).unwrap().len();
    if fsize > CHUNK_SIZE {
        let file = File::open(&fname).unwrap();
        let fhash = compute_hash(file, fsize).unwrap();
        println!("{}", fhash);
    }
}
