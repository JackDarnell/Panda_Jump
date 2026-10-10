# Panda_Jump
A game similar to flappy bird about jumping over boulders as a panda :)

### Background 
Early in highschool I learned how to make iOS apps and I thought it would be fun to make a simple iOS app similar to Flappy Bird. Panda Jump is very simple, just tap the screen to jump over as many boulders as you can and attempt to get a highscore. All of the sprites are either designed by me or some of my friends from Virginia. Lots of inside jokes from when I was in highschool are included in the game for fun. 

### Screenshots
![Screenshots combined from app](https://github.com/JackDarnell/Panda_Jump/assets/16767985/3f31a182-e525-4135-821a-fc316f302480)





### Features
- Currency system where each boulder jumped over gives the player one unit of currency (I picked a random currency symbol on the top right).
- Character selection and purchasing.
- Sound bytes for jumping over boulders and other noises.
- Sprite effects such as fire when a user surpasses their highscore.
- Gamecenter leaderboards to track how you stack up against friends.
- Banner ad at the top using google adsense (not much of a feature but a cool thing I learned).
- Funny/encouraging text pops up when the user successfully jumps over a boulder

### Running it
1. Open `Panda Jump.xcodeproj` in Xcode (CocoaPods is no longer used, so there is no `.xcworkspace`).
2. Xcode downloads the Google Mobile Ads package automatically through Swift Package Manager.
3. Pick an iPhone simulator and press Run. The app targets iOS 16 and later.

To run the automated play-through, choose **Product > Test**: the `Panda JumpUITests` target starts a game, dies, and visits the shop.
The same test runs on GitHub Actions on a macOS runner (`.github/workflows/ios-simulator.yml`) and uploads screenshots as an artifact.

The ad IDs in `Constants.swift` and `Info.plist` are Google's public test IDs. Replace them with your own AdMob IDs before shipping.

### Next Steps
- Get computer running screen working and set it as the game start screen to help users understand how to to play.
- Integrate computer running screen and regular game screen so it is seamless when a user presses to start.

### Known Issues
- Gamecenter needs a paid Apple Developer account and the leaderboard set up in App Store Connect. Without it the leaderboard button shows a sign-in message.
