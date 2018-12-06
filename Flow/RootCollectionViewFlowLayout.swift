//
//  RootCollectionViewFlowLayout.swift
//  waterfall-app
//
//  Created by Elshad Yarmetov on 12/6/18.
//  Copyright © 2018 Elshad Yarmetov. All rights reserved.
//

import UIKit

var isDebug = true
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    if isDebug {
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
    }
}

class RootCollectionViewFlowLayout: UICollectionViewFlowLayout {

}
