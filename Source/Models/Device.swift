//
//  Device.swift
//  CoreBluetoothExample
//
//  Created by Jeff Kereakoglow on 8/27/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import CoreData

final class Device: NSManagedObject {
  static let entityName = "Device"

  init(context: NSManagedObjectContext, name: String) {
    let entity = NSEntityDescription.entityForName(
      Device.entityName, inManagedObjectContext: context
      )!

    super.init(entity: entity, insertIntoManagedObjectContext: context)

    self.name = name
  }

  // JSQCoreDataKit boilerplate
  @objc
  private override init(entity: NSEntityDescription, insertIntoManagedObjectContext
    context: NSManagedObjectContext?) {

    super.init(entity: entity, insertIntoManagedObjectContext: context)
  }
}

// MARK: - Managed properties
extension Device {
  @NSManaged var name: String
}
