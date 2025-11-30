//
//  NewHomeCollectionAndCollectionViewDataSource.swift
//  NunuNeeds
//
//  Created by Mahmoud on 23/11/2025.
//

import Foundation
import UIKit

extension NewHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Always return custom cell
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CustomizeCollectionViewCell",
            for: indexPath
        ) as! CustomizeCollectionViewCell
        
        // Configure cell if needed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "headerView",
                for: indexPath
            ) as! HeaderView
            
            headerView.configure(with: "")
            headerView.seeMoreButton.isHidden = true
            
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell no \(indexPath.row) selected")
    }
}
