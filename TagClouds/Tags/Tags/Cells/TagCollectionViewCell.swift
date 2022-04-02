//
//  TagCollection.swift
//  TagCloud
//
//  Created by Никита Комаров on 01.04.2022.
//

import UIKit

// MARK: - Кастомизация ячеек
class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundVieww: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.cornerRadius = backgroundVieww.layer.cornerRadius
        gradient.type = .axial
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.purple.cgColor
        ]
        gradient.locations = [0, 0.85]
        return gradient
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.titleLabel.intrinsicContentSize.width + 40.0, height: 40.0)
    }
    
    @IBAction func tagPressed(_ sender: Any) {
        if backgroundVieww.layer.sublayers![0] != gradient {
            gradient.frame = backgroundVieww.bounds
            backgroundVieww.layer.insertSublayer(gradient, at: 0)
        } else {
                gradient.removeFromSuperlayer()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundVieww.layer.cornerRadius = 25/2
    }
    
    func config(info: String) {
        self.titleLabel.text = info
    }
}
