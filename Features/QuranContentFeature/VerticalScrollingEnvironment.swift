import SwiftUI

private struct QuranVerticalPagesKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isQuranVerticalPagesContainer: Bool {
        get { self[QuranVerticalPagesKey.self] }
        set { self[QuranVerticalPagesKey.self] = newValue }
    }
}
