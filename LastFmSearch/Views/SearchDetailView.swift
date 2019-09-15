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
      //  label.numberOfLines = 0
        label.sizeToFit()
      //  label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.isScrollEnabled = true
        label.isEditable = false
        label.isUserInteractionEnabled = true
        label.text = "Believe is the twenty-third studio album by American  singer-actress Cher, released on November 10, 1998 by Warner Bros. Records. The RIAA certified it Quadruple Platinum on December 23, 1999, recognizing four million shipments in the United States; Worldwide, the album has sold more than 20 million copies, making it the biggest-selling album of her career. In 1999 the album received three Grammy Awards nominations including \"Record of the Year\", \"Best Pop Album\" and winning \"Best Dance Recording\" for the single \"Believe\".\n\nIt was released by Warner Bros. Records at the end of 1998. The album was executive produced by Rob Dickens. Upon its debut, critical reception was generally positive. Believe became Cher's most commercially-successful release, reached number one and Top 10 all over the world. In the United States, the album was released on November 10, 1998, and reached number four on the Billboard 200 chart, where it was certified four times platinum.\n\nThe album featured a change in Cher's music; in addition, Believe presented a vocally stronger Cher and a massive use of vocoder and Auto-Tune. In 1999, the album received 3 Grammy Awards nominations for \"Record of the Year\", \"Best Pop Album\" and winning \"Best Dance Recording\". Throughout 1999 and into 2000 Cher was nominated and winning many awards for the album including a Billboard Music Award for \"Female Vocalist of the Year\", Lifelong Contribution Awards and a Star on the Walk of Fame shared with former Sonny Bono. The boost in Cher's popularity led to a very successful Do You Believe? Tour.\n\nThe album was dedicated to Sonny Bono, Cher's former husband who died earlier that year from a skiing accident.\n\nCher also recorded a cover version of \"Love Is in the Air\" during early sessions for this album. Although never officially released, the song has leaked on file sharing networks.\n\nSingles\n\n\n\"Believe\"\n\"Strong Enough\"\n\"All or Nothing\"\n\"Dov'Ã¨ L'Amore\" &lt;a href=\"http://www.last.fm/music/Cher/Believe\"&gt;Read more on Last.fm&lt;/a&gt;. User-contributed text is available under the Creative Commons By-SA License; additional terms may apply"
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        if let artistObject = artistObject {
            headerLabel.text = artistObject.name
            subtitleLabel.text = "Listeners: \(String(describing: artistObject.listeners))"
            artistButton.isHidden = true
            searchDetailImageView.downloadImageFrom(link: artistObject.imageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
        } else if let trackObject = trackObject {
            headerLabel.text = trackObject.name
            subtitleLabel.text = "Listeners: \(String(describing: trackObject.listeners))"
            artistButton.setTitle(trackObject.artist, for: .normal)
            searchDetailImageView.downloadImageFrom(link: trackObject.imageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
            
        } else if let albumObject = albumObject {
            headerLabel.text = albumObject.name
            // subtitleLabel.text = "Listeners: \(String(describing: trackObject.listeners))"
            artistButton.setTitle(albumObject.artist, for: .normal)
            searchDetailImageView.downloadImageFrom(link: albumObject.imageUrl ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
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
            headerLabel.heightAnchor.constraint(equalToConstant: ElementSizesManager.cellHeaderTextHeight),
            
            artistButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            artistButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: ElementSizesManager.defaultPaddingSize),
            artistButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ElementSizesManager.defaultPaddingSize),
            artistButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ElementSizesManager.defaultPaddingSize),
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
