//
//  URLExtensions.swift
//  scc
//
//  Created by Admin on 11/5/21.
//

import Foundation
import ArgumentParser

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self = URL(fileURLWithPath: argument)
    }
    
}
