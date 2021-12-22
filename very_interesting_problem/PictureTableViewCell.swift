//
//  PictureTableViewCell.swift
//  very_interesting_problem
//
//  Created by Khurshed Umarov on 22.12.2021.
//

import UIKit

class PictureTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    
    static let identifier = "PictureCell"
    static func nib() -> UINib{
        return UINib(nibName: "PictureTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var image: UIImage?{
        didSet{
            pictureView.image = image
        }
    }
    
}
