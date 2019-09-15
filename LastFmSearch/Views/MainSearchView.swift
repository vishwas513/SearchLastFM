//
//  MainSearchView.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

extension MainSearchView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel?.searchSelectedSegmentIndex {
        case 0:
            return viewModel?.artistList.count ?? 0
        case 1:
            return viewModel?.trackList.count ?? 0
        default:
            return viewModel?.albumList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SearchResultCell()
        switch viewModel?.searchSelectedSegmentIndex {
        case 0:
            cell = SearchResultCell(artistObject: viewModel?.artistList[indexPath.row] ?? Artist())
            cell.searchImageView.image = UIImage(named: "placeholder")  //set placeholder image first.
            cell.searchImageView.downloadImageFrom(link: viewModel?.artistList[indexPath.row].imageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
        case 1:
            cell = SearchResultCell(trackObject: viewModel?.trackList[indexPath.row] ?? Track())
            cell.searchImageView.image = UIImage(named: "placeholder")  //set placeholder image first.
            cell.searchImageView.downloadImageFrom(link: viewModel?.trackList[indexPath.row].imageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
        default:
            cell = SearchResultCell(albumObject: viewModel?.albumList[indexPath.row] ?? Album())
            cell.searchImageView.image = UIImage(named: "placeholder")  //set placeholder image first.
            cell.searchImageView.downloadImageFrom(link: viewModel?.albumList[indexPath.row].imageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ElementSizesManager.cellRowHeight
    }
    
}


final class MainSearchView: UIView {
    var viewModel: MainSearchViewModel?
    let mainSearchViewModel = MainSearchViewModel()
    var searchField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search Artist, Album or Track..."
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.textColor = UIColor.lightGray
        textField.attributedPlaceholder = NSAttributedString(string: "Search Artist, Album or Track...",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return textField
    }()
    
    var searchSegmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Artist", "Tracks", "Albums"])
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        segmentController.tintColor = UIColor.robinGreen
        segmentController.selectedSegmentIndex = 0
        return segmentController
    }()
    
    var searchResultsTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.backgroundColor = UIColor.lightGray
        return tableView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView() {
        addSubview(searchField)
        addSubview(searchSegmentController)
        addSubview(searchResultsTableView)
        
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            searchField.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ElementSizesManager.defaultPaddingSize),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ElementSizesManager.defaultPaddingSize),
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: ElementSizesManager.navigationBarMaxY),
            searchField.heightAnchor.constraint(equalToConstant: ElementSizesManager.searchBarHeight),
            
            searchSegmentController.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchSegmentController.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: ElementSizesManager.defaultPaddingSize),
            searchSegmentController.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ElementSizesManager.defaultPaddingSize),
            searchSegmentController.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ElementSizesManager.defaultPaddingSize),
            searchSegmentController.heightAnchor.constraint(equalToConstant: ElementSizesManager.segmentControllerHeight),
            
            searchResultsTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchResultsTableView.topAnchor.constraint(equalTo: searchSegmentController.bottomAnchor, constant: ElementSizesManager.defaultPaddingSize),
            searchResultsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ElementSizesManager.defaultPaddingSize),
            searchResultsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ElementSizesManager.defaultPaddingSize),
            searchResultsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ElementSizesManager.defaultPaddingSize),
            
            
            
            
        ])
        
    }
   

}
