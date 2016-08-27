//
//  ScannerDelegate.swift
//  CoreBluetoothExample
//
//  Created by Jeff Kereakoglow on 8/27/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol ScannerDelegate {
  func found(device device: CBPeripheral)
}
