//
//  AsyncOperation.swift
//  SomeApp
//
//  Created by Mykyta Vintonovych on 25.12.2020.
//

import Foundation

// MARK: - AsyncOperation

open class AsyncOperation: Operation {
    
    public enum State: String {
        case ready
        case executing
        case finished
        
        fileprivate var keyPath: String {
            return "is\(rawValue.capitalized)"
        }
    }
    
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

// MARK: - Override

extension AsyncOperation {
    
    override open var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override open var isExecuting: Bool {
        return state == .executing
    }
    
    override open var isFinished: Bool {
        return state == .finished
    }
    
    override open var isAsynchronous: Bool {
        return true
    }
    
    override open func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    open override func cancel() {
        super.cancel()
        state = .finished
    }
}
