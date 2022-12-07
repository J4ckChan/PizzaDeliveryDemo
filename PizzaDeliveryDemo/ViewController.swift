//
//  ViewController.swift
//  PizzaDeliveryDemo
//
//  Created by Owl on 2022/12/4.
//

import UIKit
import ActivityKit

let minutes = 12
var deliveryActivity: Activity<PizzaDeliveryAttributes>? = nil

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        Task{
//            // Observe updates for ongoing pizza delivery Live Activities.
//            for await activity in Activity<PizzaDeliveryAttributes>.activityUpdates {
//                try? await Task.sleep(nanoseconds: 5_000_000_000)
//                print("Pizza delivery details: \(activity.attributes)")
//                print("push token: \(String(describing: activity.pushToken))");
//            }
//        }
    }
    
    @IBAction func onOrderPizza(_ sender: UIButton) {
        if #available(iOS 16.1, *) {
            let date = Date(timeIntervalSinceNow: TimeInterval(minutes * 60)).timeIntervalSince1970
            let initialContentState = PizzaDeliveryAttributes.ContentState(driverName: "🐱", deliveryTimer:Int(date))
            let activityAttributes = PizzaDeliveryAttributes(numberOfPizzas: 3, totalAmount: "$66.66", orderNumber: "12345")
            do {
                deliveryActivity = try Activity.request(attributes: activityAttributes, contentState: initialContentState, pushType: .token)
                print("Requested a pizza delivery Live Activity \(String(describing: deliveryActivity?.id ?? "nil")).")
                print("Activity PushToken: \(String(describing: deliveryActivity?.pushToken))");
                ///get push token
                Task {
                    try? await Task.sleep(nanoseconds: 5_000_000_000)
                    if let data = deliveryActivity?.pushToken {
                        let mytoken = data.map { String(format: "%02x", $0) }.joined()
                        print("deliveryActivity push token", mytoken)
                        //TODO: upload push token
                    }
                }
            } catch (let error) {
                print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
            }
        }
    }
    
    @IBAction func onUpdate(_ sender: UIButton) {
        if #available(iOS 16.1, *) {
            let date = Date(timeIntervalSinceNow: TimeInterval(minutes * 30)).timeIntervalSince1970
            let updatedDeliveryStatus = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: "🐶", deliveryTimer: Int(date))
            let alertConfiguration = AlertConfiguration(title: "Delivery Update", body: "Your pizza order will immediate delivery.", sound: .default)
            Task {
//                try? await Task.sleep(nanoseconds: 5_000_000_000)
                await deliveryActivity?.update(using: updatedDeliveryStatus, alertConfiguration: alertConfiguration)
            }
        }
    }
    
    @IBAction func onDontWantIt(_ sender: UIButton) {
        if #available(iOS 16.1, *) {
            let finalDeliveryStatus = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: "🤖️", deliveryTimer: Int(Date.now.timeIntervalSince1970))
            Task {
                //                try? await Task.sleep(nanoseconds: 5_000_000_000)
                await deliveryActivity?.end(using:finalDeliveryStatus, dismissalPolicy: .immediate)
            }
        }
    }
    
}

// 解析灵动岛的传递数据，做相应的业务逻辑
struct ActivityBrigde {
    
    public static func activityAction(url: URL){
        //TODO: update live activity
        
    }
    
    public static func disposeNotifiMessage(userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any] {
            if let content = aps["content-state"] as? [String: Any] {
                if let diriverName = content["driverName"] as? String {
                    let date = Date(timeIntervalSinceNow: TimeInterval(minutes * 30)).timeIntervalSince1970
                    let updatedDeliveryStatus = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: diriverName,  deliveryTimer: Int(date))
                    let alertConfiguration = AlertConfiguration(title: "Delivery Update", body: "Your pizza order will immediate delivery.", sound: .default)
                    Task {
                        await deliveryActivity?.update(using: updatedDeliveryStatus, alertConfiguration: alertConfiguration)
                    }
                }
            }
        }
    }
    
    
}
