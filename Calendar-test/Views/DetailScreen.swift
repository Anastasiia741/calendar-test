//  WorkoutDetailViewModel.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

import SwiftUI

struct DetailScreen: View {
    @ObservedObject var viewModel: DetailViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            Color.accent300.ignoresSafeArea()
            ScrollView {
                Divider()
                if let details = viewModel.details {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(details.workoutActivityType.displayName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(
                                colorScheme == .dark ? .black : .black
                            )

                        Text(details.workoutStartDate.dateTimeRU)
                            .font(.subheadline)
                            .foregroundColor(
                                colorScheme == .dark ? .gray : .gray
                            )

                        HStack {
                            infoBlock(
                                title: "Дистанция",
                                value: details.distance.kmString
                            )
                            Spacer()
                            infoBlock(
                                title: "Длительность",
                                value: details.duration.mmssString
                            )
                        }

                        if let comment = details.comment, !comment.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Комментарий").font(.headline)
                                    .foregroundColor(
                                        colorScheme == .dark ? .black : .black
                                    )
                                Text(comment).foregroundColor(
                                    colorScheme == .dark ? .black : .black
                                )
                            }
                        }
                        Divider()
                        if !viewModel.diagram.isEmpty {
                            LineChartView(
                                title: "Пульс",
                                values: viewModel.diagram.map(\.heartRate)
                            )
                            .padding(.vertical)
                            LineChartView(
                                title: "Скорость",
                                values: viewModel.diagram.map(\.speedKmh)
                            )
                        } else {
                            ProgressView("Загрузка...")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    coordinator.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .regular))
                }
                .buttonStyle(.plain)
            }

            ToolbarItem(placement: .principal) {
                Text("Тренировка")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(colorScheme == .dark ? .black : .black)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func infoBlock(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundColor(
                colorScheme == .dark ? .black : .black
            )
            Text(value).font(.headline).foregroundColor(
                colorScheme == .dark ? .gray : .gray
            )
        }
    }
}
