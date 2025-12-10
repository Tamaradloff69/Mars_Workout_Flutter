class GifRepository {
  static String getGifUrl(String workoutTitle, String stageName) {
    // Normalize strings for easier matching
    final title = workoutTitle.toLowerCase();
    final stage = stageName.toLowerCase();

    // 1. Cycling
    if (title.contains('cycling') || title.contains('spin')) {
      if (stage.contains('sprint') || stage.contains('attack')) {
        // Intense cycling
        return 'https://media.giphy.com/media/o7R0zQ62m87ptWWpHt/giphy.gif';
      }
      // Steady cycling
      return 'https://media.giphy.com/media/l41lH4ADDt7WfkKww/giphy.gif';
    }

    // 2. Rowing
    if (title.contains('rowing') || title.contains('pete')) {
      return 'https://media.giphy.com/media/3o7TjqC6d6KqT9o8ww/giphy.gif';
    }

    // 3. Kettlebell / Strength
    if (title.contains('kettlebell') || title.contains('plan 015')) {
      if (stage.contains('swing')) {
        // Kettlebell Swing
        return 'https://media.giphy.com/media/ieymaDWYotBsZwMvop/giphy.gif';
      }
      if (stage.contains('squat')) {
        // Goblet Squat
        return 'https://media.giphy.com/media/3o7qDEq2bMbcbPRQ2c/giphy.gif';
      }
      if (stage.contains('pushup') || stage.contains('push-up')) {
        // Pushups
        return 'https://media.giphy.com/media/xUA7b2Hd5vNq6AbaQo/giphy.gif';
      }
    }

    // Default / Resting / Warmup
    return 'https://media.giphy.com/media/3o6ZTpWvwnhf34Oj0A/giphy.gif'; // Generic fitness or calm breathing
  }
}