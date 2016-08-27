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

final class DeviceTableViewController: UITableViewController, ManagedViewControllerType {
  var coreDataStack: CoreDataStack! {
    didSet {
      print("The Core Data stack is ready!")
      loadData()
    }
  }

  private typealias CellFactory = ViewFactory<Device, UITableViewCell>

  private let cellReuseIdentifier = "device"
  private var dataSourceProvider: DataSourceProvider<FetchedResultsController<Device>, CellFactory, CellFactory>!
  private var delegateProvider: FetchedResultsDelegateProvider<CellFactory>!
  private var frc: FetchedResultsController<Device>!

  private func loadData() {
    // 1. create factory
    let factory = ViewFactory(reuseIdentifier: cellReuseIdentifier)
    { (cell, model: Device?, type, tableView, indexPath) -> UITableViewCell in

      cell.textLabel?.text = model!.name
      cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
      cell.accessibilityIdentifier = "\(cell.textLabel?.text!)"
      return cell
    }

    let request = NSFetchRequest(entityName: Device.entityName)
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

    // 2. create fetched results controller
    frc = FetchedResultsController<Device>(
      fetchRequest: request,
      managedObjectContext: coreDataStack.mainContext,
      sectionNameKeyPath: nil,
      cacheName: nil
    )

    // 3. create delegate provider
    delegateProvider = FetchedResultsDelegateProvider(cellFactory: factory, tableView: tableView)

    // 4. set delegate
    frc.delegate = delegateProvider.tableDelegate

    // 5. create data source provider
    dataSourceProvider = DataSourceProvider(dataSource: frc, cellFactory: factory, supplementaryFactory: factory)

    // 6. set data source
    tableView.dataSource = dataSourceProvider?.tableViewDataSource
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Ensure the stack is ready before any action is taken.
    guard coreDataStack != nil else {
      return
    }

    loadData()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    guard frc != nil else {
      return
    }

    do {
      try frc.performFetch()
    }
    catch {
      print("Fetch error = \(error)")
    }
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)

    frc = nil
  }
}

// MARK: - Interface Builder actions
extension DeviceTableViewController {
  @IBAction func refreshControlAction(sender: UIRefreshControl) {
    // Simulate an actual refresh
    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))

    dispatch_after(delay, dispatch_get_main_queue()) {
      self.refreshControl?.endRefreshing()
    }
  }
}
