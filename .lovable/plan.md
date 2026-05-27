## Στόχος
Υλοποίηση των #2 (Daily Rewards + Achievements) και #3 (Juice / Animations + Victory Screen με share) στο `public/game/index.html`.

---

## #2 — Daily Rewards & Achievements

### Daily Login Rewards
- Modal popup την πρώτη φορά που ο παίκτης μπαίνει σε νέα ημέρα.
- Κύκλος 7 ημερών (Day 1 → Day 7), επαναλαμβανόμενος.
- Έπαθλα: coins, ship skins unlock tokens, XP boost.
- Αν χάσει μέρα → reset στο Day 1.
- Αποθήκευση σε `localStorage` (`stellar_daily_v1`).

### Achievements System
~15 achievements σε 3 κατηγορίες:
- **Combat**: First Kill, Sharpshooter (10 ships destroyed), Untouchable (νίκη χωρίς απώλειες)
- **Conquest**: Planet Hunter (κατάκτηση 5/20/50 πλανητών), Strategist (νίκη με όλους τους πλανήτες)
- **Mastery**: First Victory, Veteran (10 νίκες), Online Warrior (5 online νίκες), Speed Runner (νίκη <5 λεπτά)

UI:
- Νέα είσοδος "Achievements" στο main menu με grid από κάρτες (locked/unlocked, progress bar).
- Toast notification όταν ξεκλειδώνει κάποιο in-game.
- Αποθήκευση progress σε `localStorage` (`stellar_achievements_v1`).

---

## #3 — Juice, Animations & Victory Screen

### In-game Juice
- **Screen shake** σε explosions και hits.
- **Particle effects**: explosion particles (16-24 particles, fade out), trail πίσω από κινούμενα σκάφη, sparkle στα captured planets.
- **Hit flash**: άσπρο flash overlay 80ms στο σκάφος που χτυπήθηκε.
- **Smooth ship movement**: tween 250ms μεταξύ tiles αντί για snap.
- **Barrier place animation**: scale-up 200ms + glow pulse.
- **Dice roll**: spinning animation πριν εμφανιστεί το αποτέλεσμα.
- **Sound cues** (πολύ ελαφριά, με Web Audio API oscillators — χωρίς assets): shoot, explosion, capture, victory.

### Victory Screen + Share
Στο τέλος κάθε παιχνιδιού νέο fullscreen modal:
- Confetti / star burst animation.
- "VICTORY" / "DEFEAT" με μεγάλη typography.
- Stats: πλανήτες, σκάφη που χάθηκαν, διάρκεια, XP earned.
- Achievements που ξεκλειδώθηκαν στο match.
- Κουμπιά: **Rematch**, **Share** (Web Share API με fallback σε clipboard copy), **Menu**.
- Share text: "Just conquered the galaxy in Stellar Tactics! 🚀 [score] [link]"

---

## Τεχνικές λεπτομέρειες

- Όλα μέσα στο `public/game/index.html` (single-file game) για να μένει συμβατό με PWA/sw cache.
- Bump `sw.js` σε v4 για cache refresh.
- Νέα modules μέσα στο ίδιο file: `DailyRewards`, `Achievements`, `Juice` (screen shake/particles), `Victory`.
- Particles σε ξεχωριστό overlay canvas πάνω από το game canvas για να μην επιβαρύνει το rendering loop του board.
- Sound με WebAudio (lazy init στο first user gesture).
- Web Share API: `navigator.share` με `navigator.clipboard.writeText` fallback.

---

## Plan execution order
1. Achievements system + UI menu + toast.
2. Daily rewards modal + cycle logic.
3. Particles + screen shake + hit flash.
4. Smooth movement + barrier place anim + dice spin.
5. Sound cues.
6. Victory screen με stats + share.
7. Bump sw.js → v4.