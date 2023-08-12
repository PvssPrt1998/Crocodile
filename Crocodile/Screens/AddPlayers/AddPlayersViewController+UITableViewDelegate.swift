//
//  AddPlayersViewController+UITableViewDelegate.swift
//  Crocodile
//
//  Created by Николай Щербаков on 10.08.2023.
//

import UIKit

//MARK: - UITableViewDelegate
extension AddPlayersViewController: UITableViewDelegate {
    //Событие после нажатия на строку
    public func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        tableView.deselectRow(at: didSelectRowAt, animated: false)
    }
}
