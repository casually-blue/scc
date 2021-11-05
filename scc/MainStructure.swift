//
//  MainStructure.swift
//  scc
//
//  Created by Admin on 11/5/21.
//

import Foundation
import ArgumentParser

@main
/// The Data structure that holds CLI Arguments
struct Main: ParsableCommand {
    
    /// A list of input code files
    @Argument() var inputFiles: [URL]
    
    
    @Option(name: [
        .customLong("output"),
        .customShort("o"),
    ])
    /// code output file with default value
    var outputFile: URL = URL(fileURLWithPath: "a.out")
    
    @Flag()
    /// Set how verbose the program should be in it's output
    var verbose: Int
}
