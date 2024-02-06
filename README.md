# Blood Donation App

Blood Donation Mobile Application built with Flutter, Node.js, Express.js, MongoDB

## Features

- Login/Register Accounts, Forgot Password Feature
- Edit Profile Data with User Uploadable Profile Picture
- Get Blood Request Alerts Around 200 Km Radius Nearby
- Request When Blood is Needed / Donate to Others
- Donation will be Completed only if Donator is Within Hospital Radius By Verifying GPS Coordinates
- Blood Requestor can Accept/Reject a Donor & Personal Details are Shared only if Accepted
- Rating System allows to rate and write a review for Donor
- Push Notifications using Firebase

## Running The Application

- `git clone https://github.com/jagadeesh-k-2802/blood-donation-app-flutter`
- `cd server && npm i`
- Configure all required environment variables in `server/config/config.env.example`
- Remove .example from the filename it should be `config.env`
- Install MongoDB Locally on Your System or use Cloud hosted connection string
- Download Firebase Admin Private Key JSON file and rename it it to `firebase-admin.json`
- Place the JSON file inside server/config/
- `npm run dev` to start the node server
- `dart pub global activate flutterfire_cli` Install flutterfire CLI
- `npm install -g firebase-tools` Install firebase CLI using NPM
- `cd mobile && flutterfire configure` Configure firebase using your own firebase project
- open `./mobile` inside your code editor and run flutter app

## Database Seeding
- `cd server`
- `node db-seed.js --seed` This command populates the db with few sample data to get started
- `node db-seed.js --clean` This command will delete everything stored in the database
