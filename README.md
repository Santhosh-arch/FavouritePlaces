# Favourite Places

A flutter app to save your favourite places.

# Features
* Add places with Image from Gallery or Camera
* You can add your current location or select location from map 
* You can Delete and Update the places you have already saved
* Your data is persisted across app restarts with the help of sqflite

# Screenshots
![](/screenshots/1.jpg)
![](/screenshots/2.jpg)
![](/screenshots/3.jpg)
![](/screenshots/4.jpg)
![](/screenshots/5.jpg)
![](/screenshots/6.jpg)
![](/screenshots/7.jpg)
# Video
![](/screenshots/8.jpg)

# Packages Used
* image_picker for picking image from Gallery or Camera
* location for get user current location from device GPS
* http for making api call to Google Maps Api for map image and address from lat/lng
* google_maps_flutter for selecting location from map
* sqflite for data persistence
* flutter_riverpod for state management
* path_provider & path for handling file storage path
* flutter_launcher_icons fro generating app icons

# To Run
* To run this project, you need to have Flutter installed on your machine.
* Clone this repo to your machine: git clone
* Run flutter pub get to install dependencies
* In config.dart file replace "YOUR KEY HERE" with your Google maps Api key
* In AndroidManefest.xml replace "YOUR KEY HERE" with your Google maps Api key
* Launch the app using flutter run or F5 in VSCode

# Last Tested Using
Flutter 3.24
OpenJdk 17(Android Studio Koala)

## Attributions
<a href="https://www.flaticon.com/free-icons/places" title="places icons">Places icons created by srip - Flaticon</a>