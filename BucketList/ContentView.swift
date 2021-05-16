//
//  ContentView.swift
//  BucketList
//
//  Created by Esben Viskum on 13/05/2021.
//

import SwiftUI
import MapKit

struct User: Identifiable, Comparable {
    let id = UUID()
    let firstName: String
    let lastName: String
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}


struct MainView: View {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    @Binding var showingEditScreen: Bool
    
//    @State private var centerCoordinate = CLLocationCoordinate2D()
//    @State private var locations = [CodableMKPointAnnotation]()
//    @State private var selectedPlace: MKPointAnnotation?
//    @State private var showingPlaceDetails = false
//    @State private var showingEditScreen = false
//    @State private var isUnlocked = false

    var body: some View {
        MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
            .edgesIgnoringSafeArea(.all)
        
        Circle()
            .fill(Color.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    // create new location
                    let newLocation = CodableMKPointAnnotation()
                    newLocation.coordinate = self.centerCoordinate
                    newLocation.title = "Example location"
                    self.locations.append(newLocation)
                    self.selectedPlace = newLocation
                    self.showingEditScreen = true
                }) {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    @State private var isUnlocked = false
    @State private var showingBioAuthAlert = false
    
    var body: some View {
        ZStack {
            if isUnlocked {
                
                MainView(centerCoordinate: $centerCoordinate, locations: $locations, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, showingEditScreen: $showingEditScreen)
                    .alert(isPresented: $showingPlaceDetails) {
                        Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information"), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                            self.showingEditScreen = true
                        })
                    }

                
                /*
                MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                    .edgesIgnoringSafeArea(.all)
                
                Circle()
                    .fill(Color.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // create new location
                            let newLocation = CodableMKPointAnnotation()
                            newLocation.coordinate = self.centerCoordinate
                            newLocation.title = "Example location"
                            self.locations.append(newLocation)
                            self.selectedPlace = newLocation
                            self.showingEditScreen = true
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                } */
            } else {
                Button("Unlock Places") {
                    authenticate(successfulAuthentication: { self.isUnlocked = true }, failedAuthentication: {
                        self.isUnlocked = false
                        showingBioAuthAlert = true
                        
                    })
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .alert(isPresented: $showingBioAuthAlert) {
                    Alert(title: Text("Authentication failed"), message: Text("Try again"), dismissButton: .default(Text("OK")))
                }
            }
        }
//        .alert(isPresented: $showingPlaceDetails) {
//            Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information"), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
//                self.showingEditScreen = true
//            })
//        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditView(placemark: self.selectedPlace!)
            }
        }
        .onAppear(perform: loadData)
    }

/*
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if self.isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: { authenticate(successfulAuthentication: { self.isUnlocked = true }, failedAuthentication: { self.isUnlocked = false }) })
    }
*/
/*
    var body: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
    } */
/*
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister")
    ].sorted()
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    var body: some View {
        Text("Hello world")
            .onTapGesture {
                let str = "Test Message"
                FileManager.default.writeData(file: "message.txt", data: str)
                let input: String = FileManager.default.readData(file: "message.txt")
                print(input)
                
/*                let url = self.getDocumentDirectory().appendingPathComponent("message.txt")
                
                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                } */
            }
    }
    
/*    var body: some View {
        List(users) { user in
            Text("\(user.firstName) \(user.lastName)")
        }
    } */
*/
    
}

extension ContentView {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        locations = FileManager.default.readData(file: "SavedPlaces2")
/*
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
        
        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data")
        } */
    }
    
    func saveData() {
        FileManager.default.writeData(file: "SavedPlaces2", data: self.locations)
        
/*
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
