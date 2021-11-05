//
//  Generator.swift
//  scc
//
//  Created by Admin on 11/4/21.
//

import Foundation
import LLVM

typealias LLVMFunction = LLVM.Function

struct Generator {
    let ast: Program
    let module = Module(name: "main")
    let builder: IRBuilder
    
    
    
    var functions: [String: LLVMFunction] = [:]
    
    let machine: TargetMachine
        
    init(ast: Program) throws {
        self.ast =  ast
        self.builder = IRBuilder(module: module)
            
        machine = try TargetMachine()
    }
        
    mutating func generate(to file: URL) throws {
        for tu in ast.translationUnits {
            if case let .Function(f) = tu {
                let fn = builder.addFunction(f.name, type: FunctionType([], IntType.int32))
                functions[f.name] = fn
            }
        }
        
        for tu in ast.translationUnits {
            if case let .Function(f) = tu {
                try generateFunction(f)
            }
        }
        
        let pipeline = PassPipeliner(module: module)
        
        try module.print(to: file.deletingPathExtension().appendingPathExtension("ll").path)
        
        pipeline.addStandardModulePipeline("mod")
        pipeline.addStandardFunctionPipeline("fun")
        
        pipeline.execute()
        
        try module.print(to: file.deletingPathExtension().appendingPathExtension("llopt").path)
        
        try machine.emitToFile(module: module, type: .object, path: file.path)
    }
    
    func generateFunction(_ function: Function) throws {
        let fn = try functions[function.name] ?? { throw AssemblerError.invalidAssembly }()
        
        let entry = BasicBlock()
        fn.append(entry)
        builder.positionAtEnd(of: entry)
        
        for stmt in function.body {
            try generateStatement(stmt)
        }
    }
    
    func generateStatement(_ statement: Statement) throws {
        switch statement {
        case .expression(_):
            return
        case .return(let expression):
            builder.buildRet(try generateExpression(expression))
        case .empty:
            return
        }
    }
    
    func generateExpression(_ expression: Expression) throws -> IRValue {
        switch expression {
        case .number(let int):
            return IntType.int32.constant(int)
        case .operation(let left, let op, let right):
            let l = try generateExpression(left)
            let r = try generateExpression(right)
            
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
        case .call(let name):
            let fn = try functions[name] ?? { throw AssemblerError.invalidAssembly }()
            return builder.buildCall(fn, args: [])
        }
    }
}
