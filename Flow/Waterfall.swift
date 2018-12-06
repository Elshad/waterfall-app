//
//  Waterfall.swift
//  yoxla
//
//  Created by Elshad Yarmetov on 11/30/18.
//  Copyright © 2018 Elshad Yarmetov. All rights reserved.
//

import UIKit

class WaterfallFlowLayout: BaseCollectionViewFlowLayout {
    private var cache: [IndexPath: UICollectionViewLayoutAttributes]  = [:]
    private var isPrepare = false
    
    override var scrollDirection: UICollectionView.ScrollDirection {
        get {
            return .vertical//super.scrollDirection
        }
        set {
            super.scrollDirection = .vertical
        }
    }
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        return super.collectionViewContentSize.width
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        print("**** WaterfallFlowLayout invalidateLayout(with: context) before")
        super.invalidateLayout(with: context)
        print("**** WaterfallFlowLayout invalidateLayout(with: context) after_")
    }
    
    override func invalidateLayout() {
        print("**** WaterfallFlowLayout invalidateLayout() before •••••")
        super.invalidateLayout()
        print("**** WaterfallFlowLayout invalidateLayout() after_")
    }
    
    override func prepare() {
        print("**** WaterfallFlowLayout prepare() before super.prepare")
        //super.prepare()
        print("**** WaterfallFlowLayout prepare() after_ super.prepare")
        
        self.configureLayout()
    }
    
    private func configureLayout() {
        cache.removeAll()
        contentHeight = 0
        
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
            let dataSource = collectionView.dataSource else {
                return
        }
        
        let numberOfSections = dataSource.numberOfSections?(in: collectionView) ?? 1
        print("**** WaterfallFlowLayout prepare() numberOfSections=\(numberOfSections)")
        let sections: [Int] = [Int](0..<numberOfSections)
        
        print("**** WaterfallFlowLayout prepare() ...invalidatedItemIndexPaths.count ...\((flowContext.invalidatedItemIndexPaths ?? []).count)...")
        print("**** WaterfallFlowLayout prepare() ...invalidateDataSourceCounts..\((flowContext.invalidateDataSourceCounts))")
        print("**** WaterfallFlowLayout prepare() ...invalidateFlowLayoutAttributes..\((flowContext.invalidateFlowLayoutAttributes))")
        print("**** WaterfallFlowLayout prepare() ...invalidateFlowLayoutDelegateMetrics..\((flowContext.invalidateFlowLayoutDelegateMetrics))")
        print("**** WaterfallFlowLayout prepare() ...contentSizeAdjustment..\((flowContext.contentSizeAdjustment))")
        print("**** WaterfallFlowLayout prepare() ...contentOffsetAdjustment..\((flowContext.contentOffsetAdjustment))")
        print("**** WaterfallFlowLayout prepare() ...invalidateEverything..\((flowContext.invalidateEverything))")
        
        for sectionIndex in sections {
            guard
                let insetForSection = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: sectionIndex),
                let leftRightPadding = delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex),
                let topBottomPadding = delegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: sectionIndex)
                else {
                    return
            }
            print("**** WaterfallFlowLayout prepare() s\(sectionIndex) insetForSection \(insetForSection)")
            print("**** WaterfallFlowLayout prepare() s\(sectionIndex) leftRightPadding \(leftRightPadding)")
            print("**** WaterfallFlowLayout prepare() s\(sectionIndex) topBottomPadding \(topBottomPadding)")
            
            let itemsCountInSection = dataSource.collectionView(collectionView, numberOfItemsInSection: sectionIndex)
            print("**** WaterfallFlowLayout prepare() s\(sectionIndex) itemsCountInSection=\(itemsCountInSection)")
            let items = [Int](0..<itemsCountInSection)
            
            let columnsCountInSection: Int = {
                if itemsCountInSection == 0 { return 0 }
                let indexPath = IndexPath(item: 0, section: sectionIndex)
                guard let cellWidth = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath).width else {
                    return 0
                }
                print("**** WaterfallFlowLayout prepare() s\(sectionIndex) cellWidth=\(cellWidth)")
                let tempContentWidth = contentWidth - insetForSection.left - insetForSection.right
                if (cellWidth + leftRightPadding + cellWidth) > tempContentWidth {
                    return 1
                }
                var count = 2
                func calculateCount(start with: inout Int) {
                    let w = (tempContentWidth - CGFloat(with - 1) * leftRightPadding) / CGFloat(with)
                    if w < (cellWidth + leftRightPadding) {
                        return
                    } else {
                        with = with + 1
                        calculateCount(start: &with)
                    }
                }
                calculateCount(start: &count)
                return count
            }()
            print("**** WaterfallFlowLayout prepare() s\(sectionIndex) columnsCountInSection=\(columnsCountInSection)")
            
            var columnIndex = 0
            var yOffsetOfColumns = [CGFloat](repeating: contentHeight, count: columnsCountInSection)
            
            for itemIndex in items {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                /*let attributes = super.layoutAttributesForItem(at: indexPath)
                let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath)
                let newAttributes = cell.preferredLayoutAttributesFitting(attributes!.copy() as! UICollectionViewLayoutAttributes)*/
                
                let cellSize = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = {
                    var frame = attributes.frame
                    frame.size = cellSize
                    return frame
                }()
                let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath)
                let newAttributes = cell.preferredLayoutAttributesFitting(attributes)
                
                var frame = newAttributes.frame
                frame.origin.x = insetForSection.left + (frame.width + leftRightPadding) * CGFloat(columnIndex)
                frame.origin.y = yOffsetOfColumns[columnIndex] +
                    (itemIndex < columnsCountInSection ? insetForSection.top : topBottomPadding)
                newAttributes.frame = frame
                print("**** WaterfallFlowLayout prepare() s\(sectionIndex) i\(itemIndex) new h=\(newAttributes.size.height) origin=\(newAttributes.frame.origin)")
                cache[indexPath] = newAttributes
                
                yOffsetOfColumns[columnIndex] = frame.maxY
                columnIndex = yOffsetOfColumns.index(of: yOffsetOfColumns.min() ?? 0) ?? 0
            }
            
            contentHeight = yOffsetOfColumns.max() ?? contentHeight
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let items = Array(cache.values).filter { $0.frame.intersects(rect) }
        print("**** WaterfallFlowLayout layoutAttributesForElements rect \(rect) \(items.count)")
        return items
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("**** WaterfallFlowLayout layoutAttributesForItem indexPath \(indexPath)")
        return cache[indexPath]
    }
}
