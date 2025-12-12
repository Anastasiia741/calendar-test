//  Calendar_testApp.swift
//  Calendar-test
//  Created by Анастасия Набатова on 11/12/25.

import SwiftUI

@main
struct Calendar_testApp: App {
    @StateObject private var coordinator = AppCoordinator(service: MockAPIService())

       var body: some Scene {
           WindowGroup {
               NavigationStack(path: $coordinator.path) {
                   coordinator.makeRootView()
                       .navigationDestination(for: AppRoute.self) { route in
                           switch route {
                           case .workoutDetails(let id):
                               let vm = DetailViewModel(
                                   workoutId: id,
                                   service: coordinator.service
                               )
                               DetailScreen(viewModel: vm)
                           }
                       }
               }
               .environmentObject(coordinator)
           }
       }
   }


