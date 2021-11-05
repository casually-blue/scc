//
//  LLVMAssembler.swift
//  scc
//
//  Created by Admin on 11/4/21.
//

import Foundation

enum AssemblerError: Error {
    case llcNotFoundError
    case clangNotFoundError
    case invalidAssembly
}

struct Assembler {
    let fileName: URL
    
    init(output fileName: URL) {
        self.fileName = fileName
    }
    
    func createClangProcess() throws -> Process {
        let clangExecutable = URL(fileURLWithPath: "/opt/homebrew/opt/llvm/bin/clang")
        
        // check if clang is actually in its place
        if !FileManager.default.fileExists(atPath: clangExecutable.path) {
            throw AssemblerError.clangNotFoundError
        }
        
        // Create the process
        let clang = Process()
        
        clang.executableURL = clangExecutable
        
        // set the process to take the intermediate object file and convert it
        // to a binary
        clang.arguments = [
            fileName.appendingPathExtension("o").path,
            "-o", fileName.path]
        
        return clang
    }
    
    func execProcess(process: Process) throws {
        // Run a process object and wait for the exit
        try process.run()
        process.waitUntilExit()
    }
    
    func assemble() throws {
        try execProcess(process: try createClangProcess())
        
        // Delete the temporary object file after compiling the final executable
        try FileManager.default.removeItem(at: fileName.appendingPathExtension("o"))
    }
}
