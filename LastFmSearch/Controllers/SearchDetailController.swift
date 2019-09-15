//
//  SearchDetailController.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/15/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

class SearchDetailController: UIViewController {
    
    let searchDetailView = SearchDetailView()
    var artistObject: Artist?
    var trackObject: Track?
    var albumObject: Album?
    var descriptionText: String?
    var viewModel: MainSearchViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = searchDetailView
        
        if let artistObject = artistObject {
            searchDetailView.artistObject = artistObject
        } else if let trackObject = trackObject {
            searchDetailView.trackObject = trackObject
        } else if let albumObject = albumObject {
            searchDetailView.albumObject = albumObject
        }
        searchDetailView.descriptionLabel.text = descriptionText
        searchDetailView.setupView()
        
        searchDetailView.linkButton.addTarget(self, action: #selector(openLink(sender:)), for: .touchUpInside)
        
        searchDetailView.artistButton.addTarget(self, action: #selector(loadArtist(sender:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func openLink(sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text,let url = URL(string: buttonTitle) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func loadArtist(sender: UIButton) {
        guard let artistName = sender.titleLabel?.text else { return }
        viewModel?.getArtistInfo(artistName: artistName, completion: {
            result in
            
            if let result = result {
                var searchDetailController = SearchDetailController()
                searchDetailController.artistObject = result
                searchDetailController.descriptionText = result.bio
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(searchDetailController, animated: true)
                }
                
            }
        })
       
        
        
        
        
    }
    
}
