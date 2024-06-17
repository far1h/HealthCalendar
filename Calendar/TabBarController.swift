//
//  TabBarController.swift
//  Calendar
//
//  Created by Farih Muhammad on 25/05/2024.
//

import UIKit


class TabBarController: UITabBarController {
    var healthManager = HealthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        self.selectedIndex = 0
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .gray
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.tabBar.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1) // Dark grey
        } else {
            self.tabBar.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) // Light grey
        }
        NotificationCenter.default.addObserver(self, selector: #selector(traitCollectionDidChange(_:)), name: Notification.Name(rawValue: "traitCollectionDidChange"), object: nil)

        //        self.delegate = self
        
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Update tab bar background color when appearance mode changes
        updateTabBarBackgroundColor()
    }
    private func updateTabBarBackgroundColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.tabBar.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1) // Dark grey
        } else {
            self.tabBar.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) // Light grey
        }
    }
    
    private func setupTabs() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeViewController())
        let cal = self.createNav(with: "Calendar", and: UIImage(systemName: "calendar"), vc: CalendarViewController())
        
        let setting = self.createNav(with: "Settings", and: UIImage(systemName: "gear"), vc: SettingsViewController())
        let activity = self.createNav(with: "Activity", and: UIImage(systemName: "figure.wave"), vc: ActivityViewController())
        let progress = self.createNav(with: "Progress", and: UIImage(systemName: "chart.line.uptrend.xyaxis"), vc: ProgressViewController())
//        let monthly = self.createNav(with: "Monthly", and: UIImage(systemName: "calendar"), vc: MonthlyCalendarViewController())

        
        self.setViewControllers([home,activity,cal,progress,setting], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.viewControllers.first?.navigationItem.title = title
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        
        let navigationBar = navigationController.navigationBar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        return navigationController
    }
    
    
}
