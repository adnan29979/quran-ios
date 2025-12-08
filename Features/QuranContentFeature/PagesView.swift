//
//  PagesView.swift
//
//
//  Created by Mohamed Afifi on 2024-10-06.
//

import QuranKit
import QuranPagesFeature
import QuranTextKit
import SwiftUI
import UIx

struct PagesView: View {
    @StateObject var viewModel: ContentViewModel

    var body: some View {
        Group {
            if viewModel.verticalScrollingEnabled {
                QuranVerticalPaginationView(
                    selection: $viewModel.visiblePages,
                    pages: viewModel.deps.quran.pages
                ) { page in
                    contentView(for: page)
                }
            } else {
                GeometryReader { geometry in
                    QuranPaginationView(
                        pagingStrategy: pagingStrategy(with: geometry),
                        selection: $viewModel.visiblePages,
                        pages: viewModel.deps.quran.pages
                    ) { page in
                        contentView(for: page)
                    }
                    .id(viewModel.quranMode)
                }
            }
        }
        .environment(\.isQuranVerticalPagesContainer, viewModel.verticalScrollingEnabled)
        .id("\(viewModel.quranMode)-\(viewModel.verticalScrollingEnabled)")
        .collectGeometryActions($viewModel.geometryActions)
    }

    @ViewBuilder
    private func contentView(for page: Page) -> some View {
        Group {
            switch viewModel.quranMode {
            case .arabic:
                viewModel.deps.imageDataSourceBuilder.build(at: page)
            case .translation:
                viewModel.deps.translationDataSourceBuilder.build(at: page)
            }
        }
    }

    private func pagingStrategy(with geometry: GeometryProxy) -> PagingStrategy {
        // If portrait
        if geometry.size.height > geometry.size.width {
            return .singlePage
        }

        if !TwoPagesUtils.hasEnoughHorizontalSpace() {
            return .singlePage
        }

        return viewModel.pagingStrategy
    }
}
