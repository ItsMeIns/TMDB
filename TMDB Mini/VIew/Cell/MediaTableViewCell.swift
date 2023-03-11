//
//  MediaTableViewCell.swift
//  TMDB Mini
//
//  Created by macbook on 16.01.2023.
//

import UIKit
import Kingfisher

class MediaTableViewCell: UITableViewCell {
    
    var media: MovieAndSerials?
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var descriptionCell: UILabel!
    @IBOutlet weak var ratingCell: UILabel!
    @IBOutlet weak var releaseDateCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(with media: MovieAndSerials) {
        releaseDateCell.text = "\(media.release_date ?? media.first_air_date ?? "")"
        ratingCell.text = "\(media.vote_average ?? 0)"
        titleCell.text = media.title ?? media.name ?? ""
        descriptionCell.text = media.overview ?? ""
        loadPoster(imageName: media.posterPath ?? "no photo")
    }
    
    private func loadPoster(imageName: String) {
        imageCell.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w1280" + imageName))
    }
    
    func configureRealm(model: FavoritesRealm) {
        titleCell.text = model.title
        loadPoster(imageName: model.posterPath)
        descriptionCell.text = model.overview
        ratingCell.text = "\(model.rating)"
        releaseDateCell.text = "\(model.releaseDate)"
    }
}

           

