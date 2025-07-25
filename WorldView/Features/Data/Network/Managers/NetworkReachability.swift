//
//  NetworkReachability.swift
//  WorldView
//
//  Created by Mina Gerges on 23/07/2025.
//

import Foundation
import Network

/// It's responsible for checking Network reachability and detect if the app is online or offline.
public enum NetworkReachability {
    public static let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    public static let monitor = NWPathMonitor()

    @MainActor public static private(set) var isConnected = false
    @MainActor public static private(set) var isExpensive = false
    @MainActor public static private(set) var currentConnectionType: NWInterface.InterfaceType?

    public static func startMonitoring() {
        NetworkReachability.monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                NetworkReachability.isConnected = path.status != .unsatisfied
                NetworkReachability.isExpensive = path.isExpensive
                NetworkReachability.currentConnectionType =
                NWInterface.InterfaceType.allCases.first { path.usesInterfaceType($0) }
            }
        }
        NetworkReachability.monitor.start(queue: NetworkReachability.queue)
    }

    public static func stopMonitoring() {
        NetworkReachability.monitor.cancel()
    }
}

public extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

extension NWInterface.InterfaceType: @retroactive @preconcurrency CaseIterable {
    @MainActor public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}
