//
//  NetworkOperationQueue.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation

class NetworkOperationQueue {
    static let shared = {
        NetworkOperationQueue()
    }()
    
    private let queue: OperationQueue
    
    private init() {
        queue = OperationQueue()
    }
    
    func addOperation(completion: @escaping (()->())) {
        let operation = Operation()
        operation.completionBlock = {
            completion()
        }
        
        queue.addOperation(operation)
    }
    
    func addOperation(_ operation: AsyncOperation) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.queue.addOperations([operation], waitUntilFinished: false)
        }
    }
}
