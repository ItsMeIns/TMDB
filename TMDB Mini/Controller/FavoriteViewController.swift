//
//  FavoriteViewController.swift
//  TMDB Mini
//
//  Created by macbook on 09.02.2023.
//

import UIKit
import RealmSwift

final class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    //MARK: - IBOutlet - 
    
    @IBOutlet weak var tableViewFavorites: UITableView!
    
    //MARK: - Properties -
    
    var saveFavorite: [FavoritesRealm] = []
    
    //MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    //MARK: - Intents -
    
    private func configure() {
        let nib = UINib(nibName: MediaTableViewCellIdentifier, bundle: nil)
        tableViewFavorites.register(nib, forCellReuseIdentifier: MediaTableViewCellIdentifier)
    }
    
    private func fetch() {
        saveFavorite = DataManager.shared.getMedia()
        tableViewFavorites.reloadData()
    }
    
    //MARK: - UITableViewDataSource -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        saveFavorite.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableViewFavorites.dequeueReusableCell(
            withIdentifier: MediaTableViewCellIdentifier,
            for: indexPath
        ) as? MediaTableViewCell else {
            return UITableViewCell()
        }
            cell.configureRealm(model: saveFavorite[indexPath.row])
            return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let deteilController = main.instantiateViewController(
            withIdentifier: DeteilViewControllerIdentifier
        ) as? DeteilViewController {
            deteilController.mediaFromRealm = saveFavorite[indexPath.row]
            navigationController?.pushViewController(deteilController, animated: true)
        }
     }
  }

