import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_state_provider.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameStateProvider>();
    final isPremium = gameState.isPremium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          if (!isPremium) ...[
            _buildPremiumBanner(context),
            const Divider(),
          ],
          _buildAccountSection(context, gameState),
          const Divider(),
          _buildGameSettings(context),
          const Divider(),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.burgundy,
            AppTheme.brass.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPremiumDialog(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: AppTheme.parchment, size: 32),
                    SizedBox(width: 12),
                    Text(
                      'Upgrade to Premium',
                      style: TextStyle(
                        color: AppTheme.parchment,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Unlock all chapters, unlimited hints, and ad-free experience',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.parchment,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showPremiumDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.parchment,
                    foregroundColor: AppTheme.burgundy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('View Plans'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, GameStateProvider gameState) {
    final progress = gameState.userProgress;
    if (progress == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.brass,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person, color: AppTheme.brass),
          title: const Text('Player ID'),
          subtitle: Text(
            progress.userId.substring(0, 8),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        if (progress.isPremium)
          ListTile(
            leading: const Icon(Icons.workspace_premium, color: AppTheme.brass),
            title: const Text('Premium Member'),
            subtitle: Text(
              progress.premiumExpiryDate != null
                  ? 'Expires: ${_formatDate(progress.premiumExpiryDate!)}'
                  : 'Active',
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.brass,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'PREMIUM',
                style: TextStyle(
                  color: AppTheme.darkNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ListTile(
          leading: const Icon(Icons.emoji_events, color: AppTheme.brass),
          title: const Text('Current Level'),
          trailing: Text(
            '${progress.currentLevel}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.brass,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.psychology, color: AppTheme.brass),
          title: const Text('Total Insight Points'),
          trailing: Text(
            '${progress.totalInsightPoints}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.brass,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Game Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.brass,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.volume_up, color: AppTheme.brass),
          title: const Text('Sound Effects'),
          trailing: Switch(
            value: true,
            onChanged: (value) {
              // TODO: Implement sound settings
            },
            activeColor: AppTheme.brass,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.music_note, color: AppTheme.brass),
          title: const Text('Background Music'),
          trailing: Switch(
            value: false,
            onChanged: (value) {
              // TODO: Implement music settings
            },
            activeColor: AppTheme.brass,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.notifications, color: AppTheme.brass),
          title: const Text('Daily Hint Reminder'),
          subtitle: const Text('Get notified when your free hint resets'),
          trailing: Switch(
            value: false,
            onChanged: (value) {
              // TODO: Implement notifications
            },
            activeColor: AppTheme.brass,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.restore, color: AppTheme.brass),
          title: const Text('Restore Purchases'),
          subtitle: const Text('Restore premium subscription'),
          onTap: () {
            // TODO: Implement restore purchases
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Feature coming soon!'),
                backgroundColor: AppTheme.burgundy,
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: AppTheme.errorRed),
          title: const Text('Reset Progress'),
          subtitle: const Text('Clear all game data'),
          onTap: () => _showResetDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'About',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.brass,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info, color: AppTheme.brass),
          title: const Text('Version'),
          trailing: const Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.description, color: AppTheme.brass),
          title: const Text('Privacy Policy'),
          onTap: () {
            // TODO: Show privacy policy
          },
        ),
        ListTile(
          leading: const Icon(Icons.gavel, color: AppTheme.brass),
          title: const Text('Terms of Service'),
          onTap: () {
            // TODO: Show terms of service
          },
        ),
        ListTile(
          leading: const Icon(Icons.code, color: AppTheme.brass),
          title: const Text('Open Source Licenses'),
          onTap: () {
            showLicensePage(
              context: context,
              applicationName: 'Cipher Academy',
              applicationVersion: '1.0.0',
            );
          },
        ),
        const SizedBox(height: 32),
        Center(
          child: Column(
            children: [
              const Icon(Icons.auto_stories, color: AppTheme.brass, size: 48),
              const SizedBox(height: 8),
              Text(
                'Cipher Academy',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Unlock the Mysteries',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppTheme.darkParchment,
                    ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.star, color: AppTheme.brass),
            SizedBox(width: 8),
            Text('Choose Your Plan'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPremiumPlan(
                context,
                title: 'Monthly',
                price: '\$4.99',
                period: '/month',
                features: [
                  'All chapters unlocked',
                  'Unlimited hints',
                  'Ad-free experience',
                  'Exclusive content',
                ],
                onTap: () {
                  // TODO: Implement purchase
                  _simulatePurchase(context, isMonthly: true);
                },
              ),
              const SizedBox(height: 16),
              _buildPremiumPlan(
                context,
                title: 'Yearly',
                price: '\$29.99',
                period: '/year',
                badge: 'SAVE 50%',
                features: [
                  'All monthly benefits',
                  'Early access to new content',
                  'Priority support',
                  'Special achievements',
                ],
                onTap: () {
                  // TODO: Implement purchase
                  _simulatePurchase(context, isMonthly: false);
                },
                isRecommended: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPlan(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    String? badge,
    required List<String> features,
    required VoidCallback onTap,
    bool isRecommended = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isRecommended
            ? AppTheme.burgundy.withOpacity(0.2)
            : AppTheme.darkNavy,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended ? AppTheme.brass : AppTheme.forestGreen,
          width: isRecommended ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.brass,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: AppTheme.darkNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isRecommended ? AppTheme.brass : AppTheme.parchment,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.brass,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      period,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.darkParchment,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: AppTheme.successGreen, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _simulatePurchase(BuildContext context, {required bool isMonthly}) {
    final gameState = context.read<GameStateProvider>();
    final expiryDate = DateTime.now().add(
      Duration(days: isMonthly ? 30 : 365),
    );

    gameState.setPremium(true, expiryDate: expiryDate);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.celebration, color: AppTheme.parchment),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Welcome to Premium! (Demo Mode - No actual purchase made)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.parchment,
                    ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppTheme.errorRed),
            SizedBox(width: 8),
            Text('Reset Progress?'),
          ],
        ),
        content: const Text(
          'This will delete all your progress, including completed puzzles, '
          'insight points, and achievements. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final storageService = context.read<StorageService>();
              await storageService.clearAllData();

              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All progress has been reset. Please restart the app.'),
                    backgroundColor: AppTheme.errorRed,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
