import SwiftUI

struct HabitTemplateView: View {
    let onSelect: (String, String, String) -> Void

    private let templates: [(name: String, icon: String, color: String)] = [
        ("Morning Run", "figure.run", "007AFF"),
        ("Read", "book.fill", "34C759"),
        ("Drink Water", "drop.fill", "5AC8FA"),
        ("Meditate", "brain.head.profile.fill", "AF52DE"),
        ("Sleep Early", "bed.double.fill", "FF6B9D"),
        ("Exercise", "dumbbell.fill", "FF9500")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Start Templates")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color.textPrimary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(templates, id: \.name) { template in
                    Button {
                        onSelect(template.name, template.icon, template.color)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: template.icon)
                                .foregroundStyle(Color(hex: template.color))
                            Text(template.name)
                                .font(.system(.subheadline, weight: .medium))
                                .foregroundStyle(Color.textPrimary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }
}
