import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Add a new deck for the current user
  Future<String> addDeck(String deckname, String desc, String tag) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('decks')
          .insert({
            'user_id': userId,
            'deckname': deckname,
            'description': desc,
            'tag': tag,
          })
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      throw Exception('Failed to add deck: $e');
    }
  }

  // Get all decks for the current user
  Future<List<Map<String, dynamic>>> getDecks() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabase
        .from('decks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    return response
        .map((deck) => {
              'deckid': deck['id'],
              'deckname': deck['deckname'],
              'desc': deck['description'],
              'tag': deck['tag'],
            })
        .toList();
  }

  // Get details of a specific deck
  Future<Map<String, dynamic>> getDeckDetails(String deckId) async {
    try {
      final response =
          await _supabase.from('decks').select().eq('id', deckId).single();

      return {
        'deckname': response['deckname'],
        'desc': response['description'],
        'tag': response['tag'],
      };
    } catch (e) {
      throw Exception('Failed to fetch deck details: $e');
    }
  }

  // Edit a deck's details
  Future<String> editDeck(
      String deckname, String desc, String tag, String deckId) async {
    try {
      await _supabase.from('decks').update({
        'deckname': deckname,
        'description': desc,
        'tag': tag,
      }).eq('id', deckId);

      return "Deck updated successfully";
    } catch (e) {
      throw Exception('Failed to update deck: $e');
    }
  }

  // Add a new card to a deck
  Future<String> addCard(String deckId, String front, String back) async {
    try {
      await _supabase.from('flashcards').insert({
        'deck_id': deckId,
        'front': front,
        'back': back,
        'score': 0,
      });

      return "Card added successfully";
    } catch (e) {
      throw Exception('Failed to add card: $e');
    }
  }

  // Delete a specific card
  Future<String> deleteOneCard(String cardId) async {
    try {
      await _supabase.from('flashcards').delete().eq('id', cardId);
      return "Card deleted successfully";
    } catch (e) {
      throw Exception('Failed to delete card: $e');
    }
  }

  // Edit a specific card
  Future<String> editCard(String front, String back, String cardId) async {
    try {
      await _supabase.from('flashcards').update({
        'front': front,
        'back': back,
      }).eq('id', cardId);

      return "Card updated successfully";
    } catch (e) {
      throw Exception('Failed to update card: $e');
    }
  }

  // Get all flashcards for a specific deck
  Future<List<Map<String, dynamic>>> getCardDetails(String deckId) async {
    final response = await _supabase
        .from('flashcards')
        .select()
        .eq('deck_id', deckId)
        .order('created_at', ascending: true);

    return response
        .map((card) => {
              'cardId': card['id'],
              'deckId': card['deck_id'],
              'front': card['front'],
              'back': card['back'],
              'score': card['score'],
            })
        .toList();
  }

  // Update the score of a flashcard
  Future<void> updateScore(String cardId, int score) async {
    await _supabase
        .from('flashcards')
        .update({'score': score}).eq('id', cardId);
  }

  // Delete a deck and its flashcards
  Future<void> deleteDeck(String deckId) async {
    // Delete flashcards first due to foreign key constraint
    await _supabase.from('flashcards').delete().eq('deck_id', deckId);
    await _supabase.from('decks').delete().eq('id', deckId);
  }

  // Reset a deck (e.g., set all flashcards' scores to 0)
  Future<void> resetDeck(String deckId) async {
    await _supabase
        .from('flashcards')
        .update({'score': 0}).eq('deck_id', deckId);
  }

  // Get total count of decks and cards for the current user
  Future<List<int>> getTotalCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Count decks
      final deckCountResponse = await _supabase
          .from('decks')
          .select('id')
          .eq('user_id', userId)
          .count(CountOption.exact);
      final deckCount = deckCountResponse.count;

      // Get deck IDs for the user
      final deckIds =
          (await _supabase.from('decks').select('id').eq('user_id', userId))
              .map((deck) => deck['id'])
              .toList();

      // Count flashcards (across all decks of the user)
      int cardCount = 0;
      if (deckIds.isNotEmpty) {
        final cardCountResponse = await _supabase
            .from('flashcards')
            .select('id')
            .inFilter('deck_id', deckIds)
            .count(CountOption.exact);
        cardCount = cardCountResponse.count;
      }

      return [deckCount, cardCount];
    } catch (e) {
      throw Exception('Failed to fetch total count: $e');
    }
  }

  // Get count of cards at each level
  Future<List<int>> getLevelCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Get all deck IDs for the user
      final deckIds =
          (await _supabase.from('decks').select('id').eq('user_id', userId))
              .map((deck) => deck['id'])
              .toList();

      if (deckIds.isEmpty) {
        return [0, 0, 0, 0]; // No decks, return zeros
      }

      // Get all flashcards for the user's decks
      final flashcards = await _supabase
          .from('flashcards')
          .select('score')
          .inFilter('deck_id', deckIds);

      // Count cards at each level based on score
      int level0 = 0; // score < 0
      int level1 = 0; // score = 0
      int level2 = 0; // 0 < score <= 5
      int level3 = 0; // score > 5

      for (var card in flashcards) {
        final score = (card['score'] as num?)?.toInt() ?? 0;
        if (score < 0) {
          level0++;
        } else if (score == 0) {
          level1++;
        } else if (score <= 5) {
          level2++;
        } else {
          level3++;
        }
      }

      return [level0, level1, level2, level3];
    } catch (e) {
      throw Exception('Failed to fetch level count: $e');
    }
  }

  // Get average score of cards for the last 15 days
  Future<List<double>> getAvgScore() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Get all deck IDs for the user
      final deckIds =
          (await _supabase.from('decks').select('id').eq('user_id', userId))
              .map((deck) => deck['id'])
              .toList();

      if (deckIds.isEmpty) {
        return List.filled(15, 0.0); // No decks, return zeros
      }

      // Calculate the date 15 days ago
      final now = DateTime.now();
      final fifteenDaysAgo = now.subtract(const Duration(days: 15));

      // Fetch flashcards for the user's decks within the last 15 days
      final flashcards = await _supabase
          .from('flashcards')
          .select('score, created_at')
          .inFilter('deck_id', deckIds)
          .gte('created_at', fifteenDaysAgo.toIso8601String());

      // Group flashcards by day and calculate average score
      final averages = List.filled(15, 0.0);
      final counts = List.filled(15, 0);

      for (var card in flashcards) {
        final createdAt = DateTime.parse(card['created_at'] as String);
        final score = (card['score'] as num?)?.toDouble() ?? 0.0;

        // Calculate the day index (0 for 15 days ago, 14 for today)
        final dayDifference = now.difference(createdAt).inDays;
        if (dayDifference < 0 || dayDifference >= 15)
          continue; // Skip if outside range
        final dayIndex = 14 - dayDifference; // Map to 0-14 range

        averages[dayIndex] += score;
        counts[dayIndex]++;
      }

      // Compute averages
      for (int i = 0; i < 15; i++) {
        if (counts[i] > 0) {
          averages[i] /= counts[i];
        }
      }

      return averages;
    } catch (e) {
      throw Exception('Failed to fetch average scores: $e');
    }
  }

  // Reset all stats for the current user (set all flashcard scores to 0)
  Future<String> resetStats() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Get all deck IDs for the user
      final deckIds =
          (await _supabase.from('decks').select('id').eq('user_id', userId))
              .map((deck) => deck['id'])
              .toList();

      if (deckIds.isEmpty) {
        return "No decks to reset";
      }

      // Reset scores for all flashcards in the user's decks
      await _supabase
          .from('flashcards')
          .update({'score': 0}).inFilter('deck_id', deckIds);

      return "Stats reset successfully";
    } catch (e) {
      throw Exception('Failed to reset stats: $e');
    }
  }
}
