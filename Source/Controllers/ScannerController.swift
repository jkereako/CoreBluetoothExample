//
//  ScannerController.swift
//  CoreBluetoothExample
//
//  Created by Jeff Kereakoglow on 8/27/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import CoreBluetooth
import JSQCoreDataKit

final class ScannerController: ManagedType {
  var coreDataStack: CoreDataStack?
  private let scanner: Scanner

  init() {
    scanner = Scanner()
    scanner.delegate = self
  }
}

extension ScannerController: CoordinatorType {
  func start() {
    precondition(coreDataStack != nil, "`coreDataStack` is nil.")
    scanner.start()
  }

  func stop() {
    scanner.stop()
  }
}

extension ScannerController: ScannerDelegate {
  func found(device device: CBPeripheral) {
    print("Found deivce \(device.name)")
    
    _ = Device(context: coreDataStack!.mainContext, name: device.name ?? "No name recorded")
  }
}