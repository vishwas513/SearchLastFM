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
        searchDetailView.setupView()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
