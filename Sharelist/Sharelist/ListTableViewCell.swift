//
//  ListTableViewCell.swift
//  Sharelist
//
//  Created by Melina Osterloh on 03.07.23.
//

import UIKit

//protocol ListTableViewCellDelegate: AnyObject {
//    func deleteButtonTapped(at indexPath: IndexPath)
//}

class ListTableViewCell: UITableViewCell {

    //weak var delegate: ListTableViewCellDelegate?
    var indexPath: IndexPath?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
