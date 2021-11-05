//
//  Lexr.swift
//  scc
//
//  Created by Admin on 10/30/21.
//

import Foundation


class Lexer {
    var input: InputProto
        
    // parse tokens from a string
    init(input: String) {
        self.input = StringInput(input: input)
    }
    
    // parse tokens from a file
    // TODO: actually implement this
    init(fileName: String) throws {
        self.input = try FileInput(fileName: fileName)
    }
    
    func lex() -> [Token] {
        var tokens = [Token]();
        
        // until we have no token get the next one and add it to the list
        while let tok = getNextToken() {
            tokens.append(tok)
        }
        
        return tokens
    }
    
    func getIdentifier() -> Token? {
        var ident: String = ""
        
        // store the current position
        let startPos = input.getCurrentPosition()
        
        // while the next character is a possible identifier char
        // add it to the string
        while input.peekNext()?.isAlnum ?? false && input.peekNext() != nil {
            ident.append(input.getNext()!)
        }
        
        // store the current position
        let endPos = input.getCurrentPosition()
        
        return Token (
            type: TokenType.identifier(ident),
            location: Span(position: startPos,
                           file: "string",
                           length: endPos.col - startPos.col))
        
    }
    
    func getInteger() -> Token? {
        var num: Int = 0
        
        // store the current position
        let startPos = input.getCurrentPosition()
        
        // while the character is a digit
        // add its place value to the accumulator
        while input.peekNext()?.isNumber ?? false && input.peekNext() != nil {
            num = num*10 + (input.getNext()?.wholeNumberValue)!
        }
        
        // store the current position
        let endPos = input.getCurrentPosition()
        
        // return the number and position information
        return Token(
            type: TokenType.number(num),
            location: Span(position: startPos,
                           file: "string",
                           length: endPos.col - startPos.col))
    }
    
    
    func getOperatorToken() -> Token? {
        // grab the next character and get its type
        if let c = input.getNext() {
            // store the current position
            let startPos = input.getCurrentPosition()
            let type: TokenType
            // check that the next value is a possible token and do the type mapping
            switch(c){
            case "(":
                type = TokenType.leftParen
            case ")":
                type = TokenType.rightParen
            case "{":
                type = TokenType.leftBrace
            case "}":
                type = TokenType.rightBrace
            case ";":
                type = TokenType.semicolon
            case "+":
                type = TokenType.plus
            case "-":
                if .some(">") == input.getNext() {
                    type = TokenType.to
                } else {
                    input.goBack()
                    type = TokenType.minus
                }
            case ":":
                if .some("=") == input.getNext() {
                    type = TokenType.assign
                } else {
                    input.goBack()
                    type = TokenType.colon
                }
            case "*":
                type = TokenType.times
            case "/":
                type = TokenType.div
            case "%":
                type = TokenType.mod
            case ",":
                type = TokenType.comma
            default:
                return nil
            }
            
            // save the current position
            let endPos = input.getCurrentPosition()
            
            // return the type and calculate the token span
            return Token(
                type: type,
                location: Span(
                    position: startPos,
                    file: "string",
                    length: endPos.col - startPos.col)
            )
        }
        
        return nil
    }
    
    // Find and return the next token in the input
    func getNextToken() -> Token? {
        if let c = input.peekNext() {
            switch c {
            // parse tokens have values associated
            case let c where c.isAlpha:
                return getIdentifier()
            case let c where c.isNumeric:
                return getInteger()
            // skip whitespace
            case let c where c.isWhitespace:
                while input.peekNext()?.isWhitespace ?? false {
                    _ = input.getNext()
                }
                // actually get the token
                return getNextToken()
            // get a token that is only one character
            case "(", ")", "{", "}", ";", "+", "-", "*", "/", "%", ":":
                return getOperatorToken()
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
