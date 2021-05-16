//
//  FileManagerExt.swift
//  BucketList
//
//  Created by Esben Viskum on 13/05/2021.
//

import Foundation

extension FileManager {
    private func getURL(_ file: String) -> URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(file)
    }
    
    func writeData<T: Codable>(file: String, data: T) -> Void {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(data)
            self.createFile(atPath: getURL(file).path, contents: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func readData<T: Codable>(file: String) -> T {
        let decoder = JSONDecoder()
        
        if let data = self.contents(atPath: getURL(file).path) {
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Error opening file \(file)")
        }
    }
}
