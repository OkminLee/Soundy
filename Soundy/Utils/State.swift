//
//  State.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/26.
//  Copyright © 2020 okmin lee. All rights reserved.
//

final class State<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
