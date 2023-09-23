//
//  AppDelegate.swift
//  TaskList
//
//  Created by Goodwasp on 20.09.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }
}

