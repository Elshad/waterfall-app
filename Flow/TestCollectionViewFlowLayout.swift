//
//  TestCollectionViewFlowLayout.swift
//  waterfall-app
//
//  Created by Elshad Yarmetov on 12/6/18.
//  Copyright © 2018 Elshad Yarmetov. All rights reserved.
//

import UIKit

class TestCollectionViewFlowLayout: BaseCollectionViewFlowLayout {
    override func prepare() {
        print("**** TestCollectionViewFlowLayout prepare() before super.prepare")
        super.prepare()
        print("**** TestCollectionViewFlowLayout prepare() after_ super.prepare")
        
        self.configureLayout()
    }
    
    private func configureLayout() {
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
            let dataSource = collectionView.dataSource else {
                return
        }
        
        let numberOfSections = dataSource.numberOfSections?(in: collectionView) ?? 1
        print("**** TestCollectionViewFlowLayout prepare() numberOfSections=\(numberOfSections)")
        let sections: [Int] = [Int](0..<numberOfSections)
        
        for sectionIndex in sections {
            let itemsCountInSection = dataSource.collectionView(collectionView, numberOfItemsInSection: sectionIndex)
            print("**** TestCollectionViewFlowLayout prepare() s\(sectionIndex) itemsCountInSection=\(itemsCountInSection)")
            let items = [Int](0..<itemsCountInSection)
            
            for itemIndex in items {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let attributes = super.layoutAttributesForItem(at: indexPath)!
                attributes.frame = {
                    var frame = attributes.frame
                    frame.origin.y = frame.origin.y + 100
                    return frame
                }()
                print("**** TestCollectionViewFlowLayout prepare() s\(sectionIndex) i\(itemIndex) \(ObjectIdentifier(attributes)) new h=\(attributes.size.height) origin=\(attributes.frame.origin)")
                
            }
        }
    }
    
}
