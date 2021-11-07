//
//  File.swift
//  
//
//  Created by Admin on 11/6/21.
//

import Foundation
import LLVM

class VariableScope {
    var parent: VariableScope? = nil
    var this: [String: IRValue] = [:]
    
    init() {
        
    }
    
    init(parent: VariableScope) {
        self.parent = parent
    }
    

     func add(name: String, value: IRValue) {
        this[name] = value
    }
    
    func lookup(_ name: String) -> IRValue? {
        return this[name] ?? parent?.lookup(name)
    }
}
