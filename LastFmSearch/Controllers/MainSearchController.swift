//
//  ViewController.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

final class MainSearchController: UIViewController, UITextFieldDelegate {
    
    var mainSearchView: MainSearchView = { return MainSearchView() }()
    var networkManager: NetworkManager
    var mainSearchViewModel = MainSearchViewModel()
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not supported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainSearchViewModel.networkManager = networkManager
        view = mainSearchView
        mainSearchView.searchField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        mainSearchView.viewModel = mainSearchViewModel
        mainSearchView.searchSegmentController.addTarget(self, action: #selector(segmentControllerChanged(sender:)), for: .valueChanged)
        mainSearchView.searchSegmentController.isHidden = true
        mainSearchView.controller = self
        mainSearchView.searchField.delegate = self
    }
    
    @objc func textChanged(_ textfield: UITextField) {
        if let searchText = textfield.text {
            
            mainSearchViewModel.artistList = []
            mainSearchViewModel.albumList = []
            mainSearchViewModel.trackList = []
            
            if searchText.isEmpty {
                mainSearchView.searchSegmentController.isHidden = true
            } else {
                mainSearchView.searchSegmentController.isHidden = false
                mainSearchViewModel.search(searchTerm: searchText, completion: {
                    error in
                    if let error = error {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Network Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.mainSearchView.searchResultsTableView.reloadData()
                    }
                })
            }
        }
    }
    
    @objc func segmentControllerChanged(sender: UISegmentedControl) {
        mainSearchViewModel.searchSelectedSegmentIndex = sender.selectedSegmentIndex
        mainSearchView.searchResultsTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

