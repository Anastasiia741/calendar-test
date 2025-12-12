//  LineChartView.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

import SwiftUI

struct LineChartView: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    let values: [Double]

    @State private var progress: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? .black : .black)
            GeometryReader { geo in
                let size = geo.size
                let points = map(values, in: size)

                ZStack {
                    grid()

                    Path { path in
                        guard let first = points.first else { return }
                        path.move(to: first)
                        points.dropFirst().forEach { path.addLine(to: $0) }
                    }
                    .trim(from: 0, to: progress)
                    .stroke(.primary100, lineWidth: 3)

                    ForEach(points.indices, id: \.self) { i in
                        if progress >= CGFloat(i)
                            / CGFloat(max(points.count - 1, 1))
                        {
                            Circle()
                                .fill(.primary100)
                                .frame(width: 5)
                                .position(points[i])
                        }
                    }
                }
            }
            .frame(height: 160)
        }
        .onAppear { animate() }
        .onChange(of: values.count) { _, _ in animate() }
    }

    private func animate() {
        progress = 0
        withAnimation(.easeInOut(duration: 1)) {
            progress = 1
        }
    }

    private func map(_ values: [Double], in size: CGSize) -> [CGPoint] {
        guard values.count > 1 else { return [] }

        let minV = values.min()!
        let maxV = values.max()!
        let range = max(maxV - minV, 0.0001)

        return values.indices.map { i in
            CGPoint(
                x: size.width * CGFloat(i) / CGFloat(values.count - 1),
                y: size.height * (1 - CGFloat((values[i] - minV) / range))
            )
        }
    }

    private func grid() -> some View {
        GeometryReader { geo in
            Path { path in
                let h = geo.size.height / 4
                let w = geo.size.width / 5

                for i in 0...4 {
                    path.move(to: .init(x: 0, y: CGFloat(i) * h))
                    path.addLine(
                        to: .init(x: geo.size.width, y: CGFloat(i) * h)
                    )
                }

                for i in 0...5 {
                    path.move(to: .init(x: CGFloat(i) * w, y: 0))
                    path.addLine(
                        to: .init(x: CGFloat(i) * w, y: geo.size.height)
                    )
                }
            }
            .stroke(.gray, style: StrokeStyle(dash: [4]))
        }
    }
}
