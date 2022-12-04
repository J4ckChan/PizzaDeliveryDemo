//
//  PizzaDeliveryBundle.swift
//  PizzaDelivery
//
//  Created by Owl on 2022/12/4.
//

import WidgetKit
import SwiftUI

@main
struct PizzaDeliveryBundle: WidgetBundle {
    var body: some Widget {
        PizzaDelivery()
        if #available(iOS 16.1, *) {
            PizzaDeliveryLiveActivity()
        }
    }
}
