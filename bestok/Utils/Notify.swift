//
//  Notify.swift
//  bestok
//
//  Created by Firas Rafislam on 13/01/2024.
//

import Foundation
import Combine

protocol Notify {
    associatedtype Payload
    static var name: Notification.Name { get }
    var payload: Payload { get }
}


struct Notifications<T: Notify> {
    let notify: T
    
    init(_ notify: T) {
        self.notify = notify
    }
}

struct NotifyHandler<T> { }

func notify<T: Notify>(_ notify: Notifications<T>) {
    let notify = notify.notify
    NotificationCenter.default.post(name: T.name, object: notify.payload)
}

func handle_notify<T: Notify>(_ handler: NotifyHandler<T>) -> AnyPublisher<T.Payload, Never> {
    return NotificationCenter.default.publisher(for: T.name)
        .map { notification in notification.object as! T.Payload }
        .eraseToAnyPublisher()
}
