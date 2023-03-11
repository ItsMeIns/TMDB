//
//  ViewController.swift
//  TMDB Mini
//
//  Created by macbook on 13.01.2023.
//

import UIKit
import Alamofire


final class MoviesАndSerials: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var serchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableVIew: UITableView!
    
    
    //MARK: - Properties -
    
    enum TabState: Int  {
        case movie = 0
        case tv = 1
    }
    var currentTab: TabState = .movie
    private var currentPage = 1
    private var isLoadingList = false
    var isSearching = false
    
    lazy private var workItem = WorkItem()
   
    
    //MARK: - Content -
    
    var content: [MovieAndSerials] = []
    var filteredContent: [MovieAndSerials] = []
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        let nib = UINib(nibName: MediaTableViewCellIdentifier, bundle: nil)
        tableVIew.register(nib, forCellReuseIdentifier: MediaTableViewCellIdentifier)
        getMoviesFromSite(page: currentPage)
        
        //removes the keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        // SC settings
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.layer.borderColor = #colorLiteral(red: 0.01568627451, green: 0.1215686275, blue: 0.2156862745, alpha: 1)
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.01387538388, green: 0.1198410466, blue: 0.2173165679, alpha: 1)
        segmentedControl.layer.borderWidth = 1
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    
    //MARK: - Intents -
    
private func getMoviesFromSite(page: Int) {
        isLoadingList = true
    let currentLanguage = Locale.current.language.languageCode?.identifier ?? "en-US"
    NetworkManager.shared.getTrendingMedia(mediaType: currentTab == .movie ? "movie" : "tv", page: page, language: currentLanguage) { [weak self] result in
            switch result {
            case .success(let model):
                self?.content += model.results ?? []
            case .failure(let error):
                print(error)
            }
            self?.isLoadingList = false
            self?.tableVIew.reloadData()
        }
    }
    
func searchMedia(mediaType: TabState, search: String) {
    let currentLanguage = Locale.current.language.languageCode?.identifier ?? "en-US"
    NetworkManager.shared.searchMedia(mediaType: mediaType == .movie ? "movie" : "tv", query: search, language: currentLanguage) { [weak self] result in
            switch result {
            case .success(let model):
                self?.filteredContent = model.results ?? []
            case .failure(let error):
                print(error)
            }
            self?.isSearching = true
            self?.tableVIew.reloadData()
        }
    }
    
    func result(data: DataResponse<MovieAndSerialsModel, AFError>) {
        switch data.result {
        case .success(let model):
            content += model.results ?? []
        case .failure(let error):
            print(error)
        }
        isLoadingList = false
        tableVIew.reloadData()
    }
    
    func loadMoreItemsForList() {
        print("load more")
        currentPage += 1
        getMoviesFromSite(page: currentPage)
    }
    
    @IBAction
    func segmentedControlAction(_ sender: UISegmentedControl) {
        currentTab = TabState(rawValue: sender.selectedSegmentIndex) ?? .movie
        clear()
        switch currentTab {
        case .movie:
            getMoviesFromSite(page: currentPage)
            print("movie")
        case .tv:
            getMoviesFromSite(page: currentPage)
            print("tv")
        }
    }
    
     func clear() {
        currentPage = 1
        content = []
        tableVIew.reloadData()
    }
    
    func appendFiltered(searchT: String) {
        for item in content {
            let text = searchT.lowercased()
            let isArrayContain = item.title?.lowercased().range(of: text) ?? item.name?.lowercased().range(of: text)
            
            if isArrayContain != nil
            {
                print("search complete")
               
                    filteredContent.append(item)
            }
        }
    }
    
    func searchOrNot(bar: UISearchBar)   {
        if bar.text == ""
        {
            isSearching = false
            tableVIew.reloadData()
        } else {
            isSearching = true
            switch currentTab {
            case .movie:
                filteredContent += self.content.filter(
                    {
                        $0.title!.contains(bar.text ?? "")
                    })
            case .tv:
                filteredContent += self.content.filter(
                    {
                        $0.name!.contains(bar.text ?? "")
                    })
            }
            tableVIew.reloadData()
        }
    }
    
    func search(searchBar: UISearchBar, searchText: String) {
        self.searchMedia(mediaType: self.currentTab, search: searchText)
        
        switch self.currentTab {
        case .movie:
            self.filteredContent.removeAll()
            self.appendFiltered(searchT: searchText.lowercased())
            self.searchOrNot(bar: searchBar)
        case .tv:
            self.filteredContent.removeAll()
            self.appendFiltered(searchT: searchText.lowercased())
            self.searchOrNot(bar: searchBar)
        }
    }
    
    //MARK: - UITableViewDataSource -
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        let mediaSearch = isSearching ? filteredContent.count : content.count
        return mediaSearch
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MediaTableViewCellIdentifier,
            for: indexPath
        ) as? MediaTableViewCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        let media = isSearching ? filteredContent[index] : content[index]
        cell.configure(with: media)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        330
    }
    
    //to another page with detailed information
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: DeteilViewControllerIdentifier
        ) as? DeteilViewController else {
            return
        }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            vc.mediaType = "movie"
        case 1:
            vc.mediaType = "tv"
        default:
            break
        }
        let index = indexPath.row
        vc.media = isSearching ? filteredContent[index] : content[index]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(
        _ scrollVIew: UIScrollView
    ) {
        if (((scrollVIew.contentOffset.y + scrollVIew.frame.size.height) > scrollVIew.contentSize.height) && !isLoadingList
        ) {
            isLoadingList = true
            loadMoreItemsForList()
        }
    }
    
    // MARK: - UISearchBarDelegate -
    
    func searchBar(
        _ searchBar: UISearchBar, textDidChange searchText: String
    ) {
        workItem.perform(after: 0.5) {
            if searchText == "" {
                self.isSearching = false
                self.getMoviesFromSite(page: self.currentPage)
            } else {
                print(searchText)
                self.search(searchBar: searchBar, searchText: searchText)
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

