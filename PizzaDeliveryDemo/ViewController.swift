//
//  ViewController.swift
//  PizzaDeliveryDemo
//
//  Created by Owl on 2022/12/4.
//

import UIKit
import ActivityKit

class ViewController: UIViewController {
    
    let minutes = 12
    var deliveryActivity: Activity<PizzaDeliveryAttributes>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onOrderPizza(_ sender: UIButton) {
        if #available(iOS 16.1, *) {
            let future = Calendar.current.date(byAdding: .minute, value: (minutes), to: Date())!
            let date = Date.now...future
            let initialContentState = PizzaDeliveryAttributes.ContentState(driverName: "Layer", deliveryTimer:date)
            let activityAttributes = PizzaDeliveryAttributes(numberOfPizzas: 3, totalAmount: "$66.66", orderNumber: "12345")
            do {
                deliveryActivity = try Activity.request(attributes: activityAttributes, contentState: initialContentState)
                print("Requested a pizza delivery Live Activity \(String(describing: deliveryActivity?.id ?? "nil")).")
            } catch (let error) {
                print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
            }
        }
    }
    
    @IBAction func onUpdate(_ sender: UIButton) {
        if #available(iOS 16.1, *) {
            let future = Calendar.current.date(byAdding: .minute, value: (Int(minutes / 2)), to: Date())!
            let date = Date.now...future
            let updatedDeliveryStatus = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: "Layer's brother", deliveryTimer: date)
            let alertConfiguration = AlertConfiguration(title: "Delivery Update", body: "Your pizza order will immediate delivery.", sound: .default)
            Task {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                await deliveryActivity?.update(using: updatedDeliveryStatus, alertConfiguration: alertConfiguration)
            }
        }
    }
    
    @IBAction func onDontWantIt(_ sender: UIButton) {
        if #available(iOS 16.1, *) {
            let finalDeliveryStatus = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: "Anne Johnson", deliveryTimer: Date.now...Date())
            Task {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                await deliveryActivity?.end(using:finalDeliveryStatus, dismissalPolicy: .default)
            }
        }
    }
    
    
}

