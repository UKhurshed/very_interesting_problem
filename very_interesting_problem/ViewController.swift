//
//  ViewController.swift
//  very_interesting_problem
//
//  Created by Khurshed Umarov on 18.12.2021.
//

import UIKit

class ViewController: UIViewController{
    
    let networkManager = NetworkManager.shared
    var posts: [ImagesResult] = []
    private var queryFrom: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(PictureTableViewCell.nib(), forCellReuseIdentifier: PictureTableViewCell.identifier)
    }
    
    
}

extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("text:\(searchBar.text)")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220
    }
}

