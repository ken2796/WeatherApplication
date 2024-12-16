//
//  NetworkOperation.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation
import Reachability

extension Notification.Name {
    static let NetworkConnectionChanged = Notification.Name("NetworkConnectionChanged")
}

final class NetworkOperation: AsyncOperation {
    
    private let session: URLSession
    
    private let request: URLRequest
    private var task: URLSessionTask?
    private let completion: (Data?, HTTPURLResponse?, Error?)->()
    
    init(session: URLSession, request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?)->()) {
        self.session = session
        self.request = request
        self.completion = completion
    }
    
    override func main() {
        attemptRequest()
    }
    
    private func attemptRequest() {
        task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }
            if (NetworkManager.shared.reachability).connection != .unavailable {
                guard let httpResponse = response as? HTTPURLResponse
                else {
                    self.completion(nil, nil, error)
                    return
                }
                self.completion(data, httpResponse, error)
                self.finish()
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(self.handleChangeInNetworkConnection), name: .NetworkConnectionChanged, object: nil)
            }
        })
        task?.resume()
    }
    
    @objc func handleChangeInNetworkConnection() {
        print("Log || Operation resumed")
        self.attemptRequest()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}
