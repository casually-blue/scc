//
//  AST.swift
//  scc
//
//  Created by Admin on 11/2/21.
//

import Foundation

struct Program: CustomStringConvertible {
    let translationUnits: [TranslationUnit]
    
    var description: String {
        return "\(translationUnits)"
    }
}

enum TranslationUnit: CustomStringConvertible {
    case Function(Function)
    
    var description: String {
        switch self {
        case .Function(let function): return "\(function)"
        }
    }
}

struct Function: CustomStringConvertible {
    var description: String {
        return "\nfunction: \n\t\(name): \(type) = \(body)"
    }
    
    let name: String
    let type: String
    
    let body: [Statement]
    
    
}

enum Statement: CustomStringConvertible {
    var description: String {
        switch self {
        case .expression(let expr): return "\(expr)"
        case .return(let expr): return "return: \(expr)"
        }
    }
    
    case expression(Expression)
    case `return`(Expression)
}

enum Operator: CustomStringConvertible {
    case plus, minus
    case times, div, mod
    
    var description: String {
        switch self {
        case .plus: return "+"
        case .minus: return "-"
        case .times: return "*"
        case .div: return "/"
        case .mod: return "%"
        }
    }
}

indirect enum Expression: CustomStringConvertible {
    var description: String {
        switch self {
        case .Number(let value): return "(expr: \(value))"
        case .operation(left: let left, op: let op, right: let right):
            return "\(left) \(op) \(right)"
        case .call(name: let name): return "\(name)()"
        }
    }
    
    case Number(Int)
    case operation(left: Expression, op: Operator, right: Expression)
    case call(name: String)
}
