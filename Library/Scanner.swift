//
//  Scanner.swift
//  CoreBluetoothExample
//
//  Created by Jeff Kereakoglow on 8/27/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation
import CoreBluetooth

/// Scans for devices.
class Scanner: NSObject {
  var delegate: ScannerDelegate?
  private let manager: CBCentralManager

  override init () {
    manager = CBCentralManager(delegate: nil, queue: dispatch_get_main_queue())

    super.init()

    manager.delegate = self
  }
}

extension Scanner: CoordinatorType {
  func start() {
    let options = [CBCentralManagerScanOptionAllowDuplicatesKey: false]

    manager.scanForPeripheralsWithServices(nil, options: options)
  }

  func stop() {
    manager.stopScan()
  }
}

extension Scanner: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(central: CBCentralManager) {
    /*
     case Unknown
     case Resetting
     case Unsupported
     case Unauthorized
     case PoweredOff
     case PoweredOn
     */
    switch central.state {
    case .PoweredOff:
      print("Bluetooth device is powered off")

    case .Unauthorized:
      print("Bluetooth device is unauthorized")

    case .Unsupported:
      print("Bluetooth device is unsupported")

    case .Unknown:
      assertionFailure("Bluetooth central manager is in an unknown state.")
    default:
      print("Catch-all")
    }
  }

  func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral,
                      advertisementData: [String : AnyObject], RSSI: NSNumber) {

    delegate?.found(device: peripheral)
  }
}
