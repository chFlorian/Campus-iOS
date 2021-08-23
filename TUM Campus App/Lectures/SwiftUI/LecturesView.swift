//
//  LecturesView.swift
//  TUMCampusApp
//
//  Created by florian schweizer on 23.08.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import SwiftUI

struct LecturesView: View {
    @ObservedObject private var viewModel = LecturesViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.semesters) { semester in
                Section(header: Text("Semester " + semester.title)) {
                    ForEach(semester.lectures) { lecture in
                        LectureCell(lecture: lecture)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct LectureCell: View {
    let lecture: Lecture
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(lecture.title ?? "")
            
            HStack {
                Image(systemName: "person.circle")
                Text(lecture.speaker ?? "")
                Spacer()
            }
            .font(.footnote)
            .foregroundColor(.gray)
            
            HStack {
                Image(systemName: "book.circle")
                Text(lecture.eventType ?? "")
                Spacer()
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
    }
}
