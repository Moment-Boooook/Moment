//
//  AppDelegate.swift
//  Moment
//
//  Created by phang on 5/3/24.
//

import SwiftUI

import FirebaseCore

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // FirebaseApp
        FirebaseApp.configure()
        return true
    }
}
