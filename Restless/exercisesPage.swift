//
//  exercisesPage.swift
//  Restless
//
//  Created by Brian Wang-chen on 11/21/25.
//

import SwiftUI
import WebKit

// default templated exercises, 1 per
let Excolumns = [
    GridItem(.flexible())
]

// add cache to store previously generated results
// prevent api firing since free plan is limited :(
private var cache: [String: [Exercise]] = [:]

let default_equipment: Array<String> = ["cable", "assisted", "barbell", "dumbbell", "ez barbell", "olympic barbell",
                         "weighted", "smith machine", "body weight", "leverage machine"]
let default_bodyParts: Array<String> = ["shoulders", "cardio", "chest", "back", "abs", "forearms", "biceps", "triceps", "hamstrings", "quads", "calves", "glutes"]
// struct for gifs, only loaded when user clicks into a exerciseBlock
struct GIFWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update needed for this simple case
    }
}

// curate the exercise data return data to avoid pulling hundreds of useless exercises that no one does
func exerciseFiltered_call(selected_term: String, selected_equipment: String, searchedTerm: String) async throws-> [Exercise]{
    // default equipment to avoid fetching exercises that are non-curated among gym community
    switch selected_term {
    case "shoulders", "cardio", "chest", "back" : // body-part
        return try await service_advanced_getExercises(searchTerm: searchedTerm.isEmpty ? "" : searchedTerm, muscleGroup: "", bodyGroup: selected_term, equipment: selected_equipment.isEmpty ? default_equipment : [selected_equipment])
    case "abs", "forearms", "biceps", "triceps", "hamstrings", "quads", "calves", "glutes": // muscle-group
        return try await service_advanced_getExercises(searchTerm: searchedTerm.isEmpty ? "" : searchedTerm, muscleGroup: selected_term, bodyGroup: "", equipment: selected_equipment.isEmpty ? default_equipment : [selected_equipment])
    default: // no selected body part, in this case it just a user search
        return try await service_advanced_getExercises(searchTerm: searchedTerm.isEmpty ? "" : searchedTerm , muscleGroup: "", bodyGroup: "", equipment: selected_equipment.isEmpty ? default_equipment : [selected_equipment])
    }
}

//allows ExerciseView to call and access
@MainActor
class MuscleGroupViewModel: ObservableObject {
    @Published var muscleGroups: [Muscle] = []
    @Published var exercises: [Exercise] = []
    @Published var searchText: String = "" // for search bar
    private var currentTask: Task<Void, Never>? // API task
    
    @MainActor
    func loadMuscles() async {
        do {
            muscleGroups = try await service_allMuscles()
        } catch {
            print("Failed to load muscles: \(error.localizedDescription)")
        }
    }
    @MainActor // This ensures everything inside updates the UI safely
    func loadExercises(muscle: String, equipment: String, term: String) async {
        currentTask?.cancel() // cancel current task to prevent rate limit
        self.exercises = []
        currentTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            if Task.isCancelled {
                return
            }
            do {
                self.exercises = try await exerciseFiltered_call(selected_term: muscle, selected_equipment: equipment, searchedTerm: term)
            } catch {
                print("Failed to fethc exercises")
            }
        }
    }
}

// view for each individual workout
struct ExerciseBlock: View {
    let name: String
    let image: URL
    let targetMuscles: Array<String>
    let secondaryMuscles: Array<String>
    let instructions: Array<String>
    @State private var showingAlert = false // keep track of popups
    
    var body: some View {
        HStack {
            // templated name
            VStack(alignment: .leading) {
                Text(name)
                    .font(.Title2)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.blue.gradient)
                    .fontWeight(.bold)
                // display primary and secondary muscles that are being used
                Text("Primary Muscles:")
                    .font(.Default)
                    .fontWeight(.bold)
                ForEach(targetMuscles, id: \.self) { group in
                    Text(group).tag(group as String?).font(.Default)
                }
                Text("Secondary Muscles:")
                    .font(.Default)
                    .fontWeight(.bold)
                ForEach(secondaryMuscles, id: \.self) { group in
                    Text(group).tag(group as String?).font(.Default)
                }
            }
            Spacer()
            // static image
            AsyncImage(url: image) {image in
                image.image?.resizable().scaledToFit()
            }.frame(width: 100, height:100)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        // add opacity to each template square so distinguishable from background
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(1))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2))
        
        // functionality when user clicks on a exercise
        .onTapGesture {
            showingAlert = true
        }
        // popup showing the exercise, along with instructions
        .sheet(isPresented: $showingAlert) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title)
                    .padding()
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) { // iterate each instruction
                        ForEach(instructions, id: \.self) { instruction in
                            Text(instruction)
                        }
                        // gif for the exercise
                        GIFWebView(url: image)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .padding()
                }
                Button("Close") {
                    showingAlert = false
                }
                .padding()
            }
        }
    }
}
struct ExercisePage: View {
    @StateObject private var viewModel = MuscleGroupViewModel()
    @State private var selectedMuscle: String?
    @State private var selectedEquipment: String?
    @State private var searchedTerm: String?

    var body: some View {
        VStack {
            // Header
            ZStack {
                backgroundGradient.ignoresSafeArea()
                Image("AppLogo")
            }
            .frame(maxHeight: Spacing.l)
            
            NavigationStack {
                Form{
                    Section("Body Part & Equipment") {
                        // selector for muscles
                        Picker("Select body part", selection: $selectedMuscle) {
                            // Tag must match the selection type (String?)
                            ForEach(default_bodyParts, id: \.self) { part in
                                Text(part).tag(part as String?)
                            }
                        }
                        .controlSize(.small)
                        .pickerStyle(.menu)
                        
                        // selector for body group
                        Picker("Select equipment", selection: $selectedEquipment) {
                            // Tag must match the selection type (String?)
                            ForEach(default_equipment, id: \.self) { equipment in
                                Text(equipment).tag(equipment as String?)
                            }
                        }
                        .controlSize(.small)
                        .pickerStyle(.menu)
                    }
                } .listSectionSpacing(.compact)
            }
            .frame(maxHeight: Spacing.xl * 2.5)
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic)
            ) .controlSize(.small)
            // trigger exercise pull when user submits a search
                .onSubmit(of: .search) {
                    refreshExercises()
                }
            
            ScrollView {
                // Title of the current sections
                // only appears when no exercises are found
                if (viewModel.exercises.isEmpty) {
                    Text("No found exercises")
                        .font(.Default)
                        .fontWeight(.bold)
                }
                LazyVGrid(columns: Excolumns) {
                    // Use the exercises from your ViewModel
                    ForEach(viewModel.exercises, id: \.exerciseId) { exercise in
                        ExerciseBlock(
                            name: exercise.name,
                            image: exercise.gifUrl,
                            targetMuscles: exercise.targetMuscles,
                            secondaryMuscles: exercise.secondaryMuscles,
                            instructions: exercise.instructions
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            // Trigger API call when selection changes
            .onChange(of: selectedMuscle) { _, _ in
                refreshExercises()
            }
            .onChange(of: selectedEquipment) { _, _ in
                if selectedMuscle == nil {} // if no selected muscle group do nothing
                else {
                    refreshExercises()
                }
            }
        }
    }
    // equipment and body part filter included in search
    func refreshExercises() {
        let muscle = selectedMuscle
        let equipment = selectedEquipment
        let searchedTerm = viewModel.searchText
        Task {
            await viewModel.loadExercises(muscle: muscle ?? "", equipment: equipment ?? "", term: searchedTerm)
        }
    }
}

#Preview {
    ExercisePage()
}
