//
//  Data.swift
//  ogawamachi
//
//  Created on 2021/07/23.
//

import Foundation

// json デコード済みの変数
var omiseData: [Omise] = load("csvjson.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        // Data に変換
        data = try Data(contentsOf: file)
        
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        // json をデコード
        decoder.dateDecodingStrategy = .iso8601
        
//        let hoge = try? decoder.decode(Contents.self, from: data)
//        if case let description? = hoge?.description {
//            print(description)
//        }
                
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
