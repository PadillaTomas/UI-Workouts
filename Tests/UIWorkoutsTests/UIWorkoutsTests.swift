import Testing
import SwiftUI
@testable import UIWorkouts

@Suite("WKTimeFormat")
struct WKTimeFormatTests {
    @Test("clock formats m:ss and h:mm:ss")
    func clock() {
        #expect(WKTimeFormat.clock(5) == "0:05")
        #expect(WKTimeFormat.clock(125) == "2:05")
        #expect(WKTimeFormat.clock(3725) == "1:02:05")
        #expect(WKTimeFormat.clock(-10) == "0:00")
    }

    @Test("spoken phrasing")
    func spoken() {
        #expect(WKTimeFormat.spoken(0) == "0 seconds")
        #expect(WKTimeFormat.spoken(1) == "1 second")
        #expect(WKTimeFormat.spoken(60) == "1 minute")
        #expect(WKTimeFormat.spoken(125) == "2 minutes 5 seconds")
    }
}

@Suite("WKSegmentedTrack weights")
struct WKSegmentedTrackTests {
    @Test("normalised weights sum to 1 and keep order")
    func normalise() {
        let segments = [
            WKTrackSegment(id: 0, weight: 2, progress: .done, phase: .run),
            WKTrackSegment(id: 1, weight: 1, progress: .current, phase: .walk),
            WKTrackSegment(id: 2, weight: 1, progress: .upcoming, phase: .run)
        ]
        let w = segments.normalisedWeights
        #expect(abs(w.reduce(0, +) - 1) < 1e-9)
        #expect(w[0] > w[1])
        #expect(abs(w[1] - w[2]) < 1e-9)
    }

    @Test("zero total falls back to equal split")
    func zeroTotal() {
        let segments = [
            WKTrackSegment(id: 0, weight: 0, progress: .done, phase: .run),
            WKTrackSegment(id: 1, weight: 0, progress: .done, phase: .run)
        ]
        #expect(segments.normalisedWeights == [0.5, 0.5])
    }
}

@Suite("Tokens")
struct TokenTests {
    @Test("phase colors and labels are distinct and non-empty")
    func phase() {
        #expect(WKPhase.run.label == "Run")
        #expect(WKPhase.walk.label == "Walk")
        #expect(WKPhase.run.color != WKPhase.walk.color)
        #expect(WKPhase.run.softColor != WKPhase.run.color)
    }

    @Test("theme mode maps to color scheme")
    func theme() {
        #expect(WKThemeMode.system.colorScheme == nil)
        #expect(WKThemeMode.light.colorScheme == .light)
        #expect(WKThemeMode.dark.colorScheme == .dark)
    }

    @Test("every font style resolves a spec")
    func fonts() {
        for style in WKFont.allCases {
            #expect(style.spec.size > 0)
        }
    }
}
