//
//  MoreMenuVerticalScrolling.swift
//
//
//  Created by Mohamed Afifi on 2022-10-08.
//

import Localization
import SwiftUI

struct MoreMenuVerticalScrolling: View {
    enum ScrollDirection: Hashable {
        case horizontal
        case vertical
    }

    @Binding var enabled: Bool

    private var selection: Binding<ScrollDirection> {
        Binding(
            get: { enabled ? .vertical : .horizontal },
            set: { enabled = $0 == .vertical }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(l("menu.scrollDirection"))
                .font(.callout)
                .foregroundColor(.secondaryLabel)
                .padding(.horizontal)

            Picker(l("menu.scrollDirection"), selection: selection) {
                Text(l("menu.horizontalScrolling"))
                    .tag(ScrollDirection.horizontal)
                Text(l("menu.verticalScrolling"))
                    .tag(ScrollDirection.vertical)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}
