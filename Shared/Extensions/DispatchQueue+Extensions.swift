//
//  DispatchQueue+Extensions.swift
//  VegMeal
//
//  Created by Travis Gerrard on 2/6/21.
//

import Foundation

typealias Dispatch = DispatchQueue

extension Dispatch {

    static func background(_ task: @escaping () -> ()) {
        Dispatch.global(qos: .background).async {
            task()
        }
    }

    static func main(_ task: @escaping () -> ()) {
        Dispatch.main.async {
            task()
        }
    }
}
