//
//  CharacterExtensions.swift
//  scc
//
//  Created by Admin on 10/31/21.
//

import Foundation

extension Character {
    var value: Int32 {
        return Int32(String(self).unicodeScalars.first!.value)
    }
    
    var isSpace: Bool {
        return isspace(value) != 0
    }
    
    var isAlnum: Bool {
        return isAlpha || isNumeric || self == "_"
    }
    
    var isNumeric: Bool {
        return isdigit(value) != 0
    }
    
    var isAlpha: Bool {
        return isalpha(value) != 0
    }
}

