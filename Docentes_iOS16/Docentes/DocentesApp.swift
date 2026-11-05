import SwiftUI

@main
struct DocentesApp: App {
    @StateObject private var store = TeacherStore()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(store)
        }
    }
}
