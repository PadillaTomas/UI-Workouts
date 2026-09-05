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

    /// Independently re-derives what a locale's own date/time symbols render as,
    /// so the assertions don't depend on hand-typed literals — Foundation uses
    /// U+202F (narrow no-break space) before AM/PM, not a plain space, which a
    /// hardcoded `"11:09 AM"` string would silently fail to match.
    private func rawParts(_ date: Date, showsWeekday: Bool, locale: Locale, timeZone: TimeZone) -> (date: String, time: String) {
        var dateStyle = Date.FormatStyle(date: .omitted, time: .omitted, locale: locale, timeZone: timeZone)
            .month(.abbreviated).day()
        if showsWeekday { dateStyle = dateStyle.weekday(.abbreviated) }
        let timeStyle = Date.FormatStyle(date: .omitted, time: .omitted, locale: locale, timeZone: timeZone)
            .hour().minute()
        return (date.formatted(dateStyle), date.formatted(timeStyle))
    }

    @Test("calendarDate capitalizes weekday and month in a locale that lowercases them")
    func calendarDateCapitalizesLowercaseLocales() {
        let date = Date(timeIntervalSince1970: 1_757_070_540) // 2025-09-05 11:09 UTC
        let locale = Locale(identifier: "es_ES")
        let tz = TimeZone(identifier: "UTC")!

        let (rawDate, time) = rawParts(date, showsWeekday: true, locale: locale, timeZone: tz)
        // Confirm the premise: Spanish really does lowercase both words, so the
        // test would fail if Foundation ever changed that, not pass for a
        // hollow reason.
        #expect(rawDate == "vie, 5 sept")
        #expect(WKTimeFormat.calendarDate(date, locale: locale, timeZone: tz) == "Vie, 5 Sept, \(time)")

        let (rawDateNoWeekday, time2) = rawParts(date, showsWeekday: false, locale: locale, timeZone: tz)
        #expect(rawDateNoWeekday == "5 sept")
        #expect(WKTimeFormat.calendarDate(date, showsWeekday: false, locale: locale, timeZone: tz) == "5 Sept, \(time2)")
    }

    @Test("calendarDate leaves an already-capitalized locale untouched, AM/PM included")
    func calendarDateLeavesEnglishUntouched() {
        let date = Date(timeIntervalSince1970: 1_757_070_540)
        let locale = Locale(identifier: "en_US")
        let tz = TimeZone(identifier: "UTC")!

        let (rawDate, time) = rawParts(date, showsWeekday: true, locale: locale, timeZone: tz)
        #expect(WKTimeFormat.calendarDate(date, locale: locale, timeZone: tz) == "\(rawDate), \(time)")

        let (rawDateNoWeekday, time2) = rawParts(date, showsWeekday: false, locale: locale, timeZone: tz)
        #expect(WKTimeFormat.calendarDate(date, showsWeekday: false, locale: locale, timeZone: tz) == "\(rawDateNoWeekday), \(time2)")
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

    @Test("danger is its own role, distinct from accent and done")
    func danger() {
        #expect(WKColor.danger != WKColor.accent)
        #expect(WKColor.danger != WKColor.stateDone)
    }

    @Test("every font style resolves a spec")
    func fonts() {
        for style in WKFont.allCases {
            #expect(style.spec.size > 0)
        }
    }
}
