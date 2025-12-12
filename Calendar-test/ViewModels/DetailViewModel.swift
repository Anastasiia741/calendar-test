//  WorkoutDetailViewModel.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

internal import Combine
import Foundation

final class DetailViewModel: ObservableObject {
    @Published var details: WorkoutDetails?
    @Published var diagram: [DiagramPoint] = []

    private let workoutId: String
    private let service: MockServiceProtocol

    init(workoutId: String, service: MockServiceProtocol) {
        self.workoutId = workoutId
        self.service = service
        Task { await load() }
    }

    @MainActor
    private func load() async {
        async let d = service.loadDetails(for: workoutId)
        async let points = service.loadDiagram(for: workoutId)

        self.details = try? await d
        self.diagram = (try? await points) ?? []
    }
}
