//
//  main.swift
//  scc
//

import Foundation
extension Main {
    
    /// Run the program with command line arguments from `ArgumentParser`
    mutating func run() throws {
        // deduplicate input files
        inputFiles = Array(Set(inputFiles))
        
        do {
            guard let input = inputFiles.first else {
                return
            }
            
            let code = try String(contentsOf: input)
            
            // Lex the code
            let tokens = Lexer(input: code).lex()
            
            // Parse the tokens
            var parser = Parser(tokens: tokens)
            let ast = try parser.parse()
            
            // print out the syntax tree
            print("\(ast)\n")
            
            // Convert the ast into llvm assembly
            var generator = try Generator(ast: ast)
            try generator.generate(to: outputFile.appendingPathExtension("o"))
            
            // invoke the llvm compiler to create a real binary
            try Assembler(output: outputFile).assemble()
            
        } catch let e{
            print(e)
        }
    }
}
