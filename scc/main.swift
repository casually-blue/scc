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
                .deletingPathExtension()
                .relativeString
        }
    }
}

Main.main()

