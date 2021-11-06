//
//  InputProto.swift
//  scc
//
//  Created by Admin on 11/1/21.
//

import Foundation
import ArgumentParser

protocol InputProto {
    func peekNext() -> Character?
    mutating func getNext() -> Character?
    mutating func goBack()
    
    func getCurrentPosition() -> FilePoint

}

struct StringInput: InputProto {
    let input: String
    var currentIndex: String.Index
        
    var currentPosition: FilePoint = FilePoint(row: 0, col: 0)
    
    var lineEnds: Dictionary<Int, Int> = Dictionary()
    
    init(input: String) {
        self.input = input
        self.currentIndex = input.startIndex
    }
    
    func peekNext() -> Character? {
        if currentIndex < input.endIndex {
            return input[currentIndex]
        } else {
            return nil
        }
    }
    
    mutating func getNext() -> Character? {
        let c = peekNext()
        
        currentIndex = input.index(after: currentIndex)
        
        if currentIndex >= input.endIndex {
            return c
        }
        
        if input[currentIndex] == "\n" {
            lineEnds[currentPosition.row] = currentPosition.col
            currentPosition.row += 1
            currentPosition.col = 0
        } else {
            currentPosition.col  += 1
        }
        
        return c
    }
    
    mutating func goBack() {
        if input[currentIndex] == "\n" {
            if let end = lineEnds[currentPosition.row - 1] {
                currentPosition.row -= 1
                currentPosition.col = end
            }
        } else {
            currentPosition.col -= 1
        }
        
        currentIndex = input.index(before: currentIndex)
    }
    
    func getCurrentPosition() -> FilePoint {
        currentPosition
    }
    
    
}



struct FileInput: InputProto {
    let fileName: String
    
    let fileStream: FileStream
    var currentIndex: UInt64
    
    init(fileName: String) throws {
        
        fileStream = try FileStream(path: fileName)
        
        self.fileName = fileName
        self.currentIndex = 0
    }
    
    func peekNext() -> Character? {
        nil
    }
    
    func getNext() -> Character? {
        nil
    }
    
    func goBack() {
    }
    
    func getCurrentPosition() -> FilePoint {
        FilePoint(row: 0, col: 0)
    }
    
        
}
