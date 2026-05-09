import SwiftUI

struct HabitPickerView: View {
    let onComplete: () -> Void

    @State private var selectedTemplates: Set<String> = []
    @State private var customHabitName = ""
    @State private var showCustomInput = false

    private let templates: [(name: String, icon: String, color: String)] = [
        ("Morning Run", "figure.run", "007AFF"),
        ("Read", "book.fill", "34C759"),
        ("Drink Water", "drop.fill", "5AC8FA"),
        ("Meditate", "brain.head.profile.fill", "AF52DE"),
        ("Sleep Early", "bed.double.fill", "FF6B9D"),
        ("Exercise", "dumbbell.fill", "FF9500")
    ]

    private var canContinue: Bool {
        !selectedTemplates.isEmpty || !customHabitName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Pick your habits")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            Text("Choose 1-5 to start (you can add more later)")
                .font(.system(.subheadline))
                .foregroundStyle(Color.textSecondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(templates, id: \.name) { template in
                    TemplateButton(
                        name: template.name,
                        icon: template.icon,
                        color: template.color,
                        isSelected: selectedTemplates.contains(template.name)
                    ) {
                        if selectedTemplates.contains(template.name) {
                            selectedTemplates.remove(template.name)
                        } else if selectedTemplates.count < 5 {
                            selectedTemplates.insert(template.name)
                        }
                    }
                }
            }

            Button {
                showCustomInput.toggle()
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Custom Habit")
                }
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Color.primaryBlue)
            }

            if showCustomInput {
                TextField("Custom habit name", text: $customHabitName)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(Color.textPrimary)
            }

            Spacer()

            Button("Start Popping!") {
                createSelectedHabits()
                onComplete()
            }
            .font(.system(.headline, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(canContinue ? Color.primaryBlue : Color.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
            .disabled(!canContinue)
            .padding(.horizontal)
        }
        .padding()
        .background(Color.black)
    }

    private func createSelectedHabits() {
        for template in templates where selectedTemplates.contains(template.name) {
            _ = try? DataController.shared.createHabit(
                name: template.name,
                icon: template.icon,
                colorHex: template.color
            )
        }
        let customName = customHabitName.trimmingCharacters(in: .whitespaces)
        if !customName.isEmpty {
            _ = try? DataController.shared.createHabit(
                name: customName,
                icon: "circle.fill",
                colorHex: "007AFF"
            )
        }
    }
}

struct TemplateButton: View {
    let name: String
    let icon: String
    let color: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(Color(hex: color))
                Text(name)
                    .font(.system(.subheadline, weight: .medium))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color(hex: color).opacity(0.2) : Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: color), lineWidth: 2)
                }
            }
        }
    }
}
