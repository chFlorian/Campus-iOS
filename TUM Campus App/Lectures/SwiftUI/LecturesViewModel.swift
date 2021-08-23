//
//  LecturesViewModel.swift
//  TUMCampusApp
//
//  Created by florian schweizer on 23.08.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import SwiftUI
import CoreData
import XMLCoder
import Alamofire

final class LecturesViewModel: ObservableObject {
    typealias ImporterType = Importer<Lecture, APIResponse<TUMOnlineAPIResponse<Lecture>,TUMOnlineAPIError>,XMLDecoder>
    
    private static let endpoint = TUMOnlineAPI.personalLectures
    private static let primarySortDescriptor = NSSortDescriptor(keyPath: \Lecture.semesterID, ascending: false)
    private static let secondarySortDescriptor = NSSortDescriptor(keyPath: \Lecture.id, ascending: false)
    private let importer = ImporterType(endpoint: endpoint, sortDescriptor: primarySortDescriptor, secondarySortDescriptor, dateDecodingStrategy: .formatted(.yyyyMMddhhmmss))
    
    private var currentSnapshot = NSDiffableDataSourceSnapshot<String, Lecture>()
    @Published var semesters: [Semester] = []
    
    init() {
        fetch()
    }
    
    private func fetch(animated: Bool = true) {
        importer.performFetch(success: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.reload(animated: animated)
            }
        }, error: { [weak self] error in
            switch error {
                case is TUMOnlineAPIError:
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: Lecture.fetchRequest())
                    _ = try? self?.importer.context.execute(deleteRequest)
                    self?.reload(animated: animated)
                default: break
            }
        })
    }
    
    private func reload(animated: Bool = true) {
        try? importer.fetchedResultsController.performFetch()
        
        currentSnapshot = NSDiffableDataSourceSnapshot<String, Lecture>()
        let sections = importer.fetchedResultsController.sections ?? []
        currentSnapshot.appendSections(sections.map { $0.name })
        
        for section in sections {
            guard let lectures = section.objects as? [Lecture] else { continue }
            let semester = Semester(title: section.name, lectures: lectures)
            semesters.append(semester)
        }
    }
}
