import Foundation

/// Shared time and date formatting. Pure, so it is unit-tested.
public enum WKTimeFormat {
    /// `m:ss`, or `h:mm:ss` once the duration reaches an hour. Negative input
    /// clamps to zero.
    public static func clock(_ seconds: Int) -> String {
        let total = max(0, seconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        }
        return String(format: "%d:%02d", m, s)
    }

    /// VoiceOver phrasing: "2 minutes 5 seconds".
    public static func spoken(_ seconds: Int) -> String {
        let total = max(0, seconds)
        let m = total / 60
        let s = total % 60
        var parts: [String] = []
        if m > 0 { parts.append("\(m) minute\(m == 1 ? "" : "s")") }
        if s > 0 || m == 0 { parts.append("\(s) second\(s == 1 ? "" : "s")") }
        return parts.joined(separator: " ")
    }

    /// `"Sab, 5 Sept, 11:29"` (or `"5 Sept, 11:29"` without `showsWeekday`) — a
    /// history-row heading: abbreviated weekday/month/day, then time, forced to
    /// a leading capital. Some locales (Spanish, French, Italian…) lowercase
    /// weekday/month names by grammatical convention — correct prose, but it
    /// reads inconsistently as a list heading.
    ///
    /// Formats the date and time halves **separately** and joins them with its
    /// own ", " rather than asking for one combined `Date.FormatStyle` — mixing
    /// date and time symbols in a single style makes some locales insert a
    /// connector word ("Sep 5 **at** 11:09 AM"), and a blanket capitalization
    /// pass can't tell that word apart from a weekday/month name. Time is
    /// formatted and left untouched, so "AM"/"PM" always survives as-is.
    public static func calendarDate(
        _ date: Date,
        showsWeekday: Bool = true,
        locale: Locale = .autoupdatingCurrent,
        timeZone: TimeZone = .autoupdatingCurrent
    ) -> String {
        var dateStyle = Date.FormatStyle(date: .omitted, time: .omitted, locale: locale, timeZone: timeZone)
            .month(.abbreviated).day()
        if showsWeekday {
            dateStyle = dateStyle.weekday(.abbreviated)
        }
        let timeStyle = Date.FormatStyle(date: .omitted, time: .omitted, locale: locale, timeZone: timeZone)
            .hour().minute()
        let datePart = capitalizingWordInitials(date.formatted(dateStyle))
        let timePart = date.formatted(timeStyle)
        return "\(datePart), \(timePart)"
    }

    private static func capitalizingWordInitials(_ string: String) -> String {
        var result = ""
        result.reserveCapacity(string.count)
        var atWordStart = true
        for character in string {
            if character.isLetter {
                result.append(atWordStart ? Character(character.uppercased()) : character)
                atWordStart = false
            } else {
                result.append(character)
                atWordStart = true
            }
        }
        return result
    }
}
