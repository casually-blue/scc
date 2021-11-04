//
//  main.swift
//  scc
//
//  Created by Admin on 10/30/21.
//

import Foundation
import ArgumentParser

struct Main: ParsableCommand {
    @Argument() var inputFiles: [String]
    @Option(name: [
        .customLong("output"),
        .customShort("o"),
    ])
    var outputFile: String?
    
    @Flag()
    var verbose: Int
    
    mutating func run() throws {
        
        // Set output file to a sane default if it doesn't exist
        if case .none = outputFile {
            outputFile = URL(fileURLWithPath: inputFiles[inputFiles.startIndex])
                .deletingPathExtension().path
        }
        
        // basic code to test on
        // TODO: Replace with actual file input
        let code: String = """
        fun main() -> int {
            return 44 + 5;
        }
        """
        
        let lexer = Lexer(input: code)
        
        // Lex the code
        let tokens = lexer.lex()
        for token in tokens {
            print(token)
        }
        
        // Parse the tokens
        var parser = Parser(tokens: tokens)
        let program = try parser.parse()
        print(program)
        
        // Convert the ast into llvm assembly
        let generator = Generator(ast: program)
        let assembly = try generator.generate()
        
        // invoke the llvm compiler to create a real binary
        let assembler = Assembler(assembly: assembly,
                                  output: URL(
                                    fileURLWithPath: outputFile ?? "a.out"))
        try assembler.assemble()
    }
}

Main.main()

