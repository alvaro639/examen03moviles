import Foundation

struct Teacher: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var dateOfBirth: Date
    var specialty: String
    var hireDate: Date
    var isActive: Bool
    var fullName: String { "\(firstName) \(lastName)" }
}

final class TeacherStore: ObservableObject {
    @Published var teachers: [Teacher] = [] {
        didSet { save() }
    }
    private let key = "docentes.ios16.teachers"
    init() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([Teacher].self, from: data) else { return }
        teachers = saved
    }
    private func save() {
        guard let data = try? JSONEncoder().encode(teachers) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    func upsert(_ teacher: Teacher) {
        if let index = teachers.firstIndex(where: { $0.id == teacher.id }) {
            teachers[index] = teacher
        } else { teachers.append(teacher) }
    }
    func delete(_ teacher: Teacher) { teachers.removeAll { $0.id == teacher.id } }
}
