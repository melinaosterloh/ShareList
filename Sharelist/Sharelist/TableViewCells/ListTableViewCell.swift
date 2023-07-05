//
//  ListTableViewCell.swift
//  Sharelist
//
//  Created by Melina Osterloh on 03.07.23.
//

import UIKit

protocol ListTableViewCellDelegate: AnyObject {
    func deleteButtonTapped(at indexPath: IndexPath)
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: ListTableViewCellDelegate?
    var indexPath: IndexPath?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Ändere das Design des deleteButton
        deleteButton.layer.cornerRadius = deleteButton.bounds.height / 2
        deleteButton.layer.shadowRadius = 2
        deleteButton.layer.shadowOpacity = 0.5
        deleteButton.layer.shadowColor = UIColor.darkGray.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.deleteButtonTapped(at: indexPath)
        }
    }

}
