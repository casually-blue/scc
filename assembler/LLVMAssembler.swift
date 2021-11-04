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
    let assembly: String
    let fileName: URL
    
    init(assembly: String, output fileName: URL) {
        self.assembly = assembly
        self.fileName = fileName
    }
    
    func createLLCProcess() throws -> Process {
        let llcExecutable = URL(fileURLWithPath: "/opt/homebrew/opt/llvm/bin/llc")
        
        // Check if llc actually exists
        if !FileManager.default.fileExists(atPath: llcExecutable.path) {
            throw AssemblerError.llcNotFoundError
        }
            
        // Create process with stdin
        let stdIn = Pipe()
        
        let llvmC = Process()
        llvmC.executableURL = llcExecutable
        llvmC.standardInput = stdIn
        
        // Tell the llc compiler to output as object code
        // and optimize
        llvmC.arguments = [
            "-filetype=obj",
            "-o", fileName.appendingPathExtension("o").path,
            "-O3"]
        
        // Write the code to the process standard input
        // so that llc can read it
        try stdIn.fileHandleForWriting.write(
            contentsOf: assembly.data(using: .utf8) ?? { throw AssemblerError.invalidAssembly }())
        // close the pipe so that llc will get the EOI marker
        try stdIn.fileHandleForWriting.close()
        
        return llvmC
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
        // Execute llc and clang to create an object file and then
        // convert it into a platform executable
        try execProcess(process: try createLLCProcess())
        try execProcess(process: try createClangProcess())
        
        // Delete the temporary object file after compiling the final executable
        try FileManager.default.removeItem(at: fileName.appendingPathExtension("o"))
    }
}
