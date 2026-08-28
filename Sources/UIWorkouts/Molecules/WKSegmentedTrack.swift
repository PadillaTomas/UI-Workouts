import SwiftUI

/// One segment of a ``WKSegmentedTrack``.
public struct WKTrackSegment: Identifiable, Sendable {
    public enum Progress: Sendable { case done, current, upcoming }

    public let id: Int
    public var weight: Double
    public var progress: Progress
    public var phase: WKPhase

    public init(id: Int, weight: Double, progress: Progress, phase: WKPhase) {
        self.id = id
        self.weight = max(0, weight)
        self.progress = progress
        self.phase = phase
    }
}

public extension Array where Element == WKTrackSegment {
    /// Normalised weights (sum to 1), order preserved. Used for layout and tested.
    var normalisedWeights: [Double] {
        let total = reduce(0) { $0 + $1.weight }
        guard total > 0 else {
            return isEmpty ? [] : Array<Double>(repeating: 1.0 / Double(count), count: count)
        }
        return map { $0.weight / total }
    }
}

/// Layer 2 — the run/walk progress bar: flex-weighted 8pt bars with 3pt gaps.
/// `done` segments use `stateDone`, `current` uses the phase color, `upcoming`
/// uses the phase soft color.
public struct WKSegmentedTrack: View {
    private let segments: [WKTrackSegment]
    private let height: CGFloat

    public init(segments: [WKTrackSegment], height: CGFloat = 8) {
        self.segments = segments
        self.height = height
    }

    public var body: some View {
        GeometryReader { geo in
            let gap: CGFloat = 3
            let totalGap = gap * CGFloat(max(0, segments.count - 1))
            let usable = max(0, geo.size.width - totalGap)
            let weights = segments.normalisedWeights
            HStack(spacing: gap) {
                ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                    Capsule(style: .continuous)
                        .fill(color(for: segment))
                        .frame(width: usable * weights[index])
                }
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Session progress")
        .accessibilityValue(progressValue)
    }

    private func color(for segment: WKTrackSegment) -> Color {
        switch segment.progress {
        case .done: return WKColor.stateDone
        case .current: return segment.phase.color
        case .upcoming: return segment.phase.softColor
        }
    }

    private var progressValue: String {
        let done = segments.filter { $0.progress == .done }.count
        return "\(done) of \(segments.count) intervals done"
    }
}

#Preview {
    WKSegmentedTrack(segments: [
        .init(id: 0, weight: 2, progress: .done, phase: .run),
        .init(id: 1, weight: 1, progress: .done, phase: .walk),
        .init(id: 2, weight: 2, progress: .current, phase: .run),
        .init(id: 3, weight: 1, progress: .upcoming, phase: .walk),
        .init(id: 4, weight: 2, progress: .upcoming, phase: .run)
    ])
    .padding(WKSpace.xl)
    .background(WKColor.bg)
}
