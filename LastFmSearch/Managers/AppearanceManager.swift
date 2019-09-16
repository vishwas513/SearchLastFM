//
//  AppearanceManager.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

enum AppearanceManager {
    
    static func setUpTheme() {
        
        // MARK: NavigationBar
        
        UINavigationBar.appearance().barTintColor = UIColor.robinGreen
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        
        let navBarTitleText = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        UINavigationBar.appearance().titleTextAttributes = navBarTitleText
        UINavigationBar.appearance().largeTitleTextAttributes = navBarTitleText
        
        UIBarButtonItem.appearance().tintColor = .white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self]).tintColor = nil
        let barButtonAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: .highlighted)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self]).setTitleTextAttributes(nil, for: .normal)
        let disabledAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        UIBarButtonItem.appearance().setTitleTextAttributes(disabledAttributes, for: .disabled)
        
        // MARK: TabBar
        
        UITabBar.appearance().barTintColor = UIColor.robinGreen
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().unselectedItemTintColor = .white
        UISearchBar.appearance().tintColor = .white
        
        // MARK: SearchBar
    }
}
