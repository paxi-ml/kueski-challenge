# kueski-challenge
Challenge project for Kueski hiring process

# Project Setup

1. Install Pods using `pod install`


# Project Structure
Each project may have different requirements, features, estimated codebase growth, team size, etc. Based on this we can select an appropriate project structure, in general terms what we need is to separate the different semantic layers with an architectural pattern, may it be MVC, MVVM or VIPER. We'll start with a 3 layer approach as MVC and MVVM to avoid overcomplication.
An important point based on experience is that navigating between viewmodel or controllers and views can be confusing and troublesome, which leads to having views in the controllers or viceversa. A nice solution is to have groups per app sections (some experts call this modules, but it can be adjusted to features or any functional unit in the app).
Within each module or functional unit we will have Views and Controllers separated, so organized and easy accessible.
Networking can be discussed since in MVC it can be added to the model, is the way I like to arrange it and also how WWDC has recommended it in the past, however VIPER puts it with business logic in the Interactor. This differences has lead some mobile experts to start adding a new layer at root level for Services, however I still believe networking are only populating our model and should belong there.
Also I'm leaving some placeholders for sections that are usually needed, like Utilities for Extensions or any other Utilitary class that is not specific to our business. Resources for any asset catalogs, plist, etc.
Real projects have a lot more complexity but I believe for now I have shared a pretty good summary of my perspective.

# Functional Requirements

● As a User I should be able to list the most popular movies.
● As a User I should be able to list the now playing movies.
● As a User I should see the option to change between a list and a grid view.
● As a User I should see the different possible errors (error handling).
● As a User I should be able to see for each movie the following details :
○ Name
○ Poster
○ Genres
○ Overview
○ Popularity
○ Release date
○ Languages
○ Vote average
○ Status
● As a User I should be able to save my favorite movies and I want to see my
stored preferences when I open the app again.
● As a User I should be able to keep scrolling and new results should appear
(pagination).
● [BONUS] As a User I should see a movie sorting feature (by date or name).
