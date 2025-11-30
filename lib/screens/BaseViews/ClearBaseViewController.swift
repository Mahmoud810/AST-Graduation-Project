//
//  ClearBaseViewController.swift
//  AutoMall
//
//  Created by Zeinab mohamed on 18/05/2025.
//

import UIKit
import NVActivityIndicatorView
import Combine

class ClearBaseViewController: UIViewController {
    
    // MARK: - Properties
    
    // Navigation buttons
    var searchBtn = BadgeButton()
    var favouriteBtn = BadgeButton()
    var notificationBtn = BadgeButton()
    
    // Custom navigation components
    var customNavBar: UIView?
    private var appNameLabel: UILabel?
    private var locationButton: UIButton?
    private var locationLabel: UILabel?
    private var locationArrowIcon: UIImageView?
    
    // Logo
    private var logoImageView: UIImageView?
    
    // Activity indicator
    var frame = CGRect()
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect())
    var cancellable = Set<AnyCancellable>()
    
    // Current location text
    var currentLocation: String = "Bahrain" {
        didSet {
            locationLabel?.text = currentLocation
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        setupNavigationButtons()
        setupActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setNeedsLayout()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    // MARK: - Setup Methods
    
    private func setupActivityIndicator() {
        frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 0, height: 0)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .ballScale)
        activityIndicatorView.color = .primaryColor
        activityIndicatorView.padding = 100
        self.view.addSubview(activityIndicatorView)
    }
    
    func setupNavBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            
            // Configure back button
            let backItemAppearance = UIBarButtonItemAppearance()
            backItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            appearance.backButtonAppearance = backItemAppearance
            
            // Set back arrow
            var image = UIImage(named: "arrow-left")?.withRenderingMode(.alwaysOriginal)
            if L102Language.currentAppleLanguage() == "ar" {
                image = image?.withHorizontallyFlippedOrientation()
            }
            appearance.setBackIndicatorImage(image, transitionMaskImage: image)
            
            // Configure title
            let font = FontManager.primarySemiBoldFont(ofSize: 16)
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.blackTextColor,
                NSAttributedString.Key.font: font
            ]
            
            navigationItem.titleView?.tintColor = .blackTextColor
            UINavigationBar.appearance().tintColor = UIColor.blackTextColor
            
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.compactAppearance = appearance
            
            self.navigationController?.navigationBar.setNeedsLayout()
            self.navigationController?.navigationBar.layoutIfNeeded()
        }
    }
    
    private func setupNavigationButtons() {
        // Search button
        searchBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        searchBtn.tintColor = .clear
        searchBtn.setImage(UIImage.search, for: .normal)
        searchBtn.contentMode = .scaleAspectFit
        searchBtn.addTarget(self, action: #selector(clickOnSearchButton), for: .touchUpInside)
        
        // Badge customization
        searchBtn.badgeBackgroundColor = .primaryColor
        searchBtn.badgeTextColor = .white
        searchBtn.badgeFont = FontManager.primaryBoldFont(ofSize: 10)
        
        // Favourite button
        favouriteBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        favouriteBtn.tintColor = .clear
        favouriteBtn.setImage(UIImage.favourite, for: .normal)
        favouriteBtn.contentMode = .scaleAspectFit
        favouriteBtn.addTarget(self, action: #selector(clickOnFavouriteButton), for: .touchUpInside)
        
        // Badge customization
        favouriteBtn.badgeBackgroundColor = .primaryColor
        favouriteBtn.badgeTextColor = .white
        favouriteBtn.badgeFont = FontManager.primaryBoldFont(ofSize: 10)
        
        // Notification button
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        notificationBtn.tintColor = .clear
        notificationBtn.setImage(UIImage(named: "notification"), for: .normal)
        notificationBtn.contentMode = .scaleAspectFit
        notificationBtn.addTarget(self, action: #selector(clickOnNotificationButton), for: .touchUpInside)
        
        // Badge customization
        notificationBtn.badgeBackgroundColor = .primaryColor
        notificationBtn.badgeTextColor = .white
        notificationBtn.badgeFont = FontManager.primaryBoldFont(ofSize: 10)
    }
    
    // MARK: - Custom Glassmorphism Navigation Bar
    
    /// Setup custom glassmorphism navigation bar with app name, location selector, and search
    func setupGlassmorphismNavBar() {
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Create custom navigation bar container
        let customNavBar = UIView()
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavBar)
        
        // Use safe area layout guide
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        // Add glassmorphism effect to entire nav bar with higher alpha for visibility
        addGlassmorphismEffect(to: customNavBar, alpha: 0.4)
        
        // Content container (34 points below safe area top)
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.addSubview(contentView)
        
        let contentTopOffset: CGFloat = 34  // Distance from safe area top
        
        NSLayoutConstraint.activate([
            // Start 34 points below safe area top
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: contentTopOffset),
            contentView.leadingAnchor.constraint(equalTo: customNavBar.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: customNavBar.trailingAnchor, constant: -16),
            contentView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 1. App Name Label (Left)
        let appNameLabel = UILabel()
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.text = "NUNU NEES"
        appNameLabel.font = FontManager.primaryBoldFont(ofSize: 20)
        appNameLabel.textColor = .white
        contentView.addSubview(appNameLabel)
        
        // 2. Location Button (Center) with glassmorphism
        let locationContainer = createLocationButton()
        contentView.addSubview(locationContainer)
        
        // 3. Search Button (Right)
        let searchContainer = createSearchButton()
        contentView.addSubview(searchContainer)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // App name on the left
            appNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            appNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Search on the right
            searchContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchContainer.widthAnchor.constraint(equalToConstant: 44),
            searchContainer.heightAnchor.constraint(equalToConstant: 44),
            
            // Location in the middle
            locationContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            locationContainer.leadingAnchor.constraint(equalTo: appNameLabel.trailingAnchor, constant: 16),
            locationContainer.trailingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: -16),
            locationContainer.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        self.customNavBar = customNavBar
        self.appNameLabel = appNameLabel
    }
    
    private func createLocationButton() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 22
        container.clipsToBounds = true
        
        // Add glassmorphism effect
        addGlassmorphismEffect(to: container, alpha: 0.3)
        
        // Stack view for label and icon
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        container.addSubview(stackView)
        
        // "Delivery To" label
        let deliveryLabel = UILabel()
        deliveryLabel.text = "Delivery To"
        deliveryLabel.font = FontManager.primaryFont(ofSize: 10)
        deliveryLabel.textColor = .white.withAlphaComponent(0.8)
        
        // Location container (location name + arrow)
        let locationHStack = UIStackView()
        locationHStack.axis = .horizontal
        locationHStack.spacing = 4
        locationHStack.alignment = .center
        
        // Location label
        let locationLabel = UILabel()
        locationLabel.text = currentLocation
        locationLabel.font = FontManager.primarySemiBoldFont(ofSize: 14)
        locationLabel.textColor = .white
        self.locationLabel = locationLabel
        
        // Down arrow icon
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage(systemName: "chevron.down")
        arrowIcon.tintColor = .white
        arrowIcon.contentMode = .scaleAspectFit
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        self.locationArrowIcon = arrowIcon
        
        NSLayoutConstraint.activate([
            arrowIcon.widthAnchor.constraint(equalToConstant: 12),
            arrowIcon.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        locationHStack.addArrangedSubview(locationLabel)
        locationHStack.addArrangedSubview(arrowIcon)
        
        stackView.addArrangedSubview(deliveryLabel)
        stackView.addArrangedSubview(locationHStack)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -12)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(locationButtonTapped))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        
        return container
    }
    
    private func createSearchButton() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 22
        container.clipsToBounds = true
        
        // Add glassmorphism effect
        addGlassmorphismEffect(to: container, alpha: 0.3)
        
        // Search icon
        let searchIcon = UIImageView()
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.image = UIImage.search?.withRenderingMode(.alwaysTemplate)
        searchIcon.tintColor = .white
        searchIcon.contentMode = .scaleAspectFit
        container.addSubview(searchIcon)
        
        NSLayoutConstraint.activate([
            searchIcon.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            searchIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickOnSearchButton))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        
        return container
    }
    
    private func addGlassmorphismEffect(to view: UIView, alpha: CGFloat = 0.2) {
        // Blur effect with systemUltraThinMaterial for better visibility
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        // Semi-transparent white background with higher alpha for main nav bar
        view.backgroundColor = UIColor.white.withAlphaComponent(alpha)
        
        // More visible border
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        
        // Add subtle shadow for depth
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
    }
    
    @objc private func locationButtonTapped() {
        clickOnLocationButton()
    }
    
    // MARK: - Public Configuration Methods
    
    /// Setup logo on the left side of navigation bar
    func setupLogoOnLeft() {
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        logoContainer.addSubview(logoImageView)
        
        self.logoImageView = logoImageView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoContainer)
    }
    
    /// Add search button only to right bar
    func addRightBarSearchButton() {
        let searchBarButton = UIBarButtonItem(customView: searchBtn)
        navigationItem.rightBarButtonItems = [searchBarButton]
    }
    
    /// Add search and favorite buttons to right bar
    func addRightBarSearchAndFavoriteButtons() {
        let searchBarButton = UIBarButtonItem(customView: searchBtn)
        let favoriteBarButton = UIBarButtonItem(customView: favouriteBtn)
        
        let spacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacing.width = 16
        
        navigationItem.rightBarButtonItems = [searchBarButton, spacing, favoriteBarButton]
    }
    
    /// Add all three buttons (search, favorite, notification) to right bar
    func addRightBarAllButtons() {
        let searchBarButton = UIBarButtonItem(customView: searchBtn)
        let favoriteBarButton = UIBarButtonItem(customView: favouriteBtn)
        let notificationBarButton = UIBarButtonItem(customView: notificationBtn)
        
        let spacing1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacing1.width = 16
        let spacing2 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacing2.width = 16
        
        navigationItem.rightBarButtonItems = [searchBarButton, spacing1, favoriteBarButton, spacing2, notificationBarButton]
    }
    
    /// Add favorite button only to right bar
    func addRightBarFavoriteButton() {
        let favoriteBarButton = UIBarButtonItem(customView: favouriteBtn)
        navigationItem.rightBarButtonItems = [favoriteBarButton]
    }
    
    /// Add notification button only to right bar
    func addRightBarNotificationButton() {
        let notificationBarButton = UIBarButtonItem(customView: notificationBtn)
        navigationItem.rightBarButtonItems = [notificationBarButton]
    }
    
    // MARK: - Badge Management
    
    func updateSearchBadge(count: Int) {
        searchBtn.badge = count > 0 ? "\(count)" : nil
    }
    
    func updateFavouriteBadge(count: Int) {
        favouriteBtn.badge = count > 0 ? "\(count)" : nil
    }
    
    func updateNotificationBadge(count: Int) {
        notificationBtn.badge = count > 0 ? "\(count)" : nil
    }
    
    // MARK: - Button Actions
    
    @objc dynamic func clickOnSearchButton() {
        // Override in subclass
    }
    
    @objc dynamic func clickOnFavouriteButton() {
        // Override in subclass
    }
    
    @objc dynamic func clickOnNotificationButton() {
        // Override in subclass
    }
    
    @objc dynamic func clickOnLocationButton() {
        // Override in subclass to show location picker
    }
}
