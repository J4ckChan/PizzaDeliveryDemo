//
//  PizzaDeliveryAttributes.swift
//  PizzaDeliveryDemo
//
//  Created by Owl on 2022/11/27.
//

import Foundation
import ActivityKit

struct PizzaDeliveryAttributes: ActivityAttributes {
    public typealias PizzaDeliveryStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var driverName: String
        var deliveryTimer: Int
    }
    
    // Fixed non-changing properties about your activity go here!
    let numberOfPizzas: Int
    let totalAmount: String
    let orderNumber: String
}
