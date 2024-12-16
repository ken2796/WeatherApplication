//
//  NetworkManager.swift
//  WeatherApplication
//
//  Created by Kenneth Francia on 12/16/24.
//

import Foundation
import Reachability

class NetworkManager: NSObject {
    var reachability: Reachability!
    static let shared: NetworkManager = {
        return NetworkManager()
    }()
    override init() {
        super.init()
        if let reachability = try? Reachability() {
            self.reachability = reachability
        } else {
            fatalError("Failed to initialize reachability")
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    @objc func networkStatusChanged(_ notification: Notification) {
    }
    static func stopNotifier() -> Void {
        do {
            try (NetworkManager.shared.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
        // Network is reachable
    static var isReachable: Bool {
        return (NetworkManager.shared.reachability).connection != .unavailable
    }
        // Network is unreachable
    static var isUnreachable: Bool {
        return (NetworkManager.shared.reachability).connection == .unavailable
    }
        // Network is reachable via WWAN/Cellular
    static var isReachableViaWWAN: Bool {
        return (NetworkManager.shared.reachability).connection == .cellular
    }
        // Network is reachable via WiFi
    static var isReachableViaWiFi: Bool {
        return (NetworkManager.shared.reachability).connection == .wifi
    }
}
