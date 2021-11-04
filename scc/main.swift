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
        
        let lexer = Lexer(input: """
        int main(void) {
            return 0 +
                0 * test();
        }
        
        int test(void) {
            return 1 + 1;
        }
        """)
        
        let tokens = lexer.lex()
        for token in tokens {
            print(token)
        }
        
        var parser = Parser(tokens: tokens)
        let fn = try parser.parse()
        print(fn)
        
        let generator = Generator(ast: fn)
        let assembly = try generator.generate()
        
        let assembler = Assembler(assembly: assembly,
                                  output: URL(
                                    fileURLWithPath: outputFile ?? "a.out"))
        try assembler.assemble()
    }
}

Main.main()

