import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = HabitEditViewModel()
    @State private var showTemplates = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    nameSection
                    iconSection
                    colorSection
                    frequencySection
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        if viewModel.createHabit() != nil {
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            TextField("e.g., Morning Run", text: $viewModel.name)
                .textFieldStyle(.plain)
                .padding()
                .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(Color.textPrimary)
        }
    }

    private var iconSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Icon")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                ForEach(viewModel.availableIcons, id: \.self) { icon in
                    Image(systemName: icon)
                        .font(.system(.title3))
                        .foregroundStyle(viewModel.icon == icon ? Color.primaryBlue : .textSecondary)
                        .frame(width: 44, height: 44)
                        .background(viewModel.icon == icon ? Color.primaryBlue.opacity(0.2) : Color.clear, in: Circle())
                        .onTapGesture {
                            viewModel.icon = icon
                        }
                }
            }
        }
    }

    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                ForEach(viewModel.availableColors, id: \.self) { hex in
                    Circle()
                        .fill(Color(hex: hex))
                        .frame(width: 36, height: 36)
                        .overlay {
                            if viewModel.colorHex == hex {
                                Image(systemName: "checkmark")
                                    .font(.system(.caption, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .onTapGesture {
                            viewModel.colorHex = hex
                        }
                }
            }
        }
    }

    private var frequencySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Frequency")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            ForEach(Frequency.allCases, id: \.self) { freq in
                HStack {
                    Image(systemName: freq.systemName)
                        .foregroundStyle(viewModel.frequency == freq ? Color.primaryBlue : .textSecondary)
                        .frame(width: 24)

                    Text(freq.displayName)
                        .font(.system(.subheadline))
                        .foregroundStyle(Color.textPrimary)

                    Spacer()

                    if viewModel.frequency == freq {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.primaryBlue)
                    }
                }
                .padding()
                .background(viewModel.frequency == freq ? Color.primaryBlue.opacity(0.1) : Color.clear, in: RoundedRectangle(cornerRadius: 12))
                .onTapGesture {
                    viewModel.frequency = freq
                }
            }
        }
    }
}
