//
//  LocalSearchCompetion.swift
//  WeatherKit
//
//  Created by Yuriy Gudimov on 04.02.2023.
//

import Foundation

public struct LocalSearchCompletion: Identifiable, Equatable, Hashable {
    public let id = UUID()
    public let title: String
    public let subTitle: String
    
    public init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
}
