//
//  Token.swift
//  scc
//
//  Created by Admin on 10/30/21.
//

import Foundation

/// Token Types with their associated values if necessary
enum TokenType: CustomStringConvertible, Equatable {
    
    case leftParen, rightParen, leftBracket, rightBracket, leftBrace, rightBrace
    case comma, semicolon, colon
    case plus, minus, times, div, mod
    
    case to
    
    case identifier(String)
    case number(Int)
    case `string`(String)
    
    
    /// Generate a string representation for the token's type
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
            
        case .to: return "->"
            
        case .identifier(let value): return "Identifier: '\(value)'"
        case .string(let value): return "String: '\(value)'"
        case .number(let value): return "Integer: '\(value)'"
        }
    }
}


/// A location in a file or (technically) anything with a row and col position
struct FilePoint: CustomStringConvertible {
    var row: Int
    var col: Int
    
    
    /// String Representation `row:col` of a file position
    public var description: String {
        return "\(row):\(col)"
    }
}


/// A description of the file and a vector of the token's position and size
struct Span: CustomStringConvertible {
    
    /// The location of the token's start
    var position: FilePoint
    
    /// The name of the file the token is from
    var file: String
    
    /// The length in characters of the token
    var length: Int
    
    
    /// string representation of the token's position
    public var description: String {
        return "\(position):\(file)"
    }
}

/// Actual token structure with it's type and location in the source
struct Token: CustomStringConvertible {
    
    /// The Type of the token
    var type: TokenType
    
    /// The position of the token
    var location: Span
    
    
    /// String representation of the token and its position
    public var description: String {
        return "(\(location)): \(type)"
    }
}

