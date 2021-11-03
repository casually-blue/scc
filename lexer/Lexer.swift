//
//  Lexr.swift
//  scc
//
//  Created by Admin on 10/30/21.
//

import Foundation


class Lexer {
    var input: InputProto
        
    init(input: String) {
        self.input = StringInput(input: input)
    }
    
    init(fileName: String) throws {
        self.input = try FileInput(fileName: fileName)
    }
    
    func lex() -> [Token] {
        var tokens = [Token]();
        
        while let tok = getNextToken() {
            tokens.append(tok)
        }
        
        return tokens
    }
    
    func getIdentifier() -> Token? {
        var ident: String = ""
        let startPos = input.getCurrentPosition()
        while input.peekNext()?.isAlnum ?? false && input.peekNext() != nil {
            ident.append(input.getNext()!)
        }
        let endPos = input.getCurrentPosition()
        
        return Token (
            type: TokenType.identifier(ident),
            location: Span(position: startPos,
                           file: "string",
                           length: endPos.col - startPos.col))
        
    }
    
    func getInteger() -> Token? {
        var num: Int = 0
        let startPos = input.getCurrentPosition()
        while input.peekNext()?.isNumber ?? false && input.peekNext() != nil {
            num = num*10 + (input.getNext()?.wholeNumberValue)!
        }
        let endPos = input.getCurrentPosition()
        
        return Token(
            type: TokenType.number(num),
            location: Span(position: startPos,
                           file: "string",
                           length: endPos.col - startPos.col))
    }
    
    func getSCToken() -> Token? {
        if let c = input.peekNext() {
            let startPos = input.getCurrentPosition()
            let type: TokenType
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
                type = TokenType.minus
            case "*":
                type = TokenType.times
            case "/":
                type = TokenType.div
            case "%":
                type = TokenType.mod
            default:
                type = TokenType.comma
            }
            _ = input.getNext()
            let endPos = input.getCurrentPosition()
            
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
    
    func getNextToken() -> Token? {
        if let c = input.peekNext() {
            switch c {
            case let c where c.isAlpha:
                return getIdentifier()
            case let c where c.isNumeric:
                return getInteger()
            case let c where c.isWhitespace:
                while input.peekNext()?.isWhitespace ?? false {
                    _ = input.getNext()
                }
                return getNextToken()
            case "(", ")", "{", "}", ";", "+", "-", "*", "/", "%":
                return getSCToken()
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
