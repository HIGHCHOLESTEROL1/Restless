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

// static view of the gif, prevent lag

//allows ExerciseView to call and access
@MainActor
class MuscleGroupViewModel: ObservableObject {
    @Published var muscleGroups: [Muscle] = []
    @Published var exercises: [Exercise] = []
    @Published var searchText: String = "" // for search bar
    
    @MainActor
    func loadMuscles() async {
        do {
            muscleGroups = try await service_allMuscles()
            let placeholder = Muscle(name: "None") // placeholder for when no muscle is selected
            muscleGroups.append(placeholder)
        } catch {
            print("Failed to load muscles: \(error.localizedDescription)")
        }
    }
    @MainActor // This ensures everything inside updates the UI safely
    func loadExercises(muscle: String) async {
        self.exercises = []
        do {
            let fetchedExercises = try await service_getExercises_muscle(muscleGroup: muscle)
            self.exercises = fetchedExercises
            
        } catch {
            print("Failed to load Exercises: \(error.localizedDescription)")
        }
    }
}

// view for each individual workout
struct ExerciseBlock: View {
    let name: String
    let image: URL
    let targetMuscles: Array<String>
    
    var body: some View {
        HStack {
            // templated name
            VStack(alignment: .leading) {
                Text(name)
                    .font(.Default)
                    .fontWeight(.bold)
                ForEach(targetMuscles, id: \.self) { group in
                    Text(group).tag(group as String?).font(.Default)
                }
            }
            Spacer()
            // static image
            AsyncImage(url: image) {image in
                image.image?.resizable().scaledToFit()
            }.frame(width: 100, height:100)
            // gif for the exercise
            // GIFWebView(url: image).frame(width: 100, height: 100)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        // add opacity to each template square so distinguishable from background
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(1))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2))
    }
}

struct ExercisePage: View {
    @StateObject private var viewModel = MuscleGroupViewModel()
    @State private var selectedMuscle: String?

    var body: some View {
        VStack {
            // Header
            ZStack {
                backgroundGradient.ignoresSafeArea()
                Image("AppLogo")
            }
            .frame(maxHeight: Spacing.l)
            
            NavigationStack {
                VStack {
                    Text("Select a muscle group").font(.Default)
                    // selector for muscles
                    if !viewModel.muscleGroups.isEmpty {
                        Picker(selection: $selectedMuscle, label: Text(selectedMuscle ?? "Select Muscle Group")) {
                            // Tag must match the selection type (String?)
                            ForEach(viewModel.muscleGroups, id: \.name) { muscle in
                                Text(muscle.name).tag(muscle.name as String?)
                            }
                        }
                        .pickerStyle(.menu)
                    } else {
                        ProgressView("Loading Muscles...")
                    }
                    Spacer()
                }
                .task {
                    await viewModel.loadMuscles() // load in all muscles
                }
            }
            .frame(maxHeight: Spacing.xl * 2)
            .searchable(text: $viewModel.searchText)
            
            ScrollView {
                // Title of the current section
                Text(selectedMuscle ?? "No Muscle Group Selected")
                    .font(.Default)
                    .fontWeight(.bold)
                
                LazyVGrid(columns: Excolumns) {
                    // Use the exercises from your ViewModel
                    ForEach(viewModel.exercises, id: \.exerciseId) { exercise in
                        ExerciseBlock(
                            name: exercise.name,
                            image: exercise.gifUrl,
                            targetMuscles: exercise.targetMuscles
                        )
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            // Trigger API call when selection changes
            .onChange(of: selectedMuscle) { oldValue, newValue in
                // newValue is the muscle the user just tapped
                if let muscle = newValue {
                    Task {
                        await viewModel.loadExercises(muscle: muscle)
                    }
                }
            }
        }
    }
}

#Preview {
    ExercisePage()
}
