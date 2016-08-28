//
//  ScannerController.swift
//  CoreBluetoothExample
//
//  Created by Jeff Kereakoglow on 8/27/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import CoreBluetooth
import JSQCoreDataKit
import JSQDataSourcesKit
import UIKit

final class ScannerController: ManagedType {
  var coreDataStack: CoreDataStack?
  private let scanner: Scanner
  private let tableView: UITableView
  private let fetchedResultsController: FetchedResultsController<Device>

  init(tableView: UITableView, fetchedResultsController frc: FetchedResultsController<Device>) {
    self.scanner = Scanner()
    self.tableView = tableView
    self.fetchedResultsController = frc
    self.scanner.delegate = self
  }

  private func fetchData() {
    do {
      try fetchedResultsController.performFetch()
    }
    catch {
      print("Fetch error = \(error)")
    }
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

    fetchData()
    tableView.reloadData()
  }
}