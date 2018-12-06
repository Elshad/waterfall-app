//
//  CollectionCell.swift
//  waterfall-app
//
//  Created by Elshad Yarmetov on 12/6/18.
//  Copyright © 2018 Elshad Yarmetov. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.clipsToBounds = false
        contentView.backgroundColor = .red
        contentView.clipsToBounds = true
        
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentViewWidth = self.bounds.width
        
        titleLabel.frame = CGRect(
            x: 10,
            y: 10,
            width: contentViewWidth - 20,
            height: titleLabel.sizeThatFits(CGSize(width: contentViewWidth - 20, height: .greatestFiniteMagnitude)).height
        )
        
        contentView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentViewWidth,
            height: titleLabel.frame.maxY + 10
        )
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes).copy() as! UICollectionViewLayoutAttributes
        let oldFrame = attributes.frame
        
        /*let sectionIndex = attributes.indexPath.section
        let itemIndex = attributes.indexPath.item
        print("**** TestCollectionViewFlowLayout CELL s\(sectionIndex) i\(itemIndex) \(ObjectIdentifier(attributes)) new h=\(attributes.size.height) origin=\(attributes.frame.origin)")*/
        
        self.frame = oldFrame
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        var newFrame = oldFrame
        newFrame.size.height = self.contentView.bounds.height
        attributes.frame = newFrame
        return attributes
    }
    
}
