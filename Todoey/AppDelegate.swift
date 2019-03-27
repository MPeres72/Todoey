//
//  AppDelegate.swift
//  Todoey
//
//  Created by Marcos Peres on 25.03.19.
//  Copyright © 2019 Marcos Martins. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising the realm, \(error)")
        }
        
        
        return true
    }

}

