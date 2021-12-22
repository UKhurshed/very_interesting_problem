//
//  DetailViewController.swift
//  very_interesting_problem
//
//  Created by Khurshed Umarov on 22.12.2021.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

    var imageResults: [ImagesResult] = []
    var indexOfCell: Int = 0
    let networkManager = NetworkManager.shared
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSet()
    }
    
    func imageSet(){
        let post = imageResults[indexOfCell]

        networkManager.image(imageResult: post) { data, error in
            let img = self.image(data: data)
            DispatchQueue.main.async {
                self.imageView.image = img
            }
        }
    }
    
    func image(data: Data?) -> UIImage?{
        if let data = data {
            return UIImage(data: data)
        }
        return UIImage(systemName: "not_found")
    }
    
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
