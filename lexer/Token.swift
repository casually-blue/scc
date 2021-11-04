//
//  Token.swift
//  scc
//
//  Created by Admin on 10/30/21.
//

import Foundation

// The type of tokens with associated values if they have one
enum TokenType: CustomStringConvertible, Equatable {
    case leftParen, rightParen, leftBracket, rightBracket, leftBrace, rightBrace
    case comma, semicolon, colon
    case plus, minus, times, div, mod
    case identifier(String)
    case number(Int)
    case `string`(String)
    
    public var description: String {
        switch(self) {
        case .leftParen: return "'('"
        case .rightParen: return "')'"
        case .leftBrace: return "'{'"
        case .rightBrace: return "'}'"
        case .leftBracket: return "'['"
        case .rightBracket: return "']'"
            
        case .plus: return "'+'"
        case .minus: return "'-'"
            
        case .times: return "'*'"
        case .div: return "'/'"
        case .mod: return "'%'"
            
        case .colon: return "':'"
        case .semicolon: return "';'"
        case .comma: return "','"
            
        case .identifier(let value): return "Identifier: '\(value)'"
        case .string(let value): return "String: '\(value)'"
        case .number(let value): return "Integer: '\(value)'"
        }
    }
}

struct FilePoint: CustomStringConvertible {
    var row: Int
    var col: Int
    
    public var description: String {
        return "\(row):\(col)"
    }
}

// A location and length in the code
// so that the compiler can give good error messages
struct Span: CustomStringConvertible {
    var position: FilePoint
    var file: String
    var length: Int
    
    public var description: String {
        return "\(position):\(file)"
    }
}

// The main token object with a type and a location
struct Token: CustomStringConvertible {
    var type: TokenType
    var location: Span
    
    public var description: String {
        return "(\(location)): \(type)"
    }
}

