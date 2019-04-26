//
//  SizeCollectionViewCell.swift
//  Amaro-Challenge-iOS
//
//  Created by Ricardo Hochman on 26/04/19.
//  Copyright © 2019 Ricardo Hochman. All rights reserved.
//

import UIKit

class SizeCollectionViewCell: UICollectionViewCell, ReusableView {

    // MARK: - Outlets
    @IBOutlet private weak var sizeLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        sizeLabel.layer.borderColor = UIColor.darkGray.cgColor
        sizeLabel.layer.borderWidth = 1
        setSelected(value: false)
    }
    
    // MARK: - Setup
    func setup(size: Size) {
        sizeLabel.text = size.size
        sizeLabel.layer.cornerRadius = sizeLabel.bounds.width / 2
    }
    
    func setSelected(value: Bool) {
        sizeLabel.textColor = value ? .white : .black
        sizeLabel.backgroundColor = value ? .black : .white
    }
}
