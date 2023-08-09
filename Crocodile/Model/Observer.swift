//
//  Observer.swift
//  Crocodile
//
//  Created by Николай Щербаков on 04.08.2023.
//

import Foundation

protocol Observer: AnyObject {
    func update(isGameInProgress: Bool)
}
