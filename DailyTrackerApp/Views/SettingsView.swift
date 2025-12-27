import SwiftUI

struct SettingsView: View {
    @AppStorage("userAge") private var userAge: Int = 37
    @AppStorage("userGender") private var userGender: String = "male"
    @AppStorage("userWeight") private var userWeight: Double = 70.0
    @AppStorage("userHeight") private var userHeight: Double = 170.0
    @AppStorage("userActivityLevel") private var userActivityLevel: String = "moderately_active"
    
    @State private var showingBMRInfo = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case age
        case weight
        case height
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        Text("Age")
                        Spacer()
                        TextField("Age", value: $userAge, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .focused($focusedField, equals: .age)
                    }
                    
                    Picker("Gender", selection: $userGender) {
                        Text("Male").tag("male")
                        Text("Female").tag("female")
                        Text("Other").tag("other")
                    }
                    
                    HStack {
                        Text("Weight (kg)")
                        Spacer()
                        TextField("Weight", value: $userWeight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .focused($focusedField, equals: .weight)
                    }
                    
                    HStack {
                        Text("Height (cm)")
                        Spacer()
                        TextField("Height", value: $userHeight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .focused($focusedField, equals: .height)
                    }
                }
                
                Section(header: Text("Activity Level")) {
                    Picker("Activity Level", selection: $userActivityLevel) {
                        Text("Sedentary").tag("sedentary")
                        Text("Lightly Active").tag("lightly_active")
                        Text("Moderately Active").tag("moderately_active")
                        Text("Very Active").tag("very_active")
                    }
                }
                
                Section(header: Text("Metabolic Information")) {
                    let profile = UserProfile(
                        age: userAge,
                        gender: userGender,
                        weight: userWeight,
                        height: userHeight,
                        activityLevel: userActivityLevel
                    )
                    
                    HStack {
                        Text("BMR")
                        Spacer()
                        Text("\(Int(profile.calculateBMR())) kcal/day")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("TDEE")
                        Spacer()
                        Text("\(Int(profile.calculateTDEE())) kcal/day")
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        showingBMRInfo = true
                    }) {
                        HStack {
                            Text("What is BMR/TDEE?")
                            Spacer()
                            Image(systemName: "info.circle")
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Text("This app helps you track your food intake and workouts using voice recordings. All data is stored locally on your device.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .onTapGesture {
                focusedField = nil
            }
            .alert("BMR & TDEE", isPresented: $showingBMRInfo) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("BMR (Basal Metabolic Rate) is the number of calories your body burns at rest.\n\nTDEE (Total Daily Energy Expenditure) is your total daily calorie burn including all activities.")
            }
        }
    }
}

#Preview {
    SettingsView()
}

