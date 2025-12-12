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

// struct for gifs, part of swiftUI
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

//allows ExerciseView to call and access
@MainActor
class MuscleGroupViewModel: ObservableObject {
    @Published var muscleGroups: [String] = []
    @Published var searchText: String = "" // for search bar
    func loadMuscles() async {
        do {
            muscleGroups = try await service_allMuscles()
            muscleGroups.append("None")
        } catch {
            print("Failed to load muscles: \(error.localizedDescription)")
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
            // gif for the exercise
            GIFWebView(url: image).frame(width: 100, height: 100)
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
    @State private var selectedMuscle: String? // keep track of selected muscle group
    var body: some View {
        VStack {
            ZStack {
                backgroundGradient.ignoresSafeArea()
                Image("AppLogo")
            }
            .frame(maxHeight: Spacing.l)
    
            NavigationStack {
                VStack {
                    Text("Select a muscle group").font(.Default)
                    // dropdown menu for selecting muscle groups
                    if !viewModel.muscleGroups.isEmpty {
                        Picker(selection: $selectedMuscle, label: Text(selectedMuscle ?? "Select Muscle Group")) {
                            ForEach(viewModel.muscleGroups, id: \.self) { group in
                                Text(group).tag(group as String?)
                            }
                        }
                        .pickerStyle(.menu) // default menu style
                    } else {
                        ProgressView("Loading...")
                    }
                    Spacer()
                }
                .navigationTitle("Exercises")
                .task {
                    await viewModel.loadMuscles() // async task
                }
            }
            .frame(maxHeight: Spacing.xl * 2)
            .searchable(text: $viewModel.searchText)
            ScrollView{
                Text("Upper Back")
                    .font(.Default)
                    .fontWeight(.bold)
                LazyVGrid(columns: Excolumns) {
                    // temporary for now just for UI design
                    let gifUrl = [
                        URL(string: "https://static.exercisedb.dev/media/c8oybX6.gif")!,
                        URL(string: "https://static.exercisedb.dev/media/UFGF6gk.gif")!,
                        URL(string: "https://static.exercisedb.dev/media/w2oRpuH.gif")!,
                        URL(string: "https://static.exercisedb.dev/media/ZqNOWQ6.gif")!,
                        URL(string: "https://static.exercisedb.dev/media/dmgMp3n.gif")!]
                        
                    // Temporary just to ensure it visually looks how I want it to
                    ExerciseBlock(name: "cable rope crossover seated row", image: gifUrl[0], targetMuscles: ["upper back"])
                    
                    ExerciseBlock(name: "dumbbell one arm bent-over row", image: gifUrl[1], targetMuscles: ["upper back"])
                    
                    ExerciseBlock(name: "lever reverse grip vertical row", image: gifUrl[2], targetMuscles: ["upper back"])
                    
                    ExerciseBlock(name: "barbell incline row", image: gifUrl[3], targetMuscles: ["upper back"])
                    
                    ExerciseBlock(name: "smith narrow row", image: gifUrl[4], targetMuscles: ["upper back"])
                    
                } .frame(maxWidth: .infinity)
            } .padding()
        }
    }
}

#Preview {
    ExercisePage()
}
