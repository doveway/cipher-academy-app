import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/puzzle.dart';
import '../models/quest.dart';
import '../services/streak_reward_service.dart';
import '../theme/app_theme.dart';
import '../widgets/streak_notification.dart';
import '../widgets/quest_widget.dart';
import '../widgets/answer_reveal_dialog.dart';
import 'profile_screen.dart';

/// Demo screen showcasing all new engagement features
class EngagementDemoScreen extends StatefulWidget {
  const EngagementDemoScreen({super.key});

  @override
  State<EngagementDemoScreen> createState() => _EngagementDemoScreenState();
}

class _EngagementDemoScreenState extends State<EngagementDemoScreen> {
  late UserProfile _profile;
  late List<Quest> _dailyQuests;

  @override
  void initState() {
    super.initState();
    _profile = _createDemoProfile();
    _dailyQuests = _createDemoQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engagement Features Demo'),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: AppTheme.brass.withOpacity(0.3),
              child: Text(
                _getAvatarEmoji(_profile.avatar),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Token Display
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.brass.withOpacity(0.3),
                          AppTheme.burgundy.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.brass.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          Icons.monetization_on,
                          '${_profile.tokens}',
                          'Tokens',
                          AppTheme.brass,
                        ),
                        _buildStatItem(
                          Icons.star,
                          '${_profile.reputationScore}',
                          'Reputation',
                          AppTheme.forestGreen,
                        ),
                        _buildStatItem(
                          Icons.emoji_events,
                          _profile.rankDisplay,
                          'Rank',
                          _getRankColor(_profile.rank),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Streak Widget
                  StreakWidget(
                    currentStreak: _profile.currentStreak,
                    longestStreak: _profile.longestStreak,
                    onTap: () => _showStreakDialog(),
                  ),
                  const SizedBox(height: 24),

                  // Daily Quests
                  DailyQuestsPanel(quests: _dailyQuests),
                  const SizedBox(height: 24),

                  // Demo Buttons
                  const Text(
                    'Try Features',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDemoButton(
                    'View Profile',
                    Icons.person,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildDemoButton(
                    'Answer Reveal Dialog',
                    Icons.lightbulb_outline,
                    () => _showAnswerRevealDialog(),
                  ),
                  const SizedBox(height: 12),

                  _buildDemoButton(
                    'Streak Notification (7 days)',
                    Icons.local_fire_department,
                    () => _showStreakDialog(),
                  ),
                  const SizedBox(height: 12),

                  _buildDemoButton(
                    'Add 100 Tokens',
                    Icons.add,
                    () {
                      setState(() {
                        _profile = _profile.copyWith(
                          tokens: _profile.tokens + 100,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildDemoButton(
                    'Increase Streak',
                    Icons.trending_up,
                    () {
                      setState(() {
                        _profile = _profile.copyWith(
                          currentStreak: _profile.currentStreak + 1,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
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

  Widget _buildDemoButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.darkNavy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppTheme.brass.withOpacity(0.5)),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  void _showStreakDialog() {
    final reward = StreakRewardService.calculateStreakReward(
      _profile.currentStreak,
      _profile.userId,
      DateTime.now(),
    );
    showStreakNotification(context, reward, _profile.currentStreak);
  }

  void _showAnswerRevealDialog() {
    final demoPuzzle = Puzzle(
      id: 'demo',
      title: 'Demo Puzzle',
      description: 'This is a demo puzzle',
      type: PuzzleType.sequenceCompletion,
      category: PuzzleCategory.patternRecognition,
      difficulty: Difficulty.intermediate,
      level: 1,
      chapterNumber: 1,
      chapterTitle: 'Demo',
      puzzleData: {},
      solution: '42',
      hints: ['Hint 1', 'Hint 2'],
      baseInsightPoints: 100,
    );

    showDialog(
      context: context,
      builder: (context) => AnswerRevealDialog(
        puzzle: demoPuzzle,
        profile: _profile,
        onReveal: () {
          setState(() {
            _profile = _profile.copyWith(
              tokens: _profile.tokens - 25,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Answer revealed! Solution: 42')),
          );
        },
      ),
    );
  }

  UserProfile _createDemoProfile() {
    return UserProfile(
      userId: 'demo_user',
      displayName: 'Cipher Solver',
      avatar: AvatarType.detective,
      title: UserTitle.strategist,
      rank: SkillRank.gold,
      tokens: 1250,
      lifetimeTokensEarned: 3500,
      currentStreak: 7,
      longestStreak: 12,
      lastPlayedDate: DateTime.now(),
      freeAnswersAvailable: 2,
      freeAnswersExpiryDate: DateTime.now().add(const Duration(days: 1)),
      reputationScore: 850,
      totalPuzzlesSolved: 45,
      perfectSolves: 15,
      multiplayerWins: 12,
      multiplayerGamesPlayed: 20,
      winRate: 0.6,
      skillLevels: {
        'Logic & Reasoning': 75,
        'Cryptography': 60,
        'Pattern Recognition': 80,
      },
    );
  }

  List<Quest> _createDemoQuests() {
    return [
      Quest(
        id: '1',
        type: QuestType.daily,
        objective: QuestObjective.solvePuzzles,
        title: 'Daily Puzzler',
        description: 'Solve 3 puzzles today',
        targetCount: 3,
        currentProgress: 1,
        tokenReward: 30,
        reputationReward: 10,
      ),
      Quest(
        id: '2',
        type: QuestType.daily,
        objective: QuestObjective.perfectSolve,
        title: 'Perfectionist',
        description: 'Get 1 perfect solve',
        targetCount: 1,
        currentProgress: 0,
        tokenReward: 50,
        reputationReward: 20,
      ),
      Quest(
        id: '3',
        type: QuestType.daily,
        objective: QuestObjective.solveWithoutHints,
        title: 'Self-Reliant',
        description: 'Solve a puzzle without hints',
        targetCount: 1,
        currentProgress: 1,
        isCompleted: true,
        tokenReward: 40,
        reputationReward: 15,
      ),
    ];
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
}
