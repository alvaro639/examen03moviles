import SwiftUI

struct TeacherFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: TeacherStore
    var teacher: Teacher? = nil

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var dateOfBirth = Date()
    @State private var specialty = ""
    @State private var hireDate = Date()
    @State private var isActive = true
    @State private var showDeleteAlert = false

    private var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !specialty.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section("PERSONAL INFORMATION") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Phone", text: $phone).keyboardType(.phonePad)
                    DatePicker("Date of Birth", selection: $dateOfBirth, in: ...Date(), displayedComponents: .date)
                }
                Section("PROFESSIONAL INFORMATION") {
                    TextField("Specialty", text: $specialty)
                    DatePicker("Hire Date", selection: $hireDate, displayedComponents: .date)
                    Toggle("Active", isOn: $isActive)
                }
                if teacher != nil {
                    Section {
                        Button("Delete Teacher", role: .destructive) { showDeleteAlert = true }
                    }
                }
            }
            .navigationTitle(teacher == nil ? "Add Teacher" : "Edit Teacher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveTeacher() }.disabled(!isValid)
                }
            }
            .onAppear(perform: loadTeacher)
            .alert("Delete Teacher?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let teacher = teacher { store.delete(teacher) }
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: { Text("This action cannot be undone.") }
        }
        .navigationViewStyle(.stack)
    }

    private func loadTeacher() {
        guard let teacher = teacher else { return }
        firstName = teacher.firstName
        lastName = teacher.lastName
        email = teacher.email
        phone = teacher.phone
        dateOfBirth = teacher.dateOfBirth
        specialty = teacher.specialty
        hireDate = teacher.hireDate
        isActive = teacher.isActive
    }

    private func saveTeacher() {
        let item = Teacher(
            id: teacher?.id ?? UUID(), firstName: firstName, lastName: lastName,
            email: email, phone: phone, dateOfBirth: dateOfBirth,
            specialty: specialty, hireDate: hireDate, isActive: isActive
        )
        store.upsert(item)
        dismiss()
    }
}
