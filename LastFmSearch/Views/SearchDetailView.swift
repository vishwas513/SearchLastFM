//
//  SearchDetailView.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/15/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

class SearchDetailView: UIView {
    
    var artistObject: Artist?
    var albumObject: Album?
    var trackObject: Track?
    
    var searchDetailImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var headerLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.robinGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 26)
        return label
    }()
    
    var artistButton: UIButton = {
        var button = UIButton()
        button.setTitleColor(UIColor.approveGreen, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var subtitleLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var linkButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("www.google.com", for: .normal)
        button.setTitleColor(UIColor.buttonBlue, for: .normal)
        return button
    }()
    
    var descriptionLabel: UITextView = {
        var label = UITextView()
        label.textColor = UIColor.lightGray
        label.isScrollEnabled = true
        label.isEditable = false
        label.isUserInteractionEnabled = true
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black
        return label
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
        
        if let artistObject = artistObject, let listeners = artistObject.listeners {
            headerLabel.text = artistObject.name
            subtitleLabel.text = "Listeners: \(listeners)"
            artistButton.isHidden = true
            searchDetailImageView.downloadImageFrom(link: artistObject.highQualityImageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
            linkButton.setTitle(artistObject.link, for: .normal)
        } else if let trackObject = trackObject, let listeners = trackObject.listeners {
            headerLabel.text = trackObject.name
            subtitleLabel.text = "Listeners: \(listeners)"
            artistButton.setTitle(trackObject.artist, for: .normal)
            searchDetailImageView.downloadImageFrom(link: trackObject.highQualityImageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
            linkButton.setTitle(trackObject.link, for: .normal)
            
        } else if let albumObject = albumObject {
            headerLabel.text = albumObject.name
            // subtitleLabel.text = "Listeners: \(String(describing: trackObject.listeners))"
            artistButton.setTitle(albumObject.artist, for: .normal)
            searchDetailImageView.downloadImageFrom(link: albumObject.highQualityImageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
            linkButton.setTitle(albumObject.link, for: .normal)
        }
        
        
        
        backgroundColor = .black
        
        addSubview(searchDetailImageView)
        addSubview(headerLabel)
        addSubview(subtitleLabel)
        addSubview(artistButton)
        addSubview(linkButton)
        addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            searchDetailImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchDetailImageView.topAnchor.constraint(equalTo: topAnchor, constant: ElementSizesManager.navigationBarMaxY),
            searchDetailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchDetailImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchDetailImageView.heightAnchor.constraint(equalToConstant: ElementSizesManager.windowHeight/3),
            
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: searchDetailImageView.bottomAnchor, constant: ElementSizesManager.defaultPaddingSize),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ElementSizesManager.defaultPaddingSize),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ElementSizesManager.defaultPaddingSize),
            headerLabel.heightAnchor.constraint(equalToConstant: ElementSizesManager.cellHeaderTextHeight + 10),
            
            artistButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            artistButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: ElementSizesManager.defaultPaddingSize),
            artistButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ElementSizesManager.defaultPaddingSize + 100),
            artistButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ElementSizesManager.defaultPaddingSize - 100),
            artistButton.heightAnchor.constraint(equalToConstant: ElementSizesManager.cellHeaderTextHeight),
            
            linkButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            linkButton.topAnchor.constraint(equalTo: artistButton.bottomAnchor, constant: ElementSizesManager.defaultPaddingSize),
            linkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ElementSizesManager.defaultPaddingSize),
            linkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ElementSizesManager.defaultPaddingSize),
            linkButton.heightAnchor.constraint(equalToConstant: ElementSizesManager.cellHeaderTextHeight),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: ElementSizesManager.defaultPaddingSize),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ElementSizesManager.defaultPaddingSize),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ElementSizesManager.defaultPaddingSize),
            subtitleLabel.heightAnchor.constraint(equalToConstant: ElementSizesManager.cellSubtitleTextHeight),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: ElementSizesManager.defaultPaddingSize),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ElementSizesManager.defaultPaddingSize),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ElementSizesManager.defaultPaddingSize),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ElementSizesManager.defaultPaddingSize)
        ])
    }
}
