//
//  Semester.swift
//  TUMCampusApp
//
//  Created by florian schweizer on 23.08.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import Foundation

struct Semester: Identifiable {
    var id: String { title }
    
    let title: String
    let lectures: [Lecture]
}
