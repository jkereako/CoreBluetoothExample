//
//  DeviceTableViewController.swift
//  CoreBluetoothExample
//
//  Created by Jeff Kereakoglow on 8/27/16.
//  Copyright © 2016 Alexis Digital. All rights reserved.
//

import UIKit
import JSQDataSourcesKit
import JSQCoreDataKit

class DeviceTableViewController: UITableViewController, ManagedViewControllerType {
  var coreDataStack: CoreDataStack! {
    didSet {
      print("The Core Data stack is ready!")
    }
  }

  private let cellReuseIdentifier = "device"

  typealias CellFactory = ViewFactory<DeviceCellViewModel, UITableViewCell>
  var dataSourceProvider: DataSourceProvider<DataSource<Section<DeviceCellViewModel>>, CellFactory, CellFactory>?

  override func viewDidLoad() {
    super.viewDidLoad()


    // This is an example from Jesse Squires himself.
    
    // 1. create view models
    let section0 = Section(
      items: DeviceCellViewModel(), DeviceCellViewModel(), DeviceCellViewModel(),
      headerTitle: "First"
    )
    let section1 = Section(
      items: DeviceCellViewModel(), DeviceCellViewModel(), DeviceCellViewModel(), DeviceCellViewModel(),
      headerTitle: "Second",
      footerTitle: "Only 2nd has a footer"
    )
    let section2 = Section(
      items: DeviceCellViewModel(), DeviceCellViewModel(), headerTitle: "Third"
    )
    let dataSource = DataSource(sections: section0, section1, section2)

    // 2. create cell factory
    let factory = ViewFactory(reuseIdentifier: cellReuseIdentifier)
    { (cell, model: DeviceCellViewModel?, type, tableView, indexPath) -> UITableViewCell in
      cell.textLabel?.text = model!.title
      cell.detailTextLabel?.text = "\(indexPath.section), \(indexPath.row)"
      cell.accessibilityIdentifier = "\(indexPath.section), \(indexPath.row)"
      return cell
    }

    // 3. create data source provider
    dataSourceProvider = DataSourceProvider(
      dataSource: dataSource, cellFactory: factory, supplementaryFactory: factory
    )

    // 4. set data source
    tableView.dataSource = dataSourceProvider?.tableViewDataSource
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
