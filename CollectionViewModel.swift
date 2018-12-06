//
//  CollectionViewModel.swift
//  waterfall-app
//
//  Created by Elshad Yarmetov on 12/6/18.
//  Copyright © 2018 Elshad Yarmetov. All rights reserved.
//

import UIKit

private let words = [ "hi " , "bye " , "hello ", "goodbye ", "question ", "implementation "]
private let loopCount = [10 , 15 , 20, 25]

class CollectionViewModel {
    private(set) var titles: [String] = []

}

extension CollectionViewModel {
    func fetch(next: Bool = false, complete: @escaping () -> Void) {
        DispatchQueue.global().async {
            var strings: [String] = []
            for _ in 0..<20 {
                var string = ""
                let count = loopCount.randomElement()!
                for _ in 0..<count {
                    string = string + words.randomElement()!
                }
                strings.append(string)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (next ? 2: 0.5)) {
                if next {
                    self.titles.append(contentsOf: strings)
                } else {
                    self.titles = strings
                }
                complete()
            }
        }
    }
}
