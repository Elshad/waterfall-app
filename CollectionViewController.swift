//
//  CollectionViewController.swift
//  waterfall-app
//
//  Created by Elshad Yarmetov on 12/6/18.
//  Copyright © 2018 Elshad Yarmetov. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    var viewModel = CollectionViewModel()
    
    let collectionView: UICollectionView = {
        let layout = TestCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        //collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        //collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        refreshControl.addTarget(self, action: #selector(self.actionRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        actionRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    @objc
    private func actionRefresh() {
        viewModel.fetch {
            self.collectionView.reloadData()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection == nil { return }
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - CollectionView Delegate

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.titles.count
    }
    
    // MARK: Section
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = max(16, self.view.safeAreaInsets.left)
        let right = max(16, self.view.safeAreaInsets.right)
        return UIEdgeInsets(top: 16, left: left, bottom: 16, right: right)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    // MARK: Cell
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print("**** WaterfallFlowLayout COLLECTION_VIEW size_ForItemAt \(indexPath)")
        let columnCount = 2//collectionView.frame.width > 850 ? 3 : collectionView.frame.width > 500 ? 2 : 1
        let sectionInsets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let minimumLineSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: indexPath.section)
        let fullWidth = collectionView.frame.width - sectionInsets.left - sectionInsets.right
        let width = (fullWidth - minimumLineSpacing * CGFloat(columnCount - 1)) / CGFloat(columnCount)
        
        return CGSize(width: width, height: 13)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print("**** WaterfallFlowLayout COLLECTION_VIEW willDisplay \(indexPath)")
        if indexPath.section == 0 && indexPath.item == viewModel.titles.count - 3 {
            viewModel.fetch(next: true) {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("**** WaterfallFlowLayout COLLECTION_VIEW cellForItemAt \(indexPath)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.titleLabel.text = "\(indexPath)\n\n" + viewModel.titles[indexPath.item]
        return cell
    }
}
