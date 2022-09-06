//
//  TextFieldCollectionViewCell.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 05/09/2022.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell {

    private var onEndEditing: ((String?) -> ())?
    private var onReturn: (() -> ())?
    private var onStringChanged: ((String?) -> ())?
    private var characterLimit: Int?
    private var formatMask: String?

    @IBOutlet private weak var cellTitleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var line: UIView!
    @IBOutlet private weak var disclosureViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var disclosureImageView: UIImageView!
    
    @objc func doneButtonClicked(_ sender: UIButton) {
        textField.resignFirstResponder()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    func setup(title: String?,
               value: String?,
               titleColor: UIColor = .darkGray,
               placeholder: String? = nil,
               formatMask: String? = nil,
               disclosureImage: UIImage? = nil,
               inputView: UIView? = nil,
               inputAccessoryView: UIView? = nil,
               isFirstResponder: Bool = false,
               keyboardType: UIKeyboardType = .default,
               textContentType: UITextContentType? = nil,
               isSecurityEntry: Bool = false,
               isEditable: Bool = true,
               isUserInteractionEnabled: Bool = true,
               characterLimit: Int? = nil,
               isTabBarEnabled: Bool = false,
               onStringChanged: ((String?) -> ())? = nil,
               onReturn: (() -> ())? = nil,
               onEndEditing: ((String?) -> ())?) {
        
        cellTitleLabel.text = title
        cellTitleLabel.textColor = titleColor
        textField.text = value
        if let mask = formatMask {
            textField.text = value?.formatDigits(mask: mask)
        } else {
            textField.text = value
        }
        textField.placeholder = placeholder
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray, .font: textField.font ?? UIFont.helveticaNeue(ofSize: 15)]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecurityEntry
        textField.inputView = inputView
        textField.inputAccessoryView = inputAccessoryView
        textField.isUserInteractionEnabled = isUserInteractionEnabled
        textField.textContentType = textContentType
        textField.isEnabled = isEditable
        self.onStringChanged = onStringChanged
        self.onEndEditing = onEndEditing
        self.onReturn = onReturn
        self.characterLimit = characterLimit
        self.formatMask = formatMask
        if isFirstResponder {
            textField.becomeFirstResponder()
        }
        textField.inputAccessoryView = nil
        if isTabBarEnabled {
            addTabbar()
        }
        disclosureImageView.image = disclosureImage
        disclosureViewWidthConstraint.constant = disclosureImage == nil ? 0 : 50
    }
    
    func update(disclosureImage: UIImage?) {
        disclosureImageView.image = disclosureImage
        disclosureViewWidthConstraint.constant = disclosureImage == nil ? 0 : 50
    }
    
    func addTabbar() {
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneButtonClicked))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        textField.inputAccessoryView = toolBar
    }
}

extension TextFieldCollectionViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        onEndEditing?(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        onReturn?()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let new = textField.text! as NSString
        let newText = new.replacingCharacters(in: range, with: string)
        onStringChanged?(newText)
        if let characterLimit = characterLimit, characterLimit > 0 {
            return newText.count <= characterLimit
        } else if let mask = formatMask {
            textField.text = newText.formatDigits(mask: mask)
            return false
        }
        return true
    }
}

