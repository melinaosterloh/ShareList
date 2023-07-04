//
//  ArticleTableViewCell.swift
//  Sharelist
//
//  Created by Melina Osterloh on 20.06.23.
//

import UIKit

protocol ArticleTableViewCellDelegate: AnyObject {
    func infoButtonTapped(at indexPath: IndexPath)
    func deleteButtonTapped(at indexPath: IndexPath)
}

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: ArticleTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ändere das Design des deleteButton
        //deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.layer.cornerRadius = deleteButton.bounds.height / 2
        //deleteButton.layer.borderColor = UIColor.darkGray.cgColor
        //deleteButton.layer.borderWidth = 0.3
        deleteButton.layer.shadowRadius = 2
        deleteButton.layer.shadowOpacity = 0.5
        deleteButton.layer.shadowColor = UIColor.darkGray.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        

        // Ändere das Design des infoButton
        //infoButton.backgroundColor = UIColor.blue
        //infoButton.setTitleColor(UIColor.white, for: .normal)
        infoButton.layer.cornerRadius = infoButton.bounds.height / 2
        //infoButton.layer.borderColor = UIColor.darkGray.cgColor
        //infoButton.layer.borderWidth = 0.3
        infoButton.layer.shadowRadius = 2
        infoButton.layer.shadowOpacity = 0.5
        infoButton.layer.shadowColor = UIColor.darkGray.cgColor
        infoButton.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    @IBAction func infoButtonTapped(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.infoButtonTapped(at: indexPath)
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.deleteButtonTapped(at: indexPath)
        }
    }
    
   

}
