//
//  MainStructure.swift
//  scc
//
//  Created by Admin on 11/5/21.
//

import Foundation
import ArgumentParser

@main
struct Main: ParsableCommand {
    @Argument() var inputFiles: [URL]
    @Option(name: [
        .customLong("output"),
        .customShort("o"),
    ])
    var outputFile: URL?
    
    @Flag()
    var verbose: Int
}
