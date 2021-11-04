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
        
        if !FileManager.default.fileExists(atPath: llcExecutable.path) {
            throw AssemblerError.llcNotFoundError
        }
            
        let stdIn = Pipe()
        
        let llvmC = Process()
        llvmC.executableURL = llcExecutable
        llvmC.standardInput = stdIn
        
        llvmC.arguments = [
            "-filetype=obj",
            "-o", fileName.appendingPathExtension("o").path,
            "-O3"]
        
        try stdIn.fileHandleForWriting.write(
            contentsOf: assembly.data(using: .utf8)!)
        try stdIn.fileHandleForWriting.close()
        
        return llvmC
    }
    
    func createClangProcess() throws -> Process {
        let clangExecutable = URL(fileURLWithPath: "/opt/homebrew/opt/llvm/bin/clang")
        
        if !FileManager.default.fileExists(atPath: clangExecutable.path) {
            throw AssemblerError.clangNotFoundError
        }
        
        let clang = Process()
        
        clang.executableURL = clangExecutable
        clang.arguments = [
            fileName.appendingPathExtension("o").path,
            "-o", fileName.path]
        
        return clang
    }
    
    func execProcess(process: Process) throws {
        try process.run()
        process.waitUntilExit()
    }
    
    func assemble() throws {
        try execProcess(process: try createLLCProcess())
        try execProcess(process: try createClangProcess())
        
        try FileManager.default.removeItem(at: fileName.appendingPathExtension("o"))
    }
}
