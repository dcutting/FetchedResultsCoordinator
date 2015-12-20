//  Copyright © 2015 Mark Carter. All rights reserved.

import Foundation
import UIKit
import CoreData
import FetchedResultsCoordinator

class ExampleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
}

class ExampleCollectionViewHeader: UICollectionReusableView {
    @IBOutlet weak var textLabel: UILabel!
}

class ExampleCollectionViewController: UICollectionViewController, CollectionCellConfigurator, CollectionViewSupplementaryViewConfigurator, ExampleViewControllersWithFetchedResultController {
 
    var fetchedResultsController: NSFetchedResultsController!
    var frcCoordinator: FetchedResultsCoordinator?
    var dataSource: SimpleCollectionDataSource?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if dataSource == nil {
            dataSource = SimpleCollectionDataSource( fetchedResultsController: self.fetchedResultsController, cellConfigurator: self, supplementaryViewConfigurator: self )
            collectionView!.dataSource = dataSource
        }
        
        if frcCoordinator == nil {
            frcCoordinator = FetchedResultsCoordinator( collectionView: self.collectionView!, fetchedResultsController: self.fetchedResultsController, cellConfigurator: self )
            frcCoordinator?.loadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedPause(sender: UIBarButtonItem) {
        guard let frcCoordinator = frcCoordinator else { return }
        
        frcCoordinator.paused = !frcCoordinator.paused
        sender.title = frcCoordinator.paused ? "Unpause" : "Pause"
    }
    
    // MARK: - CollectionCellConfigurator methods

    func configureCell(cell: UICollectionViewCell, withObject: NSManagedObject) {
        
        if let cell = cell as? ExampleCollectionViewCell,
            let withObject = withObject as? Item {
                cell.textLabel!.text = withObject.name
        }
    }
    
    func cellReuseIdentifierForObject(object: NSManagedObject) -> String {
        return "ECVCCellReuseIdentifier"
    }

    // MARK: - CollectionViewSupplementaryViewConfigurator methods
    
    func reuseIdentifierForSupplementaryViewOfKind( kind: String, atIndexPath: NSIndexPath ) -> String {
        return "ECVCHeaderReuseIdentifier"
    }
    
    func configureView( view: UICollectionReusableView, ofKind: String, atIndexPath: NSIndexPath ) {
        
        if let view = view as? ExampleCollectionViewHeader {
            let sectionName = dataSource?.sectionInfoForSection( atIndexPath.section )?.name
            view.textLabel.text = sectionName
        }
    }

}