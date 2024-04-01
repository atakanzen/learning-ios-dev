//
//  ScrumTimer.swift
//  Scrumdinger
//
//  Created by Atakan Zengin on 01/04/2024.
//

import Foundation

@MainActor
final class ScrumTimer: ObservableObject {
    struct Speaker: Identifiable {
        let name: String
        var isCompleted: Bool
        let id = UUID()
    }
    
    @Published var activeSpeaker = ""
    @Published var secondsElapsed = 0
    @Published var secondsRemaining = 0
    
    private(set) var speakers: [Speaker] = []
    private(set) var lenghtInMinutes: Int
    var speakerChangedAction: (() -> Void)?
    private weak var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var lengthInSeconds: Int {lenghtInMinutes * 60}
    private var secondsPerSpeaker: Int {
        lengthInSeconds / speakers.count
    }
    private var secondsElapsedForSpeaker: Int = 0
    private var speakerIndex: Int = 0
    private var speakerText: String {
        return "Speaker \(speakerIndex + 1): " + speakers[speakerIndex].name
    }
    private var startDate: Date?
    
    init(lengthInMinutes: Int = 0, attendess: [DailyScrum.Attendee] = []) {
        self.lenghtInMinutes = lengthInMinutes
        self.speakers = attendess.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
    
    func startScrum() {
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            self?.update()
        }
        timer?.tolerance = 0.1
        changeToSpeaker(at: 0)
    }
    
    func stopScrum() {
        timer?.invalidate()
        changeToSpeaker(at: 0)
    }
    
    nonisolated func skipSpeaker() {
        Task {@MainActor in
            changeToSpeaker(at: speakerIndex + 1)
        }
    }
    
    private func changeToSpeaker(at index: Int) {
        if index > 0 {
            let previousSpeakerIndex = index - 1
            speakers[previousSpeakerIndex].isCompleted = true
        }
        secondsElapsedForSpeaker = 0
        guard index < speakers.count else { return }
        speakerIndex = index
        activeSpeaker  = speakerText
        secondsElapsed = index * secondsPerSpeaker
        secondsRemaining = lengthInSeconds - secondsElapsed
        startDate = Date()
    }
    
    nonisolated private func update() {
        Task { @MainActor in
            guard let startDate, 
                    !timerStopped else {return}
            let secondsElapsed = Int(Date().timeIntervalSince1970 - startDate.timeIntervalSince1970)
            secondsElapsedForSpeaker = secondsElapsed
            self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
            guard secondsElapsed <= secondsPerSpeaker else {
                return
            }
            secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)
            
            if secondsElapsedForSpeaker >= secondsPerSpeaker {
                changeToSpeaker(at: speakerIndex + 1)
                speakerChangedAction?()
            }
        }
    }
    
    func reset(lengthInMinutes: Int, attendees: [DailyScrum.Attendee]) {
        self.lenghtInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
}

extension Array<DailyScrum.Attendee> {
    var speakers: [ScrumTimer.Speaker] {
        if isEmpty {
            return [ScrumTimer.Speaker(name: "Speaker 1", isCompleted: false)]
        } else {
            return map { ScrumTimer.Speaker(name: $0.name, isCompleted: false)}
        }
    }
}
