import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../services/rank_progression_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This will need to use actual profile provider later
    final profile = _getDemoProfile();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.darkNavy,
                      AppTheme.burgundy.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              title: Text(
                profile.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildAvatarSection(context, profile),
                const SizedBox(height: 24),
                _buildStatsCards(profile),
                const SizedBox(height: 16),
                _buildRankProgress(profile),
                const SizedBox(height: 16),
                _buildSkillsSection(profile),
                const SizedBox(height: 16),
                _buildMultiplayerStats(profile),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context, UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showAvatarSelector(context, profile),
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.brass,
                        AppTheme.brass.withOpacity(0.6),
                      ],
                    ),
                    border: Border.all(
                      color: AppTheme.brass,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getAvatarEmoji(profile.avatar),
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.forestGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.burgundy.withOpacity(0.3),
                  AppTheme.forestGreen.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.brass.withOpacity(0.5)),
            ),
            child: Text(
              profile.titleDisplay,
              style: TextStyle(
                color: AppTheme.brass,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getRankIcon(profile.rank),
                color: _getRankColor(profile.rank),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                profile.rankDisplay,
                style: TextStyle(
                  color: _getRankColor(profile.rank),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Tokens',
              profile.tokens.toString(),
              Icons.monetization_on,
              AppTheme.brass,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Streak',
              '${profile.currentStreak} days',
              Icons.local_fire_department,
              profile.currentStreak >= 5 ? Colors.orange : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Reputation',
              profile.reputationScore.toString(),
              Icons.star,
              AppTheme.forestGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkNavy.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankProgress(UserProfile profile) {
    final progress = RankProgressionService.getRankProgress(profile);
    final isMaxRank = profile.rank == SkillRank.grandmaster;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.burgundy.withOpacity(0.3),
              AppTheme.darkNavy.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.brass.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isMaxRank ? 'Maximum Rank Achieved' : 'Rank Progress',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(
                  _getRankColor(profile.rank),
                ),
              ),
            ),
            if (!isMaxRank) ...[
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toStringAsFixed(0)}% to ${_getNextRankName(profile.rank)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(UserProfile profile) {
    if (profile.skillLevels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.darkNavy.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.forestGreen.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skill Mastery',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...profile.skillLevels.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSkillBar(entry.key, entry.value),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillBar(String skillName, int level) {
    final progress = level / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skillName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              'Lv. $level',
              style: TextStyle(
                color: AppTheme.brass,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(
              level >= 100
                  ? Colors.amber
                  : level >= 70
                      ? AppTheme.forestGreen
                      : AppTheme.brass.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiplayerStats(UserProfile profile) {
    if (profile.multiplayerGamesPlayed == 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.burgundy.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.burgundy.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Multiplayer Record',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMultiplayerStat(
                  'Wins',
                  profile.multiplayerWins.toString(),
                  Icons.emoji_events,
                ),
                _buildMultiplayerStat(
                  'Played',
                  profile.multiplayerGamesPlayed.toString(),
                  Icons.gamepad,
                ),
                _buildMultiplayerStat(
                  'Win Rate',
                  '${(profile.winRate * 100).toStringAsFixed(0)}%',
                  Icons.trending_up,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiplayerStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.brass, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showAvatarSelector(BuildContext context, UserProfile profile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkNavy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Your Avatar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: AvatarType.values.length,
                itemBuilder: (context, index) {
                  final avatarType = AvatarType.values[index];
                  final isSelected = avatarType == profile.avatar;

                  return GestureDetector(
                    onTap: () {
                      // Update avatar (will need provider integration)
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppTheme.brass : Colors.white.withOpacity(0.3),
                          width: isSelected ? 3 : 1,
                        ),
                        color: isSelected
                            ? AppTheme.brass.withOpacity(0.2)
                            : AppTheme.darkNavy.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          _getAvatarEmoji(avatarType),
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String _getAvatarEmoji(AvatarType type) {
    switch (type) {
      case AvatarType.detective:
        return '🕵️';
      case AvatarType.scholar:
        return '📚';
      case AvatarType.strategist:
        return '♟️';
      case AvatarType.codebreaker:
        return '🔐';
      case AvatarType.mathematician:
        return '📐';
      case AvatarType.cryptographer:
        return '🔑';
      case AvatarType.logician:
        return '🧩';
      case AvatarType.analyst:
        return '🔬';
    }
  }

  IconData _getRankIcon(SkillRank rank) {
    switch (rank) {
      case SkillRank.bronze:
      case SkillRank.silver:
      case SkillRank.gold:
        return Icons.military_tech;
      case SkillRank.platinum:
      case SkillRank.diamond:
        return Icons.diamond;
      case SkillRank.master:
      case SkillRank.grandmaster:
        return Icons.emoji_events;
    }
  }

  Color _getRankColor(SkillRank rank) {
    switch (rank) {
      case SkillRank.bronze:
        return const Color(0xFFCD7F32);
      case SkillRank.silver:
        return const Color(0xFFC0C0C0);
      case SkillRank.gold:
        return const Color(0xFFFFD700);
      case SkillRank.platinum:
        return const Color(0xFFE5E4E2);
      case SkillRank.diamond:
        return const Color(0xFFB9F2FF);
      case SkillRank.master:
        return const Color(0xFFFF6B9D);
      case SkillRank.grandmaster:
        return const Color(0xFFFFD700);
    }
  }

  String _getNextRankName(SkillRank rank) {
    final nextIndex = rank.index + 1;
    if (nextIndex >= SkillRank.values.length) {
      return 'Maximum';
    }
    return SkillRank.values[nextIndex].name.toUpperCase();
  }

  // Demo profile for testing
  UserProfile _getDemoProfile() {
    return UserProfile(
      userId: 'demo',
      displayName: 'Cipher Solver',
      avatar: AvatarType.detective,
      title: UserTitle.strategist,
      rank: SkillRank.gold,
      tokens: 1250,
      lifetimeTokensEarned: 3500,
      currentStreak: 7,
      longestStreak: 12,
      lastPlayedDate: DateTime.now(),
      reputationScore: 850,
      totalPuzzlesSolved: 45,
      perfectSolves: 15,
      multiplayerWins: 12,
      multiplayerGamesPlayed: 20,
      winRate: 0.6,
      skillLevels: {
        'Logic & Reasoning': 75,
        'Cryptography': 60,
        'Algebra': 45,
        'Pattern Recognition': 80,
      },
    );
  }
}
