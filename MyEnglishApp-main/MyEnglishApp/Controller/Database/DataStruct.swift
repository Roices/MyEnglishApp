//
//  DataStruct.swift
//  MyEnglishApp
//
//  Created by Tuan on 27/05/2021.
//

import Foundation

struct User:Codable{
    var data:[UserData]
}

struct UserData:Codable{
    let Question:String
    let Choice:[String]
    let CorrectAns:String
    let Pronunciation:String
}
