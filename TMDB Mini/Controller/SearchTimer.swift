//
//  SearchTimer.swift
//  TMDB Mini
//
//  Created by macbook on 31.01.2023.
//

import Foundation

class WorkItem {
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    func perform(after: TimeInterval, _ block: @escaping () -> Void) {
        pendingRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem(block: block)
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: requestWorkItem)
    }
}
