//
//  Generator.swift
//  scc
//
//  Created by Admin on 11/4/21.
//

import Foundation

struct Generator {
    let ast: Program
    
    init(ast: Program) {
        self.ast =  ast
    }
    
    func generate() throws -> String {
        var assembly = ""
        
        for tu in ast.translationUnits {
            if case let .Function(f) = tu {
                assembly.append(try generateFunction(f))
            }
        }
        
        return assembly
    }
    
    func generateFunction(_ function: Function) throws -> String {
        let type: String
        switch function.type {
        case "int": type = "i32"
        default: type = "i32"
        }
        
        let name = "@\(function.name)"
        
        var body = ""
        for stmt in function.body {
            body.append(try generateStatement(stmt))
        }
        
        return "define \(type) \(name)() { \(body) }\n"
    }
    
    func generateStatement(_ statement: Statement) throws -> String {
        switch statement {
        case .expression(_):
            return ""
        case .return(_):
            return "ret i32 0"
        case .empty:
            return ""
        }
    }
}
