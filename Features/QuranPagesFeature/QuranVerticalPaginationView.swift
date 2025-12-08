//
//  QuranVerticalPaginationView.swift
//
//
//  Created by Mohamed Afifi on 2024-10-06.
//

import NoorUI
import QuranKit
import SwiftUI

public struct QuranVerticalPaginationView<Content: View>: View {
    // MARK: Lifecycle

    public init(selection: Binding<[Page]>, pages: [Page], content: @escaping (Page) -> Content) {
        _selection = selection
        self.pages = pages
        self.content = content
    }

    // MARK: Public

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(pages) { page in
                        contentView(for: page)
                            .id(page.id)
                            .background(visiblePageObserver(for: page))
                    }
                }
            }
            .coordinateSpace(name: coordinateSpaceName)
            .onPreferenceChange(VisiblePagePreferenceKey.self) { values in
                updateVisiblePage(with: values)
            }
            .onChange(of: selection) { pages in
                guard let page = pages.first, page != visiblePage else { return }
                scroll(to: page, proxy: proxy)
            }
            .onAppear {
                if let page = selection.first {
                    scroll(to: page, proxy: proxy, animated: false)
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .accessibilityIdentifier("pages")
        .themedBackground()
        .themedForeground()
        .populateThemeStyle()
        .appearanceModeColorSchema()
        .ignoresSafeArea()
    }

    // MARK: Private

    private struct VisiblePagePreferenceKey: PreferenceKey {
        static var defaultValue: [Page.ID: CGFloat] = [:]
        static func reduce(value: inout [Page.ID: CGFloat], nextValue: () -> [Page.ID: CGFloat]) {
            value.merge(nextValue()) { $1 }
        }
    }

    private let coordinateSpaceName = "vertical-scroll"

    @Binding private var selection: [Page]
    private let pages: [Page]

    @State private var visiblePage: Page?

    @ViewBuilder
    private func contentView(for page: Page) -> some View {
        content(page)
    }

    private func visiblePageObserver(for page: Page) -> some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: VisiblePagePreferenceKey.self,
                value: [page.id: proxy.frame(in: .named(coordinateSpaceName)).minY]
            )
        }
    }

    private func updateVisiblePage(with values: [Page.ID: CGFloat]) {
        guard let nearest = values.min(by: { abs($0.value) < abs($1.value) }),
              let page = pages.first(where: { $0.id == nearest.key })
        else { return }

        visiblePage = page
        if selection.first != page {
            selection = [page]
        }
    }

    private func scroll(to page: Page, proxy: ScrollViewProxy, animated: Bool = true) {
        let action = {
            proxy.scrollTo(page.id, anchor: .top)
        }
        if animated {
            withAnimation { action() }
        } else {
            action()
        }
    }
}
