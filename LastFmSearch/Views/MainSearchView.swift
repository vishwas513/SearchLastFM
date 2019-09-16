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
            guard let searchText = searchField.text, let apiKey = viewModel?.apiKey, let count = viewModel?.artistList.count else { return SearchResultCell() }
            if indexPath.row == count - 1 {
                viewModel?.artistPage += 1
                viewModel?.searchArtists(searchTerm: searchText, apiKey: apiKey, updatePage: true, completion: {
                    _ in
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                })
            }
            cell = SearchResultCell(artistObject: viewModel?.artistList[safe: indexPath.row] ?? Artist())
            cell.searchImageView.image = UIImage(named: "placeholder")  //set placeholder image first
            cell.searchImageView.downloadImageFrom(link: viewModel?.artistList[safe: indexPath.row]?.imageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
        case 1:
            guard let searchText = searchField.text, let apiKey = viewModel?.apiKey, let count = viewModel?.trackList.count else { return SearchResultCell() }
            if indexPath.row == count - 1 {
                viewModel?.trackPage += 1
                viewModel?.searchTracks(searchTerm: searchText, apiKey: apiKey, updatePage: true, completion: {
                    _ in
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                })
            }

            cell = SearchResultCell(trackObject: viewModel?.trackList[safe: indexPath.row] ?? Track())
            cell.searchImageView.image = UIImage(named: "placeholder")  //set placeholder image first.
            cell.searchImageView.downloadImageFrom(link: viewModel?.trackList[safe: indexPath.row]?.imageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
        default:
            guard let searchText = searchField.text, let apiKey = viewModel?.apiKey, let count = viewModel?.albumList.count else { return SearchResultCell() }
            if indexPath.row == count - 1 {
                viewModel?.albumPage += 1
                viewModel?.searchAlbums(searchTerm: searchText, apiKey: apiKey, updatePage: true, completion: {
                    _ in
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                })
            }
            cell = SearchResultCell(albumObject: viewModel?.albumList[safe: indexPath.row] ?? Album())
            cell.searchImageView.image = UIImage(named: "placeholder")  //set placeholder image first.
            cell.searchImageView.downloadImageFrom(link: viewModel?.albumList[safe: indexPath.row]?.imageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
        }
        let cellBackgroundView = UIView()
        cellBackgroundView.backgroundColor = UIColor.robinGreen.withAlphaComponent(0.1)
        cell.selectedBackgroundView = cellBackgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ElementSizesManager.cellRowHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.transform = CGAffineTransform(translationX: 0, y: ElementSizesManager.cellRowHeight)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0
            
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(0.5)
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchDetailController = SearchDetailController()
        searchDetailController.viewModel = viewModel
        switch viewModel?.searchSelectedSegmentIndex {
            
        case 0:
            searchDetailController.artistObject = viewModel?.artistList[safe: indexPath.row]
            guard let name = viewModel?.artistList[indexPath.row].name else { return }
            viewModel?.getDescriptionForEntity(mode: SearchResultType.artist, entityName: name, completion: {
                result in
                
                if let result = result {
                    searchDetailController.descriptionText = result
                    DispatchQueue.main.async {
                        self.controller?.navigationController?.pushViewController(searchDetailController, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Network Error occured.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.controller?.present(alert, animated: true)
                    }
                }
            })
            
        case 1:
            searchDetailController.trackObject = viewModel?.trackList[safe: indexPath.row]
            guard let name = viewModel?.trackList[indexPath.row].name, let artistName = viewModel?.trackList[indexPath.row].artist else { return }
            viewModel?.getDescriptionForEntity(mode: SearchResultType.track, entityName: name, artistName: artistName, completion: {
                result in
                if let result = result {
                    searchDetailController.descriptionText = result
                    DispatchQueue.main.async {
                        self.controller?.navigationController?.pushViewController(searchDetailController, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Network Error occured.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.controller?.present(alert, animated: true)
                    }
                }
            })
            
        default:
            searchDetailController.albumObject = viewModel?.albumList[indexPath.row]
            guard let name = viewModel?.albumList[safe: indexPath.row]?.name, let artistName = viewModel?.albumList[safe: indexPath.row]?.artist else { return }
            viewModel?.getDescriptionForEntity(mode: SearchResultType.album, entityName: name, artistName: artistName, completion: {
                result in
                if let result = result {
                    searchDetailController.descriptionText = result
                    DispatchQueue.main.async {
                        self.controller?.navigationController?.pushViewController(searchDetailController, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Network Error occured.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.controller?.present(alert, animated: true)
                    }
                }
            })
        }
    }
}


final class MainSearchView: UIView {
    var viewModel: MainSearchViewModel?
    var controller: MainSearchController?
    let mainSearchViewModel = MainSearchViewModel()
    
    var searchField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.robinGreen.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.textColor = UIColor.lightGray
        textField.attributedPlaceholder = NSAttributedString(string: "  Search Artist, Album or Track...",
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
        tableView.backgroundColor = UIColor.black
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
        searchResultsTableView.separatorStyle = .none
        
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
