//
//  ViewController.swift
//  ExpCollectionViewLineInteritemSpacing
//
//  Created by Mischa Hildebrand on 27/02/2017.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var minimumLineSpacingLabel: UILabel!
    @IBOutlet var minimumInteritemSpacingLabel: UILabel!
    @IBOutlet var iOSVersionLabel: UILabel!
    @IBOutlet var actualSpacingLabel: UILabel!
    
    /// Boolean to toggle automatic cell sizing by using Auto Layout.
    var useAutoLayout: Bool = true {
        didSet {
            updateFlowLayout()
        }
    }
    
    /// The data source array that contains the strings to show in the individual cells.
    let dataItems = ["I'm", "a", "doctor", "not", "an", "escalator", "."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.layer.borderColor = UIColor.gray.cgColor
        myCollectionView.layer.borderWidth = 1
        updateFlowLayout()
    }

    @IBAction func autoLayoutSwitchChangedValue(_ sender: UISwitch) {
        useAutoLayout = sender.isOn
    }
    
    /// Enables / disables the collection view's ability to let the cells size themselves with Auto Layout
    /// by setting / unsetting the Flow Layout's `estimatedItemSize`.
    func updateFlowLayout() {
        let flowLayout = myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if useAutoLayout {
            flowLayout.estimatedItemSize = CGSize(width: 100, height: 50)
        }
        else {
            flowLayout.estimatedItemSize = .zero
        }
        myCollectionView.reloadData()
        updateLabels()
    }
    
}


// MARK: - Collection View Data Source

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! CollectionViewCell
        cell.titleLabel.text = dataItems[indexPath.item]
        return cell
    }

}


// MARK: - Collection View Flow Layout Delegate

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


// MARK: - Update labels

extension ViewController {
    
    /// Updates the spacing labels with their respective values.
    func updateLabels() {
        minimumLineSpacingLabel.text = "\(collectionView(myCollectionView, layout: myCollectionView.collectionViewLayout, minimumLineSpacingForSectionAt: 0))"
        minimumInteritemSpacingLabel.text = "\(collectionView(myCollectionView, layout: myCollectionView.collectionViewLayout, minimumInteritemSpacingForSectionAt: 0))"
        actualSpacingLabel.text = "\(actualSpacingBetweenVisibleCells())"
        iOSVersionLabel.text = "iOS \(UIDevice.current.systemVersion)"
    }
    
    /// Computes the spacing between the collection view's first and second visible cell.
    func actualSpacingBetweenVisibleCells() -> CGFloat {
        myCollectionView.layoutIfNeeded()
        let visibleCellsIndexPaths = myCollectionView.indexPathsForVisibleItems
        let sortedIndexPaths = visibleCellsIndexPaths.sorted()
        if sortedIndexPaths.count > 1 {
            let firstCell = myCollectionView.cellForItem(at: sortedIndexPaths[0])!
            let secondCell = myCollectionView.cellForItem(at: sortedIndexPaths[1])!
            let firstCellEndPoint = firstCell.frame.origin.x + firstCell.frame.size.width
            let secondCellStartPoint = secondCell.frame.origin.x
            let spacing = secondCellStartPoint - firstCellEndPoint
            return spacing
        }
        else {
            return -1
        }
    }
    
}
