//
//  Token.swift
//  scc
//
//  Created by Admin on 10/30/21.
//

import Foundation

enum TokenType: CustomStringConvertible {
    case leftParen, rightParen, leftBracket, rightBracket, leftBrace, rightBrace
    case comma, semicolon, colon
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
            
        case .colon: return "':'"
        case .semicolon: return "';'"
        case .comma: return "','"
            
        case .identifier(let value): return "Identifier: '\(value)'"
        case .string(let value): return "String: '\(value)'"
        case .number(let value): return "Integer: '\(value)'"
        }
    }
}


struct Span: CustomStringConvertible {
    var row: Int
    var col: Int
    var file: String
    var length: Int
    
    public var description: String {
        return "\(row):\(col):\(file)"
    }
}

struct Token: CustomStringConvertible {
    var type: TokenType
    var location: Span
    
    public var description: String {
        return "(\(location)): \(type)"
    }
}

