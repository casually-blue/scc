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
        // if we have a token return it, otherwise throw an error
        if index < tokens.endIndex {
            return tokens[index]
        }
        
        throw ParserError.EndOfTokens
    }
    
    // move to the next index
    // TODO: there's probably a better way to do this
    mutating func advanceToken() {
        index += 1
    }
    
    // match with a token's type and error if it is invalid
    mutating func match(expected: TokenType) throws {
        guard expected == (try currentToken()).type else {
            throw ParserError.Expected(expected: expected.description,
                                       actual: (try currentToken().type.description))
        }
        
        advanceToken()
    }
    
    // match with an identifier and assert that it has a specific value
    mutating func match(identifier: String) throws {
        guard TokenType.identifier(identifier) == (try currentToken()).type else {
            throw ParserError.Expected(expected: identifier,
                                       actual: try currentToken().type.description)
        }
        advanceToken()

    }
    
    // assert that the next identifier is in an array of token types
    mutating func match(oneOf possibleTypes: [TokenType]) throws -> TokenType {
        if !possibleTypes.contains(try currentToken().type) {
            throw ParserError.Expected(expected: "one of \(possibleTypes)",
                                       actual: try currentToken().type.description)
        }
        let type = try currentToken().type
        advanceToken()
        return type
    }
    
    // get and return the value of the next token if it is an identifier
    // otherwize throw exception
    mutating func getIdentifier() throws -> String {
        guard case let TokenType.identifier(ident) = try currentToken().type else {
            throw ParserError.Expected(expected: "Identifier",
                                       actual: try currentToken().type.description)
        }
        
        advanceToken()
        
        return ident
    }
    
    // get and return the value of the next token if it is a number
    // otherwise throw exception
    mutating func getNumber() throws -> Int {
        guard case let TokenType.number(num) = try currentToken().type else {
            throw ParserError.Expected(expected: "Number",
                                       actual: try currentToken().type.description)
        }
        
        advanceToken()
        
        return num
    }
    
    // until the end of the tokens
    // parse translation units and put them in the body of the program
    mutating func parse() throws -> Program {
        var tUs: [TranslationUnit] = []
        while index < tokens.endIndex {
            tUs.append(TranslationUnit.Function(try parseFunction()))
        }
        
        return Program(translationUnits: tUs)
        }
    
    // parse through a function storing the necessary data
    mutating func parseFunction() throws -> Function {
        try match(identifier: "fun")
        
        let name = try getIdentifier()
        
        try match(expected: .leftParen)
        try match(expected: .rightParen)
        try match(expected: .to)
        
        // get the return type
        let type = try getIdentifier()
        
        try match(expected: .leftBrace)
        
        var stmts: [Statement] = []
        
        // parse the statements of the function body
        while try currentToken().type != .rightBrace {
            stmts.append(try parseStatement())
        }
        
        // make sure the function has an end
        try match(expected: .rightBrace)
        
        return Function(name: name, type: type, body: stmts)
    }
    
    mutating func parseStatement() throws -> Statement {
        let stmt: Statement
        
        // parse either a return statement or just a bare statement
        switch try currentToken().type {
        case .identifier("return"):
            advanceToken()
            stmt = Statement.return(try parseExpression())
        case .identifier("let"):
            advanceToken()
            let name = try getIdentifier()
            try match(expected: .assign)
            stmt = Statement.assignment(name, try parseExpression())
        default:
            stmt = Statement.expression(try parseExpression())
        }
        // make sure the statement ends
        try match(expected: .semicolon)
        
        return stmt
    }
    
    mutating func parseExpression() throws -> Expression {
        return try parseAddition()
    }
    
    mutating func parseAddition() throws -> Expression {
        // get the left hand side of the expression
        let left = try parseMultiplication()
        do {
            // if there is an operation, we recurse until there isn't
            let op = try Operator(try match(oneOf: [.plus, .minus]))
            
            return Expression.operation(left: left, op: op, right: try parseAddition())
        } catch {
            // if not, we just return the operation
            return left
        }
    }
    
    mutating func parseMultiplication() throws -> Expression {
        // get the left hand side of the expression
        let left = try parseFactor()
        do {
            // if there is an operator we recurse until there isn't
            let op = try Operator(try match(oneOf: [.times, .div, .mod]))
            
            return Expression.operation(left: left, op: op, right: try parseMultiplication())
        } catch {
            // otherwise we just return the operation
            return left
        }
    }
    
    mutating func parseCall() throws -> Expression {
        // get the name of the function called
        let name = try getIdentifier()
        try match(expected: .leftParen)
        try match(expected: .rightParen)
        
        return .call(name: name)
    }
    
    mutating func parseFactor() throws -> Expression {
        // if we have a parenthesized expression parse it
        if try currentToken().type == .leftParen {
            try match(expected: .leftParen)
            let expr = try parseExpression()
            try match(expected: .rightParen)
            return expr
        // otherwise parse a call to a function
        } else if case .identifier(_) = (try currentToken()).type {
            return try parseCall()
        // otherwise we must have a number
        } else {
            return .number(try getNumber())
        }
        
    }
}
