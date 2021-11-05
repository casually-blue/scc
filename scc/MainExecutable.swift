//
//  main.swift
//  scc
//
//  Created by Admin on 10/30/21.
//

import Foundation
extension Main {
    mutating func run() throws {
        // Set output file to a sane default if it doesn't exist
        if case .none = outputFile {
            outputFile = inputFiles[inputFiles.startIndex].deletingPathExtension()
        }
        
        // basic code to test on
        // TODO: Replace with actual file input
        let code: String = """
        fun main() -> int {
            return 10 + testing() * 3;
        }
        
        fun testing() -> int {
            return 7 - 3;
        }
        """
        
        let lexer = Lexer(input: code)
        
        // Lex the code
        let tokens = lexer.lex()
        for token in tokens {
            print("\(token)")
        }
        print("\n")
        
        // Parse the tokens
        var parser = Parser(tokens: tokens)
        let program = try parser.parse()
        print("\(program)\n")
        
        // Convert the ast into llvm assembly
        var generator = try Generator(ast: program)
        try generator.generate(to: outputFile!.appendingPathExtension("o"))
        
        // invoke the llvm compiler to create a real binary
        let assembler = Assembler(output: outputFile!)
        try assembler.assemble()
    }
}
