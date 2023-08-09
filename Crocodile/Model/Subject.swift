//
//  Subject.swift
//  Crocodile
//
//  Created by Николай Щербаков on 04.08.2023.
//

import Foundation

protocol Subject {
    func registerObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
    func notifyObservers()
}
