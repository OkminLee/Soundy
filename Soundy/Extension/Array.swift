//
//  Array.swift
//  Soundy
//
//  Created by okmin lee on 2020/08/27.
//  Copyright © 2020 okmin lee. All rights reserved.
//

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}


extension Dictionary {
    var uniques: Dictionary {
        var buffer = Dictionary()
        var added = Set<Key>()
        for elem in self {
            if !added.contains(elem.key) {
                buffer.updateValue(elem.value, forKey: elem.key)
                added.insert(elem.key)
            }
        }
        return buffer
    }
}
