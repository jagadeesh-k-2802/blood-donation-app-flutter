# Blood Donation App

Blood Donation Mobile Application built with Flutter, Node.js, Express.js, MongoDB

## Features

- Login/Register Accounts, Forgot Password Feature
- Edit Profile Data with User Uploadable Profile Picture
- Get Blood Request Alerts Around 200 Km Radius Nearby
- Request When Blood is Needed / Donate to Others
- Donation will be Accepted only if Donor is Within Hospital Radius By Verifying GPS Coordinates
- Users can Accept/Reject a Donor & Personal Details are Shared only if Accepted
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

## Screenshots

<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/02ca044d-649a-41a3-87c9-f875969068ec" width="250" />
<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/e8e9ac2c-58bb-49b1-b2f0-35cf7e96d3bd" width="250" />
<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/870d2282-be3c-4eeb-bef5-605cb7648b65" width="250" />
<br />
<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/b4904f2b-e024-4c7e-8d78-d13d179de511" width="250" />
<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/e6beb777-7f4e-4b1a-ac57-22c5bdd208e4" width="250" />
<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/83997f6c-8439-40a8-bafb-95a575e2ccc0" width="250" />
<br />
<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/84b3258f-a278-432a-bf0b-0c4f5e525c85" width="250" />
<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/844c0e89-a03f-42ee-a586-637fc153d202" width="250" />
<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/2529c080-2e1f-4dfa-9dc1-7b0ae51abffd" width="250" />
<br />
<img src="https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/fc2a613f-0193-4490-993c-0dee1e377bf1" width="250" />
<br />

## Screen Record

https://github.com/jagadeesh-k-2802/blood-donation-app-flutter/assets/63912668/422de109-03c5-4a3a-9d7b-26c8f0cda465
