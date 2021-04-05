//
//  AppGroup.swift
//  VegMeal
//
//  Created by Travis Gerrard on 2/3/21.
//

import Foundation

public enum AppGroup: String {
  case veggily = "group.gerrardApps.VegMeal.veggilyData"

  public var containerURL: URL {
    switch self {
    case .veggily:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
