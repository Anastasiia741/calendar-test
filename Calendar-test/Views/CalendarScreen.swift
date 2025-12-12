//  ContentView.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

import SwiftUI

struct CalendarScreen: View {
    @ObservedObject var viewModel: CalendarViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.colorScheme) private var colorScheme

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 4),
        count: 7
    )
    private let calendar = Calendar.current

    var body: some View {
        ZStack {
            Color.accent300.ignoresSafeArea()

            VStack(spacing: 14) {
                Divider()
                header
                let days = calendar.monthDays(for: viewModel.currentMonth)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(days.indices, id: \.self) { i in
                        if let date = days[i] {
                            dayCell(for: date)
                        } else {
                            Color.clear.frame(height: 32)
                        }
                    }
                }
                workoutsList
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            if viewModel.isLoading {
                ProgressView().progressViewStyle(.circular)
                    .foregroundColor(colorScheme == .dark ? .gray : .gray)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Мои тренировки")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(colorScheme == .dark ? .black : .black)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        HStack {
            Button {
                viewModel.goToPreviousMonth()
            } label: {
                Image("left").resizable().frame(width: 24, height: 24)
            }
            Spacer()
            Text(viewModel.currentMonth.monthTitleRU)
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? .black : .black)
            Spacer()
            Button {
                viewModel.goToNextMonth()
            } label: {
                Image("right").resizable().frame(width: 24, height: 24)
            }
        }
    }

    private func dayCell(for date: Date) -> some View {
        let isSelected =
            viewModel.selectedDate.map {
                calendar.isDate($0, inSameDayAs: date)
            } ?? false
        let isToday = calendar.isDateInToday(date)
        let hasWorkouts =
            !(viewModel.workoutsByDay[DateOnly(date: date, calendar: calendar)]
            ?? []).isEmpty

        return Button {
            viewModel.select(date: date)
        } label: {
            ZStack {
                if isSelected {
                    Circle().fill(.primary100).frame(width: 32, height: 32)
                } else if isToday {
                    Circle().stroke(.primary100, lineWidth: 1).frame(
                        width: 32,
                        height: 32
                    )
                }

                Text(calendar.dayNumberString(date))
                    .font(.subheadline)
                    .foregroundColor(
                        isSelected
                            ? .white : colorScheme == .dark ? .black : .black
                    )
                    .frame(width: 32, height: 32)
                    .contentShape(Circle())
            }
            .frame(width: 32, height: 40)
            .overlay(alignment: .bottom) {
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundColor(
                        hasWorkouts
                            ? dotColor(for: date, isSelected: isSelected)
                            : .clear
                    )
                    .offset(y: 4)
            }
        }
        .buttonStyle(.plain)
    }

    private var workoutsList: some View {
        let items = viewModel.workoutsForSelectedDay()

        return Group {
            if items.isEmpty {
                Text("Тренировок нет")
                    .foregroundColor(colorScheme == .dark ? .gray : .gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)
            } else {
                List(items) { workout in
                    Button {
                        coordinator.showWorkoutDetails(id: workout.workoutKey)
                    } label: {
                        HStack {
                            activityIcon(for: workout.workoutActivityType)
                                .padding(.trailing, 8)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(workout.workoutActivityType.displayName)
                                    .foregroundColor(
                                        colorScheme == .dark ? .black : .black
                                    )

                                Text(workout.workoutStartDate.timeHHmm)
                                    .foregroundColor(
                                        colorScheme == .dark
                                            ? .gray : .secondary
                                    )
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.accent200)
                }
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .background(Color.accent300)
            }
        }
    }

    private func activityIcon(for type: WorkoutActivityType) -> some View {
        let name: String
        switch type {
        case .walkingRunning: name = "figure.run"
        case .yoga: name = "figure.cooldown"
        case .water: name = "drop"
        case .cycling: name = "bicycle"
        case .strength: name = "dumbbell"
        }
        return Image(systemName: name).frame(width: 24, height: 24)
    }

    private func dotColor(for date: Date, isSelected: Bool) -> Color {
        let workouts =
            viewModel.workoutsByDay[DateOnly(date: date, calendar: calendar)]
            ?? []
        guard let firstType = workouts.first?.workoutActivityType else {
            return isSelected ? .white : .accentColor
        }

        if isSelected { return .white }

        switch firstType {
        case .walkingRunning: return .green
        case .yoga: return .purple
        case .water: return .blue
        case .cycling: return .orange
        case .strength: return .red
        }
    }
}
