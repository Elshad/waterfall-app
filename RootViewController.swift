//
//  RootViewController.swift
//  waterfall-app
//
//  Created by Elshad Yarmetov on 12/6/18.
//  Copyright © 2018 Elshad Yarmetov. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button1.addTarget(self, action: #selector(self.actionButton1), for: .touchUpInside)
    }

    @objc
    func actionButton1() {
        show(CollectionViewController(), sender: nil)
    }
}

