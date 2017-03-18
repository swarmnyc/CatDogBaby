//
//  AppDelegate.swift
//  CatDogBaby
//
//  Created by William Robinson on 3/17/17.
//  Copyright © 2017 William Robinson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	// Properties
	var window: UIWindow?

	// Did finish launching
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Set up window
		window = UIWindow()
		window!.rootViewController = CameraViewController()
		window!.makeKeyAndVisible()
		
		return true
	}
}

