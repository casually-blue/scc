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
        case .assignment(let variable, let expr): return "assign: \(variable) = \(expr)"
        case .empty: return ""
        }
    }
    
    case expression(Expression)
    case `return`(Expression)
    case assignment(String, Expression)
    case empty
}

enum OperatorError: Error {
    case InvalidValueError
}

enum Operator: CustomStringConvertible {
    case plus, minus
    case times, div, mod
    
    init(_ type: TokenType) throws {
        switch type {
        case .plus: self = .plus
        case .minus: self = .minus
        case .times: self = .times
        case .div: self = .div
        case .mod: self = .mod
        default: throw OperatorError.InvalidValueError
        }
    }
    
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
        case .number(let value): return "(expr: \(value))"
        case .operation(left: let left, op: let op, right: let right):
            return "\(left) \(op) \(right)"
        case .call(name: let name): return "\(name)()"
        case .variable(name: let name): return "\(name)"
        }
    }
    
    
    
    case number(Int)
    case operation(left: Expression, op: Operator, right: Expression)
    case call(name: String)
    case variable(name: String)
}
