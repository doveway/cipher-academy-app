# Cipher Academy - Engagement & Multiplayer Features

## Overview

This document describes the new engagement and multiplayer features added to Cipher Academy, designed to increase user retention, motivation, and social interaction.

## 🎮 Core Features

### 1. Token System

Users earn and spend tokens throughout their journey.

**Earning Tokens:**
- Solving puzzles: 10-80 base tokens (varies by difficulty)
- Performance bonuses:
  - Perfect solve (no hints, fast): 2x tokens
  - No hints used: 1.5x tokens
  - Fast completion: 1.3x tokens
- Multiplayer wins: 2x the answer reveal cost
- Multiplayer participation: 1x the answer reveal cost
- Daily login bonus: 10-30 tokens (randomized)
- Quest completion: 20-100 tokens per quest
- Rank promotions: 50-1000 tokens
- Streak rewards: 10-100+ tokens

**Spending Tokens:**
- Answer reveals (costs vary by difficulty):
  - Beginner: 15 tokens
  - Intermediate: 25 tokens
  - Advanced: 40 tokens
  - Expert: 60 tokens
  - Master: 100 tokens

**File:** [lib/services/token_service.dart](lib/services/token_service.dart)

---

### 2. Daily Streak System

Encourages users to play every day with escalating rewards.

**How It Works:**
- Play 1 day in a row = Small token reward
- Play 2-4 days = Unpredictable rewards (varies each time)
- Play 5 days straight = **FREE ANSWERS FOR 2 DAYS** (unlimited)
- Continue beyond 5 days = Increasing rewards
- Milestone bonuses every 7 days

**Unpredictable Rewards (Days 2-4):**
- 30% chance: Small reward (15-29 tokens)
- 40% chance: Medium reward (30-49 tokens + sometimes free answer)
- 30% chance: Big reward (50-80 tokens + free answer)

**Special 5-Day Milestone:**
- 100 tokens
- 999 free answers (valid for 2 days)
- Special "on fire" status
- Unique notification animation

**File:** [lib/services/streak_reward_service.dart](lib/services/streak_reward_service.dart)

---

### 3. Custom Avatars & Identity

Players can customize their appearance and earn titles.

**8 Avatar Types:**
- 🕵️ Detective
- 📚 Scholar
- ♟️ Strategist
- 🔐 Codebreaker
- 📐 Mathematician
- 🔑 Cryptographer
- 🧩 Logician
- 🔬 Analyst

**6 Title Levels:**
- Novice → Solver → Strategist → Mastermind → Grandmaster → Legend

**How Titles Are Earned:**
- Based on reputation score and performance
- Not time-based - purely skill-driven
- Perfect solve rate matters
- Multiplayer wins contribute

**File:** [lib/models/user_profile.dart](lib/models/user_profile.dart)

---

### 4. Skill-Based Rank System

Progressive rank system based on performance, not just time played.

**7 Rank Tiers:**
1. 🥉 Bronze (0 points)
2. 🥈 Silver (500 points)
3. 🥇 Gold (1,500 points)
4. 💎 Platinum (3,000 points)
5. 💠 Diamond (5,000 points)
6. ⭐ Master (7,000 points)
7. 🏆 Grandmaster (10,000 points)

**How Rank Score Is Calculated:**
- 40% from reputation score
- 30% from perfect solves
- 20% from multiplayer win rate
- 10% from total puzzles solved (capped to prevent grinding)
- Bonus for skill mastery (maxed skills worth 200 points each)

**Rank Promotion Rewards:**
- Silver: 50 tokens
- Gold: 100 tokens
- Platinum: 200 tokens
- Diamond: 350 tokens
- Master: 500 tokens
- Grandmaster: 1000 tokens

**File:** [lib/services/rank_progression_service.dart](lib/services/rank_progression_service.dart)

---

### 5. Skill Mastery System

Track mastery across different puzzle categories.

