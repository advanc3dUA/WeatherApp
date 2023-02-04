//
//  TestEnvironment.swift
//  WeatherAppTests
//
//  Created by Yuriy Gudimov on 04.02.2023.
//

import Foundation
@testable import WeatherApp

class TestEnvironment {
    static var worlds: [World] = [
    Current
    ]
    
    static func push() {
        let copy = worlds.last!
        worlds.append(copy)
        Current = copy
    }
    
    static func pop() {
        precondition(worlds.count > 1, "Can't remove last world")
        worlds.removeLast()
        Current = worlds.last!
    }
}
