//
//  DeteilViewController.swift
//  TMDB Mini
//
//  Created by macbook on 01.02.2023.
//

import UIKit
import Alamofire
import youtube_ios_player_helper
import RealmSwift


class DeteilViewController: UIViewController {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var saveDeleteButton: UIButton!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var backgroundDescription: UIView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var playerYtbView: YTPlayerView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    //MARK: - Properties -
    
    var mediaType = ""
    var media: MovieAndSerials?
    var mediaTrailer: TrailerResult?
    var mediaFromRealm: FavoritesRealm?
    var isMediaInRealm: Bool?
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realmCheck(media: media)
        configure()
    }
    
    //MARK: - Intents -
    
    func realmCheck(media: MovieAndSerials?) {
        if media != nil {
            if DataManager.shared.isMovieInRealm(movie: media) {
                isMediaInRealm = true
                saveDeleteButton.setTitle(NSLocalizedString(isMediaInRealm! ? "Delete" : "Save", comment: ""), for: .normal)
                saveDeleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            } else {
                isMediaInRealm = false
                saveDeleteButton.setTitle(NSLocalizedString(isMediaInRealm! ? "Delete" : "Save", comment: ""), for: .normal)
                saveDeleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            }
            } else {
                isMediaInRealm = true
                saveDeleteButton.setTitle(NSLocalizedString(isMediaInRealm! ? "Delete" : "Save", comment: ""), for: .normal)
                saveDeleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            }
        }
    
    func configure() {
        switch isMediaInRealm {
        case true:
            movieName.text = mediaFromRealm?.title ?? ""
            rating.text = "\(mediaFromRealm?.rating ?? 0)"
            dateText.text = "\(mediaFromRealm?.releaseDate ??  "")"
            descriptionText.text = mediaFromRealm?.overview ?? ""
            loadPoster(imageName: mediaFromRealm?.backdropPath ?? "")
        case false:
            movieName.text = media?.title ?? media?.name ?? ""
            rating.text = "\(media?.vote_average ?? 0)"
            dateText.text = "\(media?.release_date ?? media?.first_air_date ?? "")"
            descriptionText.text = media?.overview ?? ""
            loadPoster(imageName: media?.backdrop_path ?? "")
        default:
            break
        }
        loadTrailer()
    }
    
    private func loadPoster(imageName: String) {
        backgroundImage.kf.setImage(with: URL(string: LoadPosterURL + imageName))
    }

    func loadTrailer() {
        if mediaType == MediaTypeMovie {
            NetworkManager.shared.getTrailerMovie(movieId: media?.id ?? 0) { id in
                id.forEach { video in
                    if video.type == Trailer {
                        self.playerYtbView.load(withVideoId: video.key)
                    }
                }
            }
        } else if mediaType == "tv" {
            NetworkManager.shared.getTrailerTv(movieId: media?.id ?? 0) { id in
                id.forEach { video in
                    if video.type == Trailer || video.type == Teaser {
                        self.playerYtbView.load(withVideoId: video.key)
                    }
                }
            }
        } else if mediaFromRealm?.isMovie == true {
            NetworkManager.shared.getTrailerMovie(movieId: mediaFromRealm?.trailer ?? 0) { id in
                id.forEach { video in
                    if video.type == Trailer {
                        self.playerYtbView.load(withVideoId: video.key)
                    }
                }
            }
        } else if mediaFromRealm?.isMovie == false {
            NetworkManager.shared.getTrailerTv(movieId: mediaFromRealm?.trailer ?? 00) { id in
                id.forEach { video in
                    if video.type == Trailer || video.type == Teaser {
                        self.playerYtbView.load(withVideoId: video.key)
                    }
                }
            }
        }
    }
        
    //MARK: - Save button to favorites -
    
    @IBAction func saveMediaToRealm(_ sender: Any) {
        saveDeleteButton.setTitle(NSLocalizedString(isMediaInRealm! ? "Save" : "Delete", comment: ""), for: .normal)
        switch isMediaInRealm {
        case true:
            if let media = media {
                let movie = DataManager.shared.getFilm(media: media)
                DataManager.shared.deleteMedia(movie: movie)
                print("Delete media")
                showAlert(title: NSLocalizedString("Success", comment: ""), message: String(format: NSLocalizedString("\"%@\" %@", comment: ""), media.name ?? media.title ?? "",
                   NSLocalizedString("removed from favorites", comment: "")))
            } else if let mediaFromRealm = mediaFromRealm {
                DataManager.shared.deleteMedia(movie: mediaFromRealm)
                navigationController?.popToRootViewController(animated: true)
                print("Delete realm media")
                showAlert(title: NSLocalizedString("Success", comment: ""), message: String(format: NSLocalizedString("\"%@\" %@",
                   comment: ""), media?.name ?? media?.title ?? "",
                   NSLocalizedString("removed from favorites", comment: "")))
            }
            isMediaInRealm = false
        case false:
            if mediaType == "movie" {
                DataManager.shared.saveMedia(movie: media, isMovie: true)
            } else if mediaType == "tv" {
                DataManager.shared.saveMedia(movie: media, isMovie: false)
            }
           print("Save media")
            showAlert(title: NSLocalizedString("Success", comment: ""), message: String(format: NSLocalizedString("\"%@\" %@",
               comment: ""), media?.name ?? media?.title ?? "",
               NSLocalizedString("added to favorites", comment: "")))
            isMediaInRealm = true
        default:
            break
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}




