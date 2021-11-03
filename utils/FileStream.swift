//
//  FileStream.swift
//  scc
//
//  Created by Admin on 11/2/21.
//

import Foundation

enum InputError: Error {
    case fileNotFound(fileName: String)
    case couldNotOpen(fileName: String)
}

struct FileStream {
    var handle: FileHandle
    
    init(path: String) throws {
        if !FileManager.default.fileExists(atPath: path) {
            throw InputError.fileNotFound(fileName: path)
        }
        
        
        switch FileHandle(forReadingAtPath: path){
        case .some(let handle): self.handle = handle
        case .none: throw InputError.couldNotOpen(fileName: path)
        }
    }
}
