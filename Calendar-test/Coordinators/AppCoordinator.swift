//  AppCoordinator.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

internal import Combine
import SwiftUI

enum AppRoute: Hashable {
    case workoutDetails(workoutId: String)
}

final class AppCoordinator: ObservableObject {

    @Published var path: [AppRoute] = []

    let service: MockServiceProtocol

    init(service: MockServiceProtocol) {
        self.service = service
    }

    func makeRootView() -> some View {
        let vm = CalendarViewModel(service: service)
        return CalendarScreen(viewModel: vm)
            .environmentObject(self)
    }

    func showWorkoutDetails(id: String) {
        path.append(.workoutDetails(workoutId: id))
    }

    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
