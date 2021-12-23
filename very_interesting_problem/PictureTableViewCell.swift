//
//  PictureTableViewCell.swift
//  very_interesting_problem
//
//  Created by Khurshed Umarov on 22.12.2021.
//

import UIKit

/// UITableViewCell xib
class PictureTableViewCell: UITableViewCell {
    
    /// IBOutlet from imageView
    @IBOutlet weak var pictureView: UIImageView!
    
    /// Identifier from Cell
    static let identifier = "PictureCell"
    /// UINib xib
    /// - Returns: UINib
    static func nib() -> UINib{
        return UINib(nibName: "PictureTableViewCell", bundle: nil)
    }
    
    /// Initialize method
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureView.contentMode = .scaleAspectFill
    }
    
    /// Setting image
    var image: UIImage?{
        didSet{
            pictureView.image = image
        }
    }
    
}
