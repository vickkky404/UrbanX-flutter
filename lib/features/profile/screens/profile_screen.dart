import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),
      body: currentUser.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No user found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF6750A4).withValues(alpha: 0.1),
                        ),
                        child: user.photoURL != null
                            ? ClipOval(
                          child: Image.network(
                            user.photoURL!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF6750A4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.displayName ?? 'User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Profile Information
                const Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _ProfileInfoCard(
                  label: 'Full Name',
                  value: user.displayName ?? 'Not set',
                ),
                const SizedBox(height: 12),
                _ProfileInfoCard(
                  label: 'Email',
                  value: user.email,
                ),
                const SizedBox(height: 12),
                _ProfileInfoCard(
                  label: 'Phone',
                  value: user.phoneNumber ?? 'Not set',
                ),
                const SizedBox(height: 12),
                _ProfileInfoCard(
                  label: 'Email Verified',
                  value: user.isEmailVerified ? 'Yes' : 'No',
                ),
                const SizedBox(height: 32),

                // Action Buttons
                const Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit profile coming soon!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF6750A4),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Change password coming soon!'),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(
                        color: Color(0xFF6750A4),
                      ),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Color(0xFF6750A4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text('Error: $err'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

