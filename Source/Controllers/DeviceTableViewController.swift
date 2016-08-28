//
//  DeviceTableViewController.swift
//  CoreBluetoothExample
//
//  Created by Jeff Kereakoglow on 8/27/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import CoreData
import UIKit
import JSQDataSourcesKit
import JSQCoreDataKit

final class DeviceTableViewController: UITableViewController, ManagedType {
  var coreDataStack: CoreDataStack? {
    didSet {
      setUpTableViewDataSource()
      scannerController = ScannerController(tableView: tableView, fetchedResultsController: frc)
      scannerController?.coreDataStack = coreDataStack
      scannerController?.start()
    }
  }

  private typealias CellFactory = ViewFactory<Device, UITableViewCell>

  private var scannerController: ScannerController?
  private let cellReuseIdentifier = "device"
  private var dataSourceProvider: DataSourceProvider<FetchedResultsController<Device>, CellFactory, CellFactory>!
  private var delegateProvider: FetchedResultsDelegateProvider<CellFactory>!
  private var frc: FetchedResultsController<Device>!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    guard frc != nil else {
      return
    }

    fetchData()
    tableView.reloadData()
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)

    frc = nil
  }
}

// MARK: - Private helpers
private extension DeviceTableViewController {
  func fetchData() {
    do {
      try frc.performFetch()
    }
    catch {
      print("Fetch error = \(error)")
    }
  }

  func setUpTableViewDataSource() {
    // 1. create factory
    let factory = ViewFactory(reuseIdentifier: cellReuseIdentifier)
    { (cell, model: Device?, type, tableView, indexPath) -> UITableViewCell in

      cell.textLabel?.text = model!.name
      cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
      cell.accessibilityIdentifier = "devices.cell.\(cell.textLabel?.text!)"

      return cell
    }

    let request = NSFetchRequest(entityName: Device.entityName)
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

    // 2. create fetched results controller
    frc = FetchedResultsController<Device>(
      fetchRequest: request,
      managedObjectContext: coreDataStack!.mainContext,
      sectionNameKeyPath: nil,
      cacheName: nil
    )

    // 3. create delegate provider
    delegateProvider = FetchedResultsDelegateProvider(cellFactory: factory, tableView: tableView)

    // 4. set delegate
    frc.delegate = delegateProvider.tableDelegate

    // 5. create data source provider
    dataSourceProvider = DataSourceProvider(
      dataSource: frc, cellFactory: factory, supplementaryFactory: factory
    )

    // 6. set data source
    tableView.dataSource = dataSourceProvider?.tableViewDataSource
  }
}

// MARK: - Interface Builder actions
extension DeviceTableViewController {
  @IBAction func toggleScanButtonAction(sender: UIBarButtonItem) {
    // Use the property `tag` to save state.
    switch sender.tag {
    case 0:
      scannerController?.start()
      sender.tag = 1
      print("Scan started.")

    case 1:
      scannerController?.stop()
      sender.tag = 0
      print("Scan stopped.")

    default:
      sender.tag = 0
    }
  }

  @IBAction func refreshControlAction(sender: UIRefreshControl) {
    // Simulate an actual refresh
    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))

    dispatch_after(delay, dispatch_get_main_queue()) { [unowned self] in
      self.refreshControl?.endRefreshing()
    }
  }
}
