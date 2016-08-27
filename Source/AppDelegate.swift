//
//  AppDelegate.swift
//  CoreBluetoothExample
//
//  Created by Jeff Kereakoglow on 8/26/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import UIKit
import JSQCoreDataKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

    // Find the root view of the navigation contoller and assert it is a ManagedViewControllerType.
    guard let navController = window?.rootViewController as? UINavigationController,
      var rootView = navController.viewControllers.first as? ManagedViewControllerType else {
        fatalError("Expected a ManagedViewControllerType")
    }

    // Create the Core Data stack
    let model = CoreDataModel(name: "Model", bundle: NSBundle.mainBundle())
    let factory = CoreDataStackFactory(model: model)

    factory.createStack { (result: StackResult) -> Void in
      switch result {
      case .success(let stack):
        rootView.coreDataStack = stack

      case .failure(let error):
        assertionFailure("Error creating stack: \(error)")
      }
    }
    
    return true
  }
}
