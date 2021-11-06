//
//  LLVMAssembler.swift
//  scc
//
//  Created by Admin on 11/4/21.
//

import Foundation
import LLVM

enum AssemblerError: Error {
    case assemblerNotFound(String)
    case invalidAssembly
}

struct Assembler {
    let fileName: URL
    
    init(output fileName: URL) {
        self.fileName = fileName
    }
    
    func which(_ program: String) throws -> URL? {
        let which = URL(fileURLWithPath: "/usr/bin/which")
        let wProc = Process()
        wProc.executableURL = which
        wProc.arguments = [program]
        
        let out = Pipe()
        wProc.standardOutput = out
        
        try wProc.run()
        wProc.waitUntilExit()
        
        if(wProc.terminationStatus != 0) {
            throw AssemblerError.assemblerNotFound("clang")
        }
                
        let val = String(data: out.fileHandleForReading.availableData, encoding: .utf8)!
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return URL(fileURLWithPath: val)
        
    }
    
    func createClangProcess() throws -> Process {
        // Create the process
        let clang = Process()
                
#if os(macOS) || os(Linux)
        clang.executableURL = try which("clang")
#elseif os(Windows)
        clang.executableURL = URL("clang")
#endif
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
