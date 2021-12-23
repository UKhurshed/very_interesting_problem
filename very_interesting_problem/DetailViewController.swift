//
//  DetailViewController.swift
//  very_interesting_problem
//
//  Created by Khurshed Umarov on 22.12.2021.
//

import UIKit
import SafariServices

/// DetailViewContoller show list [ImagesResult] of elements by Index
class DetailViewController: UIViewController {
    
    /// list of elements after calling to network
    var imageResults: [ImagesResult] = []
    /// Index from cell
    var indexOfCell: Int = 0
    /// networkManager instance for fetching image from cache
    let networkManager = NetworkManager.shared
    
    @IBOutlet weak var imageView: UIImageView!
    
    /// LifeCycle method, shows image after click element of list
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSet()
    }
    
    /// Check image by URL from networkManager is exists from cache or need to download
    func imageSet(){
        let post = imageResults[indexOfCell]

        networkManager.image(imageResult: post) { data, error in
            let img = self.image(data: data)
            DispatchQueue.main.async {
                self.imageView.image = img
            }
        }
    }
    
    /// If data is valid, show image from Url, else show static picture from assets
    /// - Parameter data: Data?
    /// - Returns: UIImage
    func image(data: Data?) -> UIImage?{
        if let data = data {
            return UIImage(data: data)
        }
        return UIImage(systemName: "not_found")
    }
    
    /// Show next image from main list after calling from network
    /// - Parameter sender: sender: Any
    @IBAction func nextBtn(_ sender: Any) {
        debugPrint("index: \(indexOfCell)")
        if self.indexOfCell == self.imageResults.count - 1 {
            self.indexOfCell = self.imageResults.count - 1
            imageSet()
        }else{
            self.indexOfCell+=1
            imageSet()
        }
       
    }
    
    /// Show previous image from main list after calling from network
    /// - Parameter sender: sender Any
    @IBAction func prevBtn(_ sender: Any) {
        debugPrint("index: \(indexOfCell)")
        if self.indexOfCell == 0 {
            self.indexOfCell = 0
            imageSet()
        }else{
            self.indexOfCell-=1
            imageSet()
        }
        
    }
    
    /// Button opens safari to show website of image
    /// - Parameter sender: sender: Any
    @IBAction func linkBtn(_ sender: Any) {
        let imageResult = imageResults[indexOfCell]
        
        guard let url = URL(string: imageResult.link) else{
           debugPrint("url from ImageResult occurred error")
            return
        }
        
        let vc = SFSafariViewController(url:url)
        present(vc, animated: true)
    }
}
