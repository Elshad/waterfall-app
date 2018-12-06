//
//  BaseCollectionViewFlowLayout.swift
//  waterfall-app
//
//  Created by Elshad Yarmetov on 12/6/18.
//  Copyright © 2018 Elshad Yarmetov. All rights reserved.
//

import UIKit

class BaseFlowInvalidationContext: UICollectionViewFlowLayoutInvalidationContext {
    
}

// MARK: - BaseCollectionViewFlowLayout

class BaseCollectionViewFlowLayout: RootCollectionViewFlowLayout {
    
    override class var invalidationContextClass: AnyClass {
        print("**** ..BaseCollectionViewFlowLayout invalidationContextClass")
        return BaseFlowInvalidationContext.self
    }
    
    private(set) var flowContext: BaseFlowInvalidationContext!
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        self.flowContext = (context as! BaseFlowInvalidationContext)
        print("**** ..BaseCollectionViewFlowLayout invalidateLayout(with: context) before \(ObjectIdentifier(context))")
        super.invalidateLayout(with: context)
        print("**** ..BaseCollectionViewFlowLayout invalidateLayout(with: context) after_")
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        return context
    }
    
    override func invalidateLayout() {
        print("**** ..BaseCollectionViewFlowLayout invalidateLayout() before")
        super.invalidateLayout()
        print("**** ..BaseCollectionViewFlowLayout invalidateLayout() after_")
    }
    
    override func prepare() {
        print("**** ..BaseCollectionViewFlowLayout prepare() before super.prepare")
        super.prepare()
        print("**** ..BaseCollectionViewFlowLayout prepare() after_ super.prepare")
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElements(in: rect)
        return array
    }
}
