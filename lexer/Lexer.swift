//
//  Lexr.swift
//  scc
//
//  Created by Admin on 10/30/21.
//

import Foundation


class Lexer {
    let input: String
    var index: String.Index
    
    var lineEnds: Stack<Int> = Stack<Int>()
    var position: FilePoint = FilePoint(row: 0,col: 0)
    
    init(input: String) {
        self.input = input
        self.index = input.startIndex
    }
    
    func lex() -> [Token] {
        var tokens = [Token]();
        
        while let tok = getNextToken() {
            tokens.append(tok)
        }
        
        return tokens
    }
    
    func getNextToken() -> Token? {
        return nil
        
    }
}
