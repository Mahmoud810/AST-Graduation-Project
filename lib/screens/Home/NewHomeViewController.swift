//
//  NewHomeViewController.swift
//  NunuNeeds
//
//  Created by Mahmoud on 23/11/2025.
//

import UIKit
import CoreLocation
import FirebaseMessaging

class NewHomeViewController: ClearBaseViewController {

    // MARK: - Properties
    
    @IBOutlet var collectionView: UICollectionView!
    
    let viewModel = HomeViewModel()
    var storyViewModel: StoryViewModel?
    var brandID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupGlassmorphismNavBar()
        setupCollectionView()
        setupCollectionViewLayout()
        setupCollectionViewConstraints()
    }
    
    private func setupBackground() {
        // Add gradient background for glassmorphism effect
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.95, green: 0.85, blue: 0.95, alpha: 1.0).cgColor, // Light pink/purple
            UIColor(red: 0.85, green: 0.90, blue: 0.98, alpha: 1.0).cgColor  // Light blue
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Make collection view background transparent to show gradient
        collectionView.backgroundColor = .clear
        
        // Register different cell types
        collectionView.register(
            UINib(nibName: "StoryHomeCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "StoryHomeCollectionViewCell"
        )
        collectionView.register(
            UINib(nibName: "MothersStoriesCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "MothersStoriesCollectionViewCell"
        )
        collectionView.register(
            UINib(nibName: "SponsorsCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "SponsorsCollectionViewCell"
        )
        collectionView.register(
            UINib(nibName: "CustomizeCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: CustomizeCollectionViewCell.reuseIdentifier
        )
        
        // Send card cell register
        let sendCardNib = UINib(nibName: SendCardCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(
            sendCardNib,
            forCellWithReuseIdentifier: SendCardCollectionViewCell.reuseIdentifier
        )
        
        collectionView.register(
            BrandCollectionViewCell.self,
            forCellWithReuseIdentifier: "BrandCollectionViewCell"
        )
        collectionView.register(
            InfluencerCollectionViewCell.self,
            forCellWithReuseIdentifier: "InfluencerCollectionViewCell"
        )
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "headerView"
        )
        collectionView.register(
            SliderImgCollectionViewCell.self,
            forCellWithReuseIdentifier: "SliderImgCollectionViewCell"
        )
        collectionView.register(
            TrackMyPregnancyCollectionViewCell.self,
            forCellWithReuseIdentifier: "TrackMyPregnancyCollectionViewCell"
        )
    }
    
    private func setupCollectionViewLayout() {
        let layout = createCompositionalLayout()
        collectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Start collection view below the custom nav bar
        if let customNavBar = customNavBar {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
}
