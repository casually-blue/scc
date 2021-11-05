//
//  Generator.swift
//  scc
//
//  Created by Admin on 11/4/21.
//

import Foundation
import LLVM


/// Code Generation Errors
enum GeneratorError: Error {
    case FunctionNotDeclared(String)
}


typealias LLVMFunction = LLVM.Function

/// The Code Generator for the compiler
///
/// Takes an ast of a program and converts it into a llvm representation
public struct Generator {
    
    /// The program's syntax tree
    let ast: Program
    
    /// The LLVM module that holds the program's code
    let module = Module(name: "main")
    
    /// LLVM Builder for the code generation
    let builder: IRBuilder
    
    /// The local machine type for generating object files
    let machine: TargetMachine
    
    /// Dictionary of defined functions for the program's scope
    var functions: [String: LLVMFunction] = [:]
    
    /// Instantiate a code generator from the ast
    /// - Parameter ast: the syntax tree for the program
    init(ast: Program) throws {
        self.ast =  ast
        
        // setup llvm generators
        self.builder = IRBuilder(module: module)
            
        machine = try TargetMachine()
    }
        
    /// Generate an object file from the attached AST
    /// - Parameter file: the URL of the output file
    ///
    mutating func generate(to file: URL) throws {
        // pre-look through functions for their definitions and add them to the current table
        for tu in ast.translationUnits {
            
            if case let .Function(f) = tu {
                let fn = builder.addFunction(f.name, type: FunctionType([], IntType.int32))
                functions[f.name] = fn
            }
        }
        
        // generate the function code
        for tu in ast.translationUnits {
            if case let .Function(f) = tu {
                try generateFunction(f)
            }
        }
        
        
        // output unoptimized llvm assembly
        try module.print(to: file.deletingPathExtension().appendingPathExtension("ll").path)
        
        // set up module optimizer
        let pipeline = PassPipeliner(module: module)

        pipeline.addStandardModulePipeline("mod")
        pipeline.addStandardFunctionPipeline("fun")
        
        // run optimizations
        pipeline.execute()
        
        // output the optimized llvm assembly
        try module.print(to: file.deletingPathExtension().appendingPathExtension("llopt").path)
        
        // output object file
        try machine.emitToFile(module: module, type: .object, path: file.path)
        
        // output platform assembly
        try machine.emitToFile(module: module, type: .assembly,
                               path: file.deletingPathExtension()
                                .appendingPathExtension("s").path)
    }
    
    /// Generate llvm function from AST
    /// - parameters:
    ///     - function: AST of the function
    ///
    /// - Throws: An error of type `GeneratorError`
    func generateFunction(_ function: Function) throws {
        // get the module function reference
        let fn = try functions[function.name] ?? { throw GeneratorError.FunctionNotDeclared(function.name) }()
        
        // add a unnamed block to the function
        let entry = BasicBlock()
        fn.append(entry)
        builder.positionAtEnd(of: entry)
        
        // generate body
        for stmt in function.body {
            try generateStatement(stmt)
        }
    }
    
    
    /// Generate the llvm code for a statement
    /// - Parameters:
    ///     - statement: the AST of the statement
    /// - Throws: An error of type `GeneratorError`
    func generateStatement(_ statement: Statement) throws {
        switch statement {
        case .expression(_):
            return
        // generate a return from the function
        case .return(let expression):
            builder.buildRet(try generateExpression(expression))
        case .empty:
            return
        }
    }
    
    /// Generate the code for an Expression
    /// - Parameter expression: the AST of the expression
    /// - Returns: A LLVM reference to the value of the expression
    func generateExpression(_ expression: Expression) throws -> IRValue {
        switch expression {
        // create a llvm constant
        case .number(let int):
            return IntType.int32.constant(int)
        case .operation(let left, let op, let right):
            // pre-generate each sub-expression
            let l = try generateExpression(left)
            let r = try generateExpression(right)
            
            // build this level of the expression based on the operator
            switch op {
            case .plus:
                return builder.buildAdd(l, r)
            case .minus:
                return builder.buildSub(l, r)
            case .times:
                return builder.buildMul(l, r)
            case .div:
                return builder.buildDiv(l, r)
            case .mod:
                return builder.buildRem(l, r)
            }
        // lookup the function and create a call to it
        case .call(let name):
            let fn = try functions[name] ?? { throw AssemblerError.invalidAssembly }()
            return builder.buildCall(fn, args: [])
        }
    }
}
