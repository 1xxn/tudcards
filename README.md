# tudcards

![Swift](https://img.shields.io/badge/-Swift-FA7343?style=flat-square&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/-SwiftUI-black?style=flat-square&logo=swift&logoColor=white)
![MVVM](https://img.shields.io/badge/-MVVM-blue?style=flat-square)


tudcards is an iOS flashcards app built with SwiftUI and follows the MVVM design pattern. It allows users to create categories and flashcards within those categories to study. The app also includes a remix mode that shuffles the flashcards for a more challenging study experience.

## Features

- Create, update, and delete categories
- Create and delete flashcards within categories
- Flashcard remix mode for shuffled studying
- Mark flashcards as correct or incorrect
- View high scores
- Generate flashcards using OpenAI's GPT-3

## Classes

- `CategoryListView`: Displays a list of all categories. Users can create, update, and delete categories.
- `FlashcardListView`: Displays a list of all flashcards within a selected category. Users can create and delete flashcards.
- `FlashcardDetailView`: Displays the details of a selected flashcard. Users can mark flashcards as correct or incorrect.
- `ChatView`: Allows users to generate flashcards using OpenAI's GPT-3.
- `FlashcardRemixView`: Displays flashcards in a shuffled order for a more challenging study experience.
- `HighscoreView`: Displays the high scores for each category.
- `CategoryViewModel`: Manages the data and business logic for the categories and flashcards.
- `OpenAIService`: Handles the interaction with OpenAI's GPT-3 to generate flashcards.

## Dependencies

- SwiftUI: Used to build the user interface.
- Combine: Used for handling asynchronous events.
- OpenAI's GPT-3: Used to generate flashcards.
- GPTSwift: Wrapper around OpenAI API (https://github.com/SwiftedMind/GPTSwift)

## Installation

- Clone the GitHub repository and open the project in Xcode.
git clone https://github.com/username/tudcards.git
cd tudcards
open tudcards.xcodeproj

## Usage

- Run the app on an iOS simulator or a physical device running iOS 15.0 or later.

## Contributing

- Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
