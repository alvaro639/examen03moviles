import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: TeacherStore
    @State private var searchText = ""
    @State private var showingAdd = false
    @State private var selectedTeacher: Teacher?

    private var filtered: [Teacher] {
        store.teachers.filter { teacher in
            searchText.isEmpty || teacher.fullName.localizedCaseInsensitiveContains(searchText) ||
            teacher.specialty.localizedCaseInsensitiveContains(searchText) ||
            teacher.email.localizedCaseInsensitiveContains(searchText)
        }.sorted { $0.lastName < $1.lastName }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filtered) { teacher in
                    Button { selectedTeacher = teacher } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(teacher.fullName).font(.headline).foregroundColor(.primary)
                            Text(teacher.specialty).font(.subheadline).foregroundColor(.blue)
                            Text(teacher.email).font(.caption).foregroundColor(.secondary)
                        }.padding(.vertical, 4)
                    }
                    .swipeActions {
                        Button(role: .destructive) { store.delete(teacher) } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Teachers")
            .searchable(text: $searchText, prompt: "Search teachers...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showingAdd) { TeacherFormView() }
            .sheet(item: $selectedTeacher) { teacher in TeacherFormView(teacher: teacher) }
        }
        .navigationViewStyle(.stack)
    }
}
