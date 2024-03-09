# kueski-challenge
Challenge project for Kueski hiring process

# Project Setup

1. Install Pods using `pod install`
2. Add 'Production.xcconfig' to Resources/ folder with content: 
`#include "Pods/Target Support Files/Pods-KueskiChallenge/Pods-KueskiChallenge.release.xcconfig"`
`MOVIE_DB_API_KEY = <KEY>`

# Project Structure
Each project may have different requirements, features, estimated codebase growth, team size, etc. Based on this we can select an appropriate project structure, in general terms what we need is to separate the different semantic layers with an architectural pattern, may it be MVC, MVVM or VIPER. We'll start with a 3 layer approach as MVC and MVVM to avoid overcomplication.
An important point based on experience is that navigating between viewmodel or controllers and views can be confusing and troublesome, which leads to having views in the controllers or viceversa. A nice solution is to have groups per app sections (some experts call this modules, but it can be adjusted to features or any functional unit in the app).
Within each module or functional unit we will have Views and Controllers separated, so organized and easy accessible.
Networking can be discussed since in MVC it can be added to the model, is the way I like to arrange it and also how WWDC has recommended it in the past, however VIPER puts it with business logic in the Interactor. This differences has lead some mobile experts to start adding a new layer at root level for Services, however I still believe networking are only populating our model and should belong there.
Also I'm leaving some placeholders for sections that are usually needed, like Utilities for Extensions or any other Utilitary class that is not specific to our business. Resources for any asset catalogs, plist, etc.
Real projects have a lot more complexity but I believe for now I have shared a pretty good summary of my perspective.

# Test
So far there's not much business logic or complex algorithms for unit tests to be meaningful, and APIs are normally tested in the API itself since unit tests shouldn't have networking (just mocks). I added the parsing which is most of the app and not sure if I'll be implementing the sorting optional but that would be a good candidate for unit tests.
For UI Tests there's a ton of tests we could do, but I just showed some of the basic elements you have to know to do UI tests. Now, analizing the necessity of UI tests is a difficult matter since we have to weight how precise is it gonna be testing the UI, how much effort will we invest and if we're not just building tests to pass them.
Now that we have Now Playing we could do some UI Testing on it, but it'll be the same as testing most popular but after tapping the segmented control, so not for now.


# Kueski Questions

1. How long did you spend on this?
- So far I'd say around 4 hours.

2. Did you complete your implementation?
- Not yet. TBD, still have time till Monday, but my job is taking most of my spare time away from me this week, I'll try to have the missing items this week.

3. What would you have added if you had more time?
- Well it was unnecessary but a better branching model with a pull request template, would have been nice to simulate just to demonstrate the I know we shouldn't be pushing directly to prod, but oh well guess admitting on a real project I would do PRs, release branches, dev branch, etc. will suffice for now.
- I would've spent more time on accessibility, dark mode and voiceover for example.
- I love animations and cool looking UI so I would've spent more time on those. Including maybe adding some gradients.
- Also I would've spent more time checking for code-review-worthy items like variable naming and for every number to be explained, also better documentation on functions, etc.

4. What was the most difficult part of the app?
- Nothing so far, but I believe mobile development is in general pretty straight-forward, it only gets complicated when overcomplicating the UI or very specific scenarios that Apple didn't foresee or support, so basically when dealing with workarounds, but this project is intended to test regular functionality so as expected is really straight-forward.

5. What was your favorite part of the app?
- So far nothing comes to mind since I've already done a lot of MVPs and demos during my career and the most satisfying part of a product is for it to help people, so interview related projects are not that fun. I guess there's always some geeky satisfaction when you load your UI populating remote info, mainly when you load the images, because it's kind of the moment when you built something from scratch, but that's about it.

6. Is there anything else you’d like to add?
Not so far.

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
