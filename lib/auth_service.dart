import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Stream for authentication state changes
  Stream<User?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) {
      return event.session?.user;
    });
  }

  // Sign in with email and password
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        return "user-not-found";
      }
      return "Success";
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return "wrong-password";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Sign up with email and password
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        return "Failed to sign up";
      }
      return "Success";
    } on AuthException catch (e) {
      if (e.message.contains('User already registered')) {
        return "email exists";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Sign out
  Future<String> signOut() async {
    try {
      await _supabase.auth.signOut();
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  // Send password reset email
  Future<String> forgotPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return "Successful";
    } on AuthException catch (e) {
      if (e.message.contains('User not found')) {
        return "user-not-found";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Check if the provided password is correct by attempting to sign in
  Future<bool> checkPassword(String password) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null || user.email == null) {
        return false;
      }

      final response = await _supabase.auth.signInWithPassword(
        email: user.email!,
        password: password,
      );

      return response.user != null;
    } catch (e) {
      return false;
    }
  }

  // Delete the user's account and associated data
  Future<String> deleteUser(String password) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Verify the password
      final isPasswordCorrect = await checkPassword(password);
      if (!isPasswordCorrect) {
        return "Incorrect password";
      }

      // Delete user's decks and flashcards
      final deckIds =
          (await _supabase.from('decks').select('id').eq('user_id', user.id))
              .map((deck) => deck['id'])
              .toList();

      if (deckIds.isNotEmpty) {
        await _supabase
            .from('flashcards')
            .delete()
            .inFilter('deck_id', deckIds);
        await _supabase.from('decks').delete().eq('user_id', user.id);
      }

      // Sign out the user (pseudo-deletion)
      await _supabase.auth.signOut();

      // Note: Actual user deletion requires a server-side function
      return "Account data deleted successfully. Please contact support to fully delete your account.";
    } catch (e) {
      return "Failed to delete account: $e";
    }
  }

  // Edit the user's password
  Future<String> editPassword(String newPassword) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      return "Password updated successfully";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Failed to update password: $e";
    }
  }
}
