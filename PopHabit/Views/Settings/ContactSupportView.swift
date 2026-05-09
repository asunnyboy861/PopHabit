import SwiftUI

struct ContactSupportView: View {
    @State private var selectedSubject: Subject = .general
    @State private var customSubject = ""
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showSuccess = false
    @State private var errorMessage: String?

    private let backendURL = "https://feedback-board.iocompile67692.workers.dev"

    enum Subject: String, CaseIterable {
        case general = "General"
        case featureSuggestion = "Feature Suggestion"
        case bugReport = "Bug Report"
        case usageQuestion = "Usage Question"
        case performanceIssue = "Performance Issue"
        case uiImprovement = "UI Improvement"
        case other = "Other"

        var icon: String {
            switch self {
            case .general: "message.fill"
            case .featureSuggestion: "lightbulb.fill"
            case .bugReport: "ladybug"
            case .usageQuestion: "questionmark.circle.fill"
            case .performanceIssue: "gauge"
            case .uiImprovement: "paintbrush.fill"
            case .other: "ellipsis.circle.fill"
            }
        }
    }

    private var isFormValid: Bool {
        let subjectValue = selectedSubject == .other ? customSubject.trimmingCharacters(in: .whitespaces) : selectedSubject.rawValue
        return !subjectValue.isEmpty
            && !name.trimmingCharacters(in: .whitespaces).isEmpty
            && !email.trimmingCharacters(in: .whitespaces).isEmpty
            && email.contains("@")
            && !message.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                subjectSection

                if selectedSubject == .other {
                    customSubjectField
                }

                nameField

                emailField

                messageField

                if let errorMessage {
                    Text(errorMessage)
                        .font(.system(.caption))
                        .foregroundStyle(.red)
                }

                submitButton
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Contact Support")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank You!", isPresented: $showSuccess) {
            Button("OK") {}
        } message: {
            Text("Your feedback has been submitted. We'll get back to you soon!")
        }
    }

    private var subjectSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Subject")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(Subject.allCases, id: \.self) { subject in
                    Button {
                        selectedSubject = subject
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: subject.icon)
                                .font(.system(.body))
                            Text(subject.rawValue)
                                .font(.system(.caption, weight: .medium))
                                .lineLimit(1)
                        }
                        .foregroundStyle(selectedSubject == subject ? .white : .textSecondary)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 6)
                        .frame(maxWidth: .infinity)
                        .background(selectedSubject == subject ? Color.primaryBlue : Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }

    private var customSubjectField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Custom Subject")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            TextField("Enter your subject", text: $customSubject)
                .textFieldStyle(.plain)
                .padding()
                .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(Color.textPrimary)
        }
    }

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            TextField("Your name", text: $name)
                .textFieldStyle(.plain)
                .padding()
                .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(Color.textPrimary)
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            TextField("your@email.com", text: $email)
                .textFieldStyle(.plain)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(Color.textPrimary)
        }
    }

    private var messageField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Message")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(Color.textSecondary)

            TextEditor(text: $message)
                .scrollContentBackground(.hidden)
                .padding()
                .frame(minHeight: 120)
                .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(Color.textPrimary)
        }
    }

    private var submitButton: some View {
        Button {
            submitFeedback()
        } label: {
            Group {
                if isSubmitting {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Submit")
                        .font(.system(.headline, design: .rounded))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isFormValid ? Color.primaryBlue : Color.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!isFormValid || isSubmitting)
    }

    private func submitFeedback() {
        isSubmitting = true
        errorMessage = nil

        let subjectValue = selectedSubject == .other
            ? customSubject.trimmingCharacters(in: .whitespaces)
            : selectedSubject.rawValue

        let requestBody: [String: String] = [
            "name": name.trimmingCharacters(in: .whitespaces),
            "email": email.trimmingCharacters(in: .whitespaces),
            "subject": subjectValue,
            "message": message.trimmingCharacters(in: .whitespaces),
            "app_name": "PopHabit"
        ]

        guard let url = URL(string: "\(backendURL)/api/feedback") else {
            errorMessage = "Invalid server URL"
            isSubmitting = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            errorMessage = "Failed to prepare request"
            isSubmitting = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    showSuccess = true
                    name = ""
                    email = ""
                    message = ""
                    customSubject = ""
                    selectedSubject = .general
                } else {
                    errorMessage = "Failed to submit. Please try again."
                }
            }
        }.resume()
    }
}