**Skill Categories:**
- Logic & Reasoning
- Cryptography
- Algebra
- Set Theory
- Pattern Recognition
- Mathematics

**How Skills Level Up:**
- Each puzzle solved grants XP to relevant skill
- XP varies by difficulty: 5-25 base XP
- Perfect solves grant 2x XP
- No hints used grants 1.5x XP
- Diminishing returns at high levels (50+)
- Max level: 100

**Benefits:**
- Contributes to rank score
- Visual progression display
- Achievement tracking
- Unlock special challenges (future feature)

**File:** [lib/services/rank_progression_service.dart](lib/services/rank_progression_service.dart#L66-L120)

---

### 6. Daily & Weekly Quests

Short-term goals to keep users engaged.

**Quest Types:**

**Daily Quests (3 per day):**
- Solve 3 puzzles
- Get 1 perfect solve
- Solve without hints
- Play 1 multiplayer match
- Earn 50 tokens

**Weekly Quests:**
- Solve 15 puzzles
- Win 5 multiplayer matches
- Maintain 7-day streak
- Earn 500 tokens

**Quest Rewards:**
- Tokens: 20-100
- Reputation: 10-50
- Free answers: 0-2

**Quest Generation:**
- Randomized daily using date as seed
- Consistent for all users on same day
- Automatic reset at midnight
- Progress tracked automatically

**Files:**
- Model: [lib/models/quest.dart](lib/models/quest.dart)
- UI: [lib/widgets/quest_widget.dart](lib/widgets/quest_widget.dart)

---

### 7. Puzzle Randomization

Prevents boredom by giving each user unique puzzle variations.

**How It Works:**
- Uses userId + date + puzzleId as random seed
- Each user sees different variations
- Same user sees consistent puzzle on same day
- Solution logic remains the same

**Randomized Elements by Puzzle Type:**

**Sequence Completion:**
- Fibonacci: Random starting numbers (1-5), hide random position
- Geometric: Random start (1-5), random multiplier (2-4)
- Prime Numbers: Different starting position in prime sequence
- Perfect Squares: Different starting number (1-5)

**Cryptography:**
- Caesar Cipher: 8 different words, shift varies (3-15)
- Different encrypted messages each time

**Algebra:**
- Linear equations with random coefficients
- Variable x values: 1-10
- Constants: -10 to 9

**Set Theory:**
- Random sets with 4-7 elements
- Controlled overlap (30% chance per element)
- Numbers 1-20

**File:** [lib/services/puzzle_randomizer.dart](lib/services/puzzle_randomizer.dart)

---

### 8. Multiplayer System

Play against other learners in real-time.

**Game Modes:**
- Quick Match: Fast 1v1 random matchmaking
- Ranked: Competitive with ELO rating
- Friendly: Play with friends
- Tournament: Special events (future)

**How Multiplayer Works:**
1. User joins matchmaking queue
2. System pairs users with similar ratings
3. Both players solve the same puzzle
4. First to solve correctly wins
5. Points awarded for speed + accuracy - hints

**Scoring System:**
- Base: 1000 points
- Speed bonus: Up to 500 points (faster = more)
- Hint penalty: -100 per hint
- Difficulty multiplier: 1.0x - 3.0x

**Rewards:**
- Winner: 2x answer reveal cost in tokens
- Loser: 1x answer reveal cost (participation)
- Rating changes based on opponent strength
- Win rate tracked for titles

**Status:**
- Models implemented
- Backend integration needed
- UI pending

**File:** [lib/models/multiplayer_game.dart](lib/models/multiplayer_game.dart)

---

## 📱 User Interface Components

### Profile Screen

Displays comprehensive user information:
- Avatar with selection modal
- Title and rank badges
- Token, streak, and reputation stats
- Rank progress bar
- Skill mastery bars
- Multiplayer statistics

**File:** [lib/screens/profile_screen.dart](lib/screens/profile_screen.dart)

### Answer Reveal Dialog

Allows users to purchase answers with tokens:
- Shows cost vs. current balance
- Highlights free answers if available
- Shows remaining balance after purchase
- Clear insufficient funds messaging
- Streak reward integration

**File:** [lib/widgets/answer_reveal_dialog.dart](lib/widgets/answer_reveal_dialog.dart)

### Quest Widgets

Display daily and weekly quests:
- Progress bars for each quest
- Reward display (tokens, reputation, free answers)
- Completion status
- Auto-reset daily

**File:** [lib/widgets/quest_widget.dart](lib/widgets/quest_widget.dart)

### Streak Notification

Celebrates daily streaks:
- Animated flame icon
- Different styles for 5+ day streaks
- Reward breakdown display
- Special "on fire" status
- Compact home screen widget

**File:** [lib/widgets/streak_notification.dart](lib/widgets/streak_notification.dart)

---

## 🔧 Integration Service

Central service coordinating all engagement features.

**Functions:**
- `processLogin()`: Handle daily login, streaks, quest resets
- `processPuzzleCompletion()`: Award tokens, update skills, check promotions
- `getRandomizedPuzzle()`: Get personalized puzzle variation
- `generateDailyQuests()`: Create daily quest list
- `checkFreeAnswersExpiry()`: Validate free answer rewards

**Returns:**
- Updated user profile
- Rank promotions
- Title promotions
- Completed quests
- All achievements in one call

**File:** [lib/services/engagement_service.dart](lib/services/engagement_service.dart)

---

## 📊 Data Models

### UserProfile

Comprehensive user profile with all engagement data:

```dart
class UserProfile {
  // Identity
  final String userId;
  final String displayName;
  final AvatarType avatar;
  final UserTitle title;
  final SkillRank rank;

  // Token System
  final int tokens;
  final int lifetimeTokensEarned;
  final int tokensSpent;

  // Streak System
  final int currentStreak;
  final int longestStreak;
  final List<DateTime> playHistory;

  // Free Answer Rewards
  final int freeAnswersAvailable;
  final DateTime? freeAnswersExpiryDate;

  // Skills & Mastery
  final Map<String, int> skillLevels;
  final int reputationScore;
  final int totalPuzzlesSolved;
  final int perfectSolves;

  // Quests
  final Map<String, bool> dailyQuests;
  final Map<String, int> weeklyGoals;

  // Multiplayer
  final int multiplayerWins;
  final int multiplayerGamesPlayed;
  final double winRate;
}
```

**File:** [lib/models/user_profile.dart](lib/models/user_profile.dart)

---

## 🎯 Implementation Status

### ✅ Completed

- [x] Token system (earning and spending)
- [x] Daily streak tracking with rewards
- [x] Unpredictable streak rewards (2-4 days)
- [x] 5-day streak milestone with free answers
- [x] Custom avatar system (8 types)
- [x] Title progression (6 levels)
- [x] Skill-based rank system (7 tiers)
- [x] Skill mastery tracking
- [x] Quest models and generation
- [x] Puzzle randomization
- [x] Multiplayer game models
- [x] Answer reveal UI
- [x] Profile screen UI
- [x] Quest widgets
- [x] Streak notifications
- [x] Integration service

### 🚧 Needs Integration

- [ ] Connect to existing GameStateProvider
- [ ] Integrate with existing UserProgress model
- [ ] Add profile screen to navigation
- [ ] Add answer reveal button to puzzle screen
- [ ] Add quest panel to home screen
- [ ] Add streak widget to home screen
- [ ] Hook up login flow to process streaks
- [ ] Hook up puzzle completion to engagement service

### 📋 Backend Required

- [ ] Multiplayer matchmaking backend
- [ ] Real-time game state synchronization
- [ ] Leaderboards
- [ ] User authentication
- [ ] Cloud profile sync
- [ ] Quest progress sync
- [ ] Rating/ELO system

---

## 🚀 Next Steps

### Immediate (Integration)

1. **Merge with existing codebase:**
   - Extend UserProgress or replace with UserProfile
   - Connect EngagementService to GameStateProvider
   - Add new screens to routing

2. **Add UI elements:**
   - Profile icon in app bar
   - Answer reveal button in puzzle screen
   - Quest panel in home screen
   - Streak widget in home screen

3. **Test flow:**
   - Login → streak check → notification
   - Puzzle solve → token award → quest update
   - Answer reveal → token deduction

### Short-term (Enhancement)

1. **Animations:**
   - Streak flame animation
   - Rank promotion celebration
   - Quest completion effects
   - Token earn/spend animations

2. **Persistence:**
   - Save UserProfile to local storage
   - Track quest progress locally
   - Cache multiplayer matches

3. **Tutorial:**
   - Explain token system
   - Show streak benefits
   - Introduce quests

### Long-term (Multiplayer)

1. **Backend setup:**
   - Firebase Realtime Database or custom backend
   - WebSocket connections for real-time play
   - Matchmaking queue system
   - Rating calculation

2. **Multiplayer UI:**
   - Matchmaking screen
   - Game lobby
   - Live match interface
   - Results screen

3. **Social features:**
   - Friend system
   - Friend challenges
   - Global leaderboards
   - Spectator mode

---

## 💡 Design Philosophy

### Why These Features?

**Token System:**
- Creates economy and meaningful choices
- Balances challenge with accessibility
- Rewards skill and consistency

**Daily Streaks:**
- Encourages habit formation
- Unpredictable rewards maintain excitement
- 5-day milestone is aspirational but achievable

**Skill-Based Ranks:**
- Performance > time played
- Prevents exploitation
- Clear progression path
- Multiple skill dimensions

**Puzzle Randomization:**
- Prevents memorization
- Each playthrough feels fresh
- Fair for all users (seeded random)

**Multiplayer:**
- Social engagement
- Competitive motivation
- Asymmetric rewards (winner + participation)

**Quests:**
- Short-term goals
- Daily engagement driver
- Variety in objectives

---

## 📈 Expected Impact

### User Retention

**Daily Active Users (DAU):**
- Streaks encourage daily play
- Quest resets create return triggers
- Free answer rewards at 5 days

**Engagement Duration:**
- Multiplayer adds replay value
- Quest completion extends sessions
- Skill progression creates long-term goals

**Monetization Potential:**
- Token purchases (future)
- Premium subscriptions with bonuses
- Cosmetic avatars (future)

### Viral Potential

- Multiplayer creates social pressure
- Leaderboards drive competition
- Shareable achievements
- Friend challenges

---

## 🎨 Visual Design

All UI components follow Dark Academia theme:
- Burgundy (#6B2737)
- Forest Green (#2D5A4A)
- Dark Navy (#1A1F3A)
- Brass (#B8936D)

Special effects:
- Orange/red for fire streaks (5+ days)
- Gold for special rewards
- Green for success states
- Red for warnings

---

## 🔐 Privacy & Fair Play

### User Data

- Avatars are local customization only
- Display names are user-controlled
- No real identity required
- Multiplayer uses anonymous IDs

### Anti-Cheating

- Puzzle randomization prevents answer sharing
- Server-side validation (when backend added)
- Rate limiting on token earning
- Streak validation with timestamps

### Fair Progression

- Ranks based on skill, not time
- Multiple paths to advancement
- Diminishing returns prevent grinding
- Balanced token economy

---

## 📚 References

All feature files:
- Models: `/lib/models/`
- Services: `/lib/services/`
- Widgets: `/lib/widgets/`
- Screens: `/lib/screens/`

Documentation:
- [FEATURES.md](FEATURES.md) - Original feature list
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Project overview
- [DEVELOPMENT.md](DEVELOPMENT.md) - Development guide

---

**Last Updated:** December 2024
**Version:** 2.0.0
**Status:** Core features implemented, integration pending
