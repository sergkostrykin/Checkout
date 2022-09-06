//
//  ButtonCollectionViewCell.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 05/09/2022.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    private var onButtonClicked: (()->())?
    
    // MARK: - Outlets
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - Actions
    @IBAction func onButtonClicked(_ sender: Any) {
        onButtonClicked?()
    }
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func setup(title: String?, onButtonClicked: (()->())?) {
        self.onButtonClicked = onButtonClicked
        button.setTitle(title, for: .normal)
    }

}


