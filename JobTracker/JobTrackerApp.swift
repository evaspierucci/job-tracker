//
//  JobTrackerApp.swift
//  JobTracker
//
//  Created by Eva Pierucci on 18/02/2025.
//

import SwiftUI

@main
struct JobTrackerApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
