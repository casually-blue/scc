//
//  Stack.swift
//  scc
//
//  Created by Admin on 10/31/21.
//

import Foundation

public struct Stack<T> {
    private var internalValue: [T] = []
    
    mutating func push(_ element: T) {
        internalValue.append(element)
    }
    
    mutating func pop() -> T? {
        internalValue.popLast()
    }
    
    func peek() -> T? {
        if internalValue.isEmpty {
            return nil
        } else {
            let lastValidIndex = internalValue.index(before: internalValue.endIndex)
            return internalValue[lastValidIndex]
        }
    }
}
