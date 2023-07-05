//
//  ArticleTableViewCell.swift
//  Sharelist
//
//  Created by Melina Osterloh on 20.06.23.
//

import UIKit

// Protokoll zur Weiterleitung der Tap Events für infoButton und deleteButton
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
        
        // Ändert das Design des deleteButton
        deleteButton.layer.cornerRadius = deleteButton.bounds.height / 2
        deleteButton.layer.shadowRadius = 2
        deleteButton.layer.shadowOpacity = 0.5
        deleteButton.layer.shadowColor = UIColor.darkGray.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        

        // Ändert das Design des infoButton
        if let button = infoButton {
            // Der Button ist nicht nil, führe den Code aus
            button.layer.cornerRadius = button.bounds.height / 2
            button.layer.shadowRadius = 2
            button.layer.shadowOpacity = 0.5
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 1, height: 1)
        } else {
            // Der Button ist nil
            print("Der infoButton ist nil.")
        }
    }

    // Delegiert das Tap Event
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.infoButtonTapped(at: indexPath)
        }
    }
    
    // Delegiert das Tap Event an die ArticleTableView
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.deleteButtonTapped(at: indexPath)
        }
    }
    
   

}
