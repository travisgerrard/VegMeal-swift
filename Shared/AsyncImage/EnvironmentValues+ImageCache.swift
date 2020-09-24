//
//  EnvironmentValues+ImageCache.swift
//  VegMeal (iOS)
//
//  Created by Travis Gerrard on 9/2/20.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
