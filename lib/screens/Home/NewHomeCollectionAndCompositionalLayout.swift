//
//  NewHomeCollectionAndCompositionalLayout.swift
//  NunuNeeds
//
//  Created by Mahmoud on 23/11/2025.
//

import Foundation
import UIKit

extension NewHomeViewController {
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            // Always return custom section for dummy data
            return self.createCustomSection()
        }
        
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: "sectionBackground")
        return layout
    }
    
    /// Creates a horizontal scrolling section with full screen width and 600pt height
    private func createCustomSection() -> NSCollectionLayoutSection {
        // Each item takes full width and height of the group
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group takes full screen width and 600pt height
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // Full screen width
            heightDimension: .absolute(600)          // 600pt height
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Create section with horizontal scrolling
        let section = NSCollectionLayoutSection(group: group)
        
        // Enable horizontal paging behavior
        section.orthogonalScrollingBehavior = .groupPaging
        
        // Add spacing between items (optional)
        section.interGroupSpacing = 0
        
        // Add content insets (optional)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return section
    }
}
