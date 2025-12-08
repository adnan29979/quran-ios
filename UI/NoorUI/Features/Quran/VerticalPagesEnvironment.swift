//
//  VerticalPagesEnvironment.swift
//
//
//  Created by GPT-5.1-Codex-Max on 2025-05-16.
//

import SwiftUI

private struct QuranVerticalPagesKey: EnvironmentKey {
    static let defaultValue = false
}

public extension EnvironmentValues {
    var isQuranVerticalPagesContainer: Bool {
        get { self[QuranVerticalPagesKey.self] }
        set { self[QuranVerticalPagesKey.self] = newValue }
    }
}
