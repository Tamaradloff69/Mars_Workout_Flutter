/// Unified training zone descriptions for all workout types.
/// This eliminates duplication between RowPace and ZoneDesc classes.
library;

// =============================================================================
// ROWING ZONES
// =============================================================================
class RowingZones {
  static const String steady =
      "Steady State (UT2): 18-20 SPM.\n"
      "Moderate effort. You should be able to hold a conversation. Focus on technique and rhythm.";

  static const String intermediateSteady =
      "Steady Distance: 20-24 SPM.\n"
      "Solid aerobic work. Consistent split.";

  static const String hardDistance =
      "Hard Distance (UT1/AT): Unrestricted Rate.\n"
      "Faster than steady state. This is a time-trial effort (approx 80-90% max).";

  static const String speedInterval =
      "Speed Interval (TR): High Intensity.\n"
      "Row faster than your 2k race pace. Maximum sustainable power.";

  static const String enduranceInterval =
      "Endurance Interval (AT): 2k Pace.\n"
      "Hold your target 2k race pace. These are mentally tough.";
}

// =============================================================================
// CYCLING ZONES
// =============================================================================
class CyclingZones {
  static const String z0 =
      "Warm Up: Very light spinning.\n"
      "Get the blood flowing and legs ready. Minimal effort, just turning the pedals.";

  static const String z1 =
      "Active Recovery: Can sing a song.\n"
      "Very easy spinning with minimal resistance. Use this to flush out legs and recover.";

  static const String z2 =
      "Endurance: Can hold a full conversation.\n"
      "'All day' pace. You are working but not struggling. This burns fat and builds your aerobic engine.";

  static const String z3 =
      "Tempo: Can speak in short sentences.\n"
      "'Comfortably Hard.' You have to focus to keep this pace up. Breathing is deeper and rhythmic.";

  static const String sweetSpot =
      "Sweet Spot: Can speak a few words at a time.\n"
      "The 'Goldilocks' zone. Hard enough to build big power, but sustainable for long blocks (10-20m).";

  static const String z4 =
      "Threshold: Can hardly speak.\n"
      "Your 1-hour race pace. Legs start to burn significantly. Requires mental toughness to hold.";

  static const String z5 =
      "Max Effort: Cannot speak.\n"
      "All-out effort. Sprints or steep hill attacks. You should be gasping for air.";
}

// =============================================================================
// ELLIPTICAL ZONES (using RPE - Rate of Perceived Exertion)
// =============================================================================
class EllipticalZones {
  static const String warmup =
      "Warm-up: Very light effort.\n"
      "Resistance 3/10. Get the blood flowing. Smooth, full circles.";

  static const String recovery =
      "Recovery: Minimal effort.\n"
      "Easy pace. Let heart rate drop. Focus on breathing.";

  static const String moderate =
      "Moderate: RPE 5-6.\n"
      "Conversational pace. Steady breathing. Can maintain for long periods.";

  static const String hard =
      "Hard: RPE 7-8.\n"
      "Uncomfortable but sustainable. Labored breathing. Requires focus.";

  static const String maxEffort =
      "Max Effort: RPE 9-10.\n"
      "All-out sprint. Cannot maintain conversation. Gasping for air.";

  static String resistanceRange(int low, int high) =>
      "Resistance $low-$high/10.";
}

// =============================================================================
// UNIVERSAL INTENSITY LEVELS (for cross-sport compatibility)
// =============================================================================
class UniversalIntensity {
  static const String low = "Low Intensity";
  static const String medium = "Medium Intensity";
  static const String high = "High Intensity";
  static const String maximum = "Maximum Intensity";
}
