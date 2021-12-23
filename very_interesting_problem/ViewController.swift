//
//  ViewController.swift
//  very_interesting_problem
//
//  Created by Khurshed Umarov on 18.12.2021.
//

import UIKit

/// Main ViewController, show list of photos
class ViewController: UIViewController{
    
    /// Singleton instance of network manager
    let networkManager = NetworkManager.shared
    /// Array of ImagesResult, sends to TableViewDataSource
    var posts: [ImagesResult] = []
    /// Store query from UISearchBar
    private var queryFrom: String = ""
    
    /// IBOutlets UI: TableView and SearchBar
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    /// LifeCycle method, initialize and register all of properties
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(PictureTableViewCell.nib(), forCellReuseIdentifier: PictureTableViewCell.identifier)
    }
    
    
}

extension ViewController: UISearchBarDelegate{
    
    /// This delegate method works when User after typing characters tap an enter keyword, and calling "fetchImagesByQuery" method from NetworkManager
    /// - Parameter searchBar: searchBar UISearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("text:\(searchBar.text ?? "none")")
        guard let searchBarTxt = searchBar.text else{
            debugPrint("nullable value from searchBar text")
            return
        }
        self.networkManager.fetchImagesByQuery(query: searchBarTxt){ [weak self] images, error in
            if let error = error{
                debugPrint("Error from networkManager: \(error)")
                return
            }
            self?.posts = images!
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
    }
    
}

extension ViewController: UITableViewDataSource{
    /// numberOfRowsInSection method from UITableView
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: numberOfRowsInSection
    /// - Returns: Count of ImagesResult array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! PictureTableViewCell
        let post = posts[indexPath.item]
        
        func image(data: Data?) -> UIImage?{
            if let data = data {
                return UIImage(data: data)
            }
//            return UIImage(systemName: "not_found")
            return nil
        }
        
        networkManager.image(imageResult: post) { data, error in
            guard let img = image(data: data) else{
                debugPrint("nil from data")
                return
            }
            DispatchQueue.main.async {
                cell.image = img
            }
        }
        return cell
    }
    
}

extension ViewController: UITableViewDelegate{
    /// When tap an element of list, DetailViewController page opens
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("index of Image: \(indexPath.row)")
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailVC") as? DetailViewController {
            viewController.indexOfCell = indexPath.row
            viewController.imageResults = posts
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    /// Height of each cell from tableView
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: heightForRowAt
    /// - Returns: CGFloat
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220
    }
}

