
# WikiBridge

A simple iOS app that fetches a list of locations and opens them
in the Wikipedia app using deep linking.

## Demo

### Happy Path

Fetch locations from the remote endpoint and open the selected location directly in Wikipedia's Places tab.

<p align="center">
  <img src="Screenshots/HappyFlow.gif" width="300" />
</p>

### No Internet Connection

Graceful handling when the locations endpoint is unavailable or the device has no internet connection.

<p align="center">
  <img src="Screenshots/NoInternetConnection.gif" width="300" />
</p>

### Wikipedia App Not Installed

If the Wikipedia app is not installed, the user receives a clear error message instead of a failed deep link.

<p align="center">
  <img src="Screenshots/NoWikipediaAppInstalled.gif" width="300" />
</p>


## What it does

- Fetches locations from a remote JSON endpoint
- Shows them in a list
- Tapping a location opens the Wikipedia app at that
  coordinate (Places tab)
- There's also a screen where you can type custom lat/lon
  and open Wikipedia there

## Architecture

I went with a clean architecture approach, split into two
local Swift packages:

- **Domain** - entities, use cases, protocols.
  No dependencies on UIKit or any framework.
- **Infrastructure** - networking (URLSession),
  deep link construction, the actual Wikipedia URL opener.
- **WikiBridge (app target)** - SwiftUI views, view models,
  coordinator, composition root.

The navigation is handled by a Coordinator that uses
UINavigationController under the hood. The views are all
SwiftUI, wrapped in UIHostingController.

I prefer this approach for anything beyond simple navigation.
In my experience NavigationStack with path bindings breaks
down when the navigation graph gets deep or complex.
UIKit navigation is more predictable, easier to debug,
and more production-ready when you're dealing with things
like conditional flows, deep linking, or presenting alerts
outside of the view hierarchy. It's the pattern I use in
real projects.

## Wikipedia fork

The Wikipedia app needs to be modified to accept a deep link
that navigates to Places with specific coordinates.
My fork is here:

https://github.com/ugur112358/wikipedia-ios

The deep link format I used is:

`wikipedia://places?lat=52.3676&lon=4.9041`

To test the full flow you need to install the modified
Wikipedia app on the same simulator/device.

## How to run

1. Open `WikiBridge.xcodeproj` in Xcode 26, Swift 5.9
2. The Swift packages should resolve automatically
3. Run on iOS 17.6+ simulator
4. If you want the Wikipedia deep link to actually work,
   install the forked Wikipedia app first

## Things I'd do differently with more time

- Add snapshot/UI tests
- Better error handling for the deep link
  (right now if Wikipedia isn't installed you just get an alert)
- Maybe add a map view for the custom coordinates screen
  so you can see where you're pointing
- The localization setup is there but I only did English,
  would add Dutch if this were real
- Caching for the locations response

## Testing

Unit tests cover:

- Coordinate validation
- Use cases (fetch locations, open location)
- Remote loader (success, failure, invalid JSON,
  invalid coordinates filtered out)
- Wikipedia URL construction
- ViewModels (state transitions, error mapping, callbacks)

Run tests with Cmd+U.

There's a workaround in CustomCoordinatesViewModelTests
where I use `await MainActor.run {}` instead of marking the
whole class @MainActor. This is because of a runtime crash
on the iOS 26 simulator running on macOS 15.7.

## Dependencies

None. Everything is built with standard Apple frameworks
(Foundation, SwiftUI, UIKit for navigation).

## Project structure

WikiBridge/
  App/           - AppDelegate, SceneDelegate, AppCoordinator
  Presentation/  - Views, ViewModels, Coordinator
  Adapters/      - UIApplication URL opener wrapper
  Localization/  - L10n strings helper

Packages/
  Domain/        - Entities, use cases, protocols
  Infrastructure/- HTTP client, remote loader, Wikipedia opener
