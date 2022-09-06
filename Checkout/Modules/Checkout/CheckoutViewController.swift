//
//  CheckoutViewController.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 31/08/2022.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        var object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.dataSource = self
        object.delegate = self
        object.register(UINib(nibName: "TextFieldCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TextFieldCollectionViewCell")
        object.register(UINib(nibName: "ButtonCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ButtonCollectionViewCell")
        object.showsVerticalScrollIndicator = false
        object.isScrollEnabled = false
        object.backgroundColor = .white
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()


    // MARK: - Properties
    private var creditCard = CreditCard()

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraints()
    }
    
}

private extension CheckoutViewController {
    
    func setupUI() {
        view.addSubview(collectionView)
    }
    
    func updateConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    func validate() {
        guard let error = creditCard.validate() else {
            payRequest()
            return
        }
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Requests
    func payRequest() {
        NetworkingService.pay(creditCard: creditCard) { [weak self] urlString, error in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                } else if let urlString = urlString, let url = URL(string: urlString) {
                    self?.showSecureViewConroller(url: url)
                }

            }
        }
    }
    
    // MARK: - Navigation
    func showSecureViewConroller(url: URL) {
        let controller = SecureViewController(url: url) { [weak self] controller, isSuccess in
            controller.dismiss(animated: true) {
                self?.showResultViewController(isSuccess: isSuccess)
            }
        }
        present(controller, animated: true)
    }
    
    func showResultViewController(isSuccess: Bool) {
        let controller = ResultViewController(isSuccess: isSuccess)
        present(controller, animated: true)
    }
    
    // MARK: - Keyboard
    @objc func keyboardWillShow(aNotification: NSNotification) {
        let info = aNotification.userInfo
        let kbSize: CGSize = (info?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        collectionView.contentInset = contentInsets
        collectionView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        collectionView.contentInset = contentInsets
        collectionView.scrollIndicatorInsets = contentInsets
    }

        
}

// MARK: - UICollectionViewDelegate
extension CheckoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum Item: Int, CaseIterable {
        case cardNumber, expireDate, cvv, payButton
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Item.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = Item(rawValue: indexPath.item) else { return .zero }
        switch item {
        case .cardNumber:
            return CGSize(width: collectionView.frame.width, height: 50)
        case .expireDate, .cvv:
            return CGSize(width: collectionView.frame.width / 2, height: 50)
        case .payButton:
            return CGSize(width: collectionView.frame.width, height: 60)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = Item(rawValue: indexPath.item) else { return UICollectionViewCell() }
        switch item {
        case .cardNumber:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
            cell.setup(title: "Card number",
                       value: creditCard.cardNumber,
                       placeholder: "1234 1234 1234 1234",
                       formatMask: .creditCardNumberMask,
                       disclosureImage: creditCard.scheme?.image,
                       keyboardType: .numberPad,
                       isTabBarEnabled: true, onStringChanged: { [weak self] newValue in
                self?.creditCard.scheme = CardScheme.scheme(cardNumber: newValue?.digitsOnly)
                cell.update(disclosureImage: self?.creditCard.scheme?.image)
            }) { [weak self] newValue in
                self?.creditCard.cardNumber = newValue?.digitsOnly
            }
            return cell
        case .expireDate:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
            cell.setup(title: "Expire date", value: [creditCard.expireMonth, creditCard.expireYear].compactMap({ $0}).joined(separator: "/"), placeholder: "11/22", formatMask: .creditCardExpMask, keyboardType: .numberPad, isTabBarEnabled: true) { [weak self] newValue in
                guard let date = newValue?.creditCardExpireDate else {
                    self?.creditCard.expireMonth = nil
                    self?.creditCard.expireYear = nil
                    self?.collectionView.reloadData()
                    return
                }
                self?.creditCard.expireMonth = "\(date.get(.month))"
                self?.creditCard.expireYear = "\(date.get(.year))"
            }
            return cell

        case .cvv:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextFieldCollectionViewCell", for: indexPath) as! TextFieldCollectionViewCell
            cell.setup(title: "CVV", value: creditCard.cvv, placeholder: "123", keyboardType: .numberPad, isSecurityEntry: true, characterLimit: 3, isTabBarEnabled: true) { [weak self] newValue in
                self?.creditCard.cvv = newValue
            }
            return cell

        case .payButton:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
            cell.setup(title: "Pay") { [weak self] in
                collectionView.endEditing(true)
                self?.validate()
            }
            return cell

        }
    }
}
