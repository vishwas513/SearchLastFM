//
//  SearchResultCell.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/14/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    var searchImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var searchResultHeader: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    var searchResultSubtitle: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(artistObject: Artist) {
        self.init()
        guard let listeners = artistObject.listeners else { return }
        searchResultHeader.text = artistObject.name
        searchResultSubtitle.text = "Listeners: \(listeners)"
        
        setupView()
    }
    
    init(albumObject: Album) {
        self.init()
        guard let artistName = albumObject.artist else { return }
        searchResultHeader.text = albumObject.name
        searchResultSubtitle.text = "Artist: \(artistName)"
        
        setupView()
    }
    
    init(trackObject: Track) {
        self.init()
        guard let artistName = trackObject.artist else { return }
        searchResultHeader.text = trackObject.name
        searchResultSubtitle.text = "Artist: \(artistName)"
        
        setupView()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        backgroundColor = .black
        contentView.addSubview(searchImageView)
        contentView.addSubview(searchResultHeader)
        contentView.addSubview(searchResultSubtitle)
        
        searchResultHeader.numberOfLines = 0
        searchResultSubtitle.numberOfLines = 0
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            searchImageView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor),
            searchImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: ElementSizesManager.cellPaddigSize),
            searchImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: ElementSizesManager.cellPaddigSize),
            searchImageView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: ElementSizesManager.cellPaddigSize),
            searchImageView.widthAnchor.constraint(equalTo: searchImageView.heightAnchor),
            
            searchResultHeader.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: ElementSizesManager.cellPaddigSize),
            searchResultHeader.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: ElementSizesManager.cellPaddigSize),
            searchResultHeader.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -ElementSizesManager.cellPaddigSize),
            searchResultHeader.heightAnchor.constraint(equalToConstant: ElementSizesManager.cellHeaderTextHeight),
            
            searchResultSubtitle.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: ElementSizesManager.cellPaddigSize),
            searchResultSubtitle.topAnchor.constraint(equalTo: searchResultHeader.bottomAnchor, constant: ElementSizesManager.cellPaddigSize),
            searchResultSubtitle.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -ElementSizesManager.cellPaddigSize),
            searchResultSubtitle.heightAnchor.constraint(equalToConstant: ElementSizesManager.cellSubtitleTextHeight),
            
            ])
    }
}
