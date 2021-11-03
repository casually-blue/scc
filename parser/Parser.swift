//
//  Parser.swift
//  scc
//
//  Created by Admin on 11/3/21.
//

import Foundation

enum ParserError: Error {
    case EndOfTokens
    case Expected(expected: String, actual: String)
    case UnknownError
}

struct Parser {
    let tokens: [Token]
    var index: Int
    
    init(tokens: [Token]){
        self.tokens = tokens
        self.index = tokens.startIndex
    }
    
    func currentToken() throws -> Token  {
        if index < tokens.endIndex {
            return tokens[index]
        }
        
        throw ParserError.EndOfTokens
    }
    
    mutating func advanceToken() {
        index += 1
    }
    
    mutating func match(expected: TokenType) throws {
        guard expected == (try currentToken()).type else {
            throw ParserError.Expected(expected: expected.description,
                                       actual: (try currentToken().type.description))
        }
        
        advanceToken()
    }
    
    mutating func match(identifier: String) throws {
        guard TokenType.identifier(identifier) == (try currentToken()).type else {
            throw ParserError.Expected(expected: identifier,
                                       actual: try currentToken().type.description)
        }
        advanceToken()

    }
    
    mutating func match(oneOf possibleTypes: [TokenType]) throws -> TokenType? {
        if !possibleTypes.contains(try currentToken().type) {
            throw ParserError.Expected(expected: "one of \(possibleTypes)",
                                       actual: try currentToken().type.description)
        }
        let type = try currentToken().type
        advanceToken()
        return type
    }
    
    mutating func getIdentifier() throws -> String {
        guard case let TokenType.identifier(ident) = try currentToken().type else {
            throw ParserError.Expected(expected: "Identifier",
                                       actual: try currentToken().type.description)
        }
        
        advanceToken()
        
        return ident
    }
    
    mutating func getNumber() throws -> Int {
        guard case let TokenType.number(num) = try currentToken().type else {
            throw ParserError.Expected(expected: "Number",
                                       actual: try currentToken().type.description)
        }
        
        advanceToken()
        
        return num
    }
    
    mutating func parse() throws -> Program {
        var tUs: [TranslationUnit] = []
        
        while let f =  try parseFunction() {
            tUs.append(TranslationUnit.Function(f))
            if index >= tokens.endIndex {
                break
            }
        }
        
        return Program(translationUnits: tUs)
    }
    
    mutating func parseFunction() throws -> Function? {
        let typeName = try getIdentifier()
        
        let fnName = try getIdentifier()
        
        try match(expected: .leftParen)
        
        try match(identifier: "void")
        
        try match(expected: .rightParen)
        
        try match(expected: .leftBrace)
        
        var stmts: [Statement] = []
        
        while try currentToken().type != .rightBrace {
            stmts.append(try parseStatement())
        }
        
        try match(expected: .rightBrace)
        
        return Function(name: fnName, type: typeName, body: stmts)
    }
    
    mutating func parseStatement() throws -> Statement {
        let stmt: Statement
        do {
            try match(identifier: "return")
            let expr = try parseExpression()
            stmt = Statement.return(expr)
        } catch ParserError.Expected(expected: _, actual: _) {
            let expr = try parseExpression()
            stmt =  Statement.expression(expr)
        }
        
        try match(expected: .semicolon)
        
        return stmt
    }
    
    mutating func parseExpression() throws -> Expression {
        return try parseAddition()
    }
    
    mutating func parseAddition() throws -> Expression {
        let left = try parseMultiplication()
        do {
            let op: Operator
            switch try match(oneOf: [.plus, .minus]) {
            case .plus: op = .plus
            case .minus: op = .minus
            default: throw ParserError.UnknownError
            }
            
            return Expression.operation(left: left, op: op, right: try parseAddition())
        } catch {
            return left
        }
    }
    
    mutating func parseMultiplication() throws -> Expression {
        let left = try parseFactor()
        do {
            let op: Operator
            switch try match(oneOf: [.times, .div, .mod]) {
            case .times: op = .times
            case .div: op = .div
            case .mod: op = .mod
            default: throw ParserError.UnknownError
            }
            
            return Expression.operation(left: left, op: op, right: try parseMultiplication())
        } catch {
            return left
        }
    }
    
    mutating func parseCall() throws -> Expression {
        let name = try getIdentifier()
        try match(expected: .leftParen)
        try match(expected: .rightParen)
        
        return .call(name: name)
    }
    
    mutating func parseFactor() throws -> Expression {
        if try currentToken().type == .leftParen {
            try match(expected: .leftParen)
            let expr = try parseExpression()
            try match(expected: .rightParen)
            return expr
        } else if case .identifier(_) = (try currentToken()).type {
            return try parseCall()
        } else {
            return .Number(try getNumber())
        }
        
    }
}
