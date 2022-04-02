//
//  ViewController.swift
//  TagCloud
//
//  Created by Никита Комаров on 01.04.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tagCells: [TagCollectionViewCell]   = []
    var textView                            = UITextView()
    let manager                             = RequestManager()
    var tags: [String]                      = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        manager.getDrinks() {
            for x in 0...self.manager.requested!.drinks.count - 1 {
             self.tags.append((self.manager.requested?.drinks[x].strDrink)!)
            }
            self.configCollectionView()
            self.configCells()
            self.configTV()
            self.makeInitConstraints()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.addShadow()
    }
    
// MARK: - Конфигурация TextView
    func configTV() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(wordsTapped))
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboarddWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboarddWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        self.view.addGestureRecognizer(tapOutside)
        self.textView.addGestureRecognizer(tapRecognizer)
        self.textView.textAlignment         = .center
        self.textView.clipsToBounds         = true
        self.textView.layer.masksToBounds   = true
        self.textView.layer.cornerRadius    = 5
        self.textView.backgroundColor       = .white
        self.textView.text                  = "Cocktail name"
        self.textView.textColor             = .gray
        self.textView.font                  = .boldSystemFont(ofSize: 15)
        view.addSubview(textView)
    }
    
// MARK: - Тени
    func addShadow() {
        textView.layer.masksToBounds        = false
        textView.layer.shadowColor          = UIColor.gray.cgColor
        textView.layer.shadowOpacity        = 0.4
        textView.layer.shadowOffset         = CGSize(width: 3, height: 3)
        textView.layer.shadowRadius         = 9
        textView.layer.shadowPath           = UIBezierPath(rect: textView.bounds).cgPath
        textView.layer.shouldRasterize      = true
        textView.layer.rasterizationScale   = true ? UIScreen.main.scale : 1
    }
    
// MARK: - Конфигурация констрейнтов
    func makeInitConstraints() {
        textView.snp.makeConstraints { (make) in
            make.width.equalTo      (200)
            make.height.equalTo     (35)
            make.centerX.equalTo    (view)
            make.centerY.equalTo    (view).multipliedBy(1.3)
        }
    }
    
// MARK: - Обработка действий с TextField
    @objc func wordsTapped() {
        textView.becomeFirstResponder()
        textView.layer.cornerRadius = 0.0
        textView.text               = ""
    }
    
    @objc func tappedOutside() {
        textView.resignFirstResponder()
        textView.layer.cornerRadius = 5.0
        addShadow()
        if textView.text == "" {
            textView.text = "Cocktail name"
        }
    }
    
    @objc func keyboarddWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textView.snp.remakeConstraints { (make) in
                make.width.equalTo  (view)
                make.height.equalTo (35)
                make.centerX.equalTo(view)
                make.centerY.equalTo(keyboardSize.minY - 15)
            }
        }
    }
    
    @objc func keyboarddWillHide(notification: NSNotification) {
        textView.snp.remakeConstraints { (make) in
            make.width.equalTo      (200)
            make.height.equalTo     (35)
            make.centerX.equalTo    (view)
            make.centerY.equalTo    (view).multipliedBy(1.3)
        }
    }
    
// MARK: - Реализация поиска
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text ?? "")
        
        for x in 0...(tagCells.count - 1)
        {
            tagCells[x].gradient.removeFromSuperlayer()
        }
        
        for i in 0...(tagCells.count - 1) {
            if tagCells[i].titleLabel.text!.contains(textView.text) {
                tagCells[i].tagPressed((Any).self)
            }
        }
    }

// MARK: - Конфигурация CollectionView
    func configCollectionView() {
            self.collectionView.delegate    = self
            self.collectionView.dataSource  = self
            self.collectionView.register(UINib(nibName: "TagCollectionViewCell",
                                               bundle: nil),
                                         forCellWithReuseIdentifier: "default")
        
            self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(),
                                                        animated: true)
        
            collectionView.snp.makeConstraints { make in
                make.height.equalToSuperview().dividedBy(2)
            }
        }
    
    func configCells() {
        self.tagCells = tags.enumerated().map({ (index, option) -> TagCollectionViewCell in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: IndexPath(item: index, section: 0)) as! TagCollectionViewCell
            cell.config(info: option)
            return cell
        })
        let optimalCells = self.collectionView.getOptimalCells(self.tagCells, maxWidth: UIScreen.main.bounds.width)
        self.tagCells = optimalCells.reduce(into: [TagCollectionViewCell](), { (cells, resultCells) in
            cells.append(resultCells)
        }) as! [TagCollectionViewCell]
        self.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tagCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.tagCells[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = tagCells[indexPath.item]
        return cell.intrinsicContentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, maximumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
