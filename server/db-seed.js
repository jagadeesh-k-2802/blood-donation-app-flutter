const colors = require('colors');
const dotenv = require('dotenv');
const User = require('./models/User');
const BloodRequest = require('./models/BloodRequest');
const Notification = require('./models/Notification');
const Rating = require('./models/Rating');

// Config
dotenv.config({ path: './config/config.env' });
const connectDB = require('./config/db')();

// 123456 is Hashed
const password = '$2y$10$g1uK3U9fkeyq0G348s7PF.rvLDo/1mAzW08Pkl24a0GSfhsjyDMw6';

const init = async () => {
  try {
    switch (process.argv[2]) {
      case '--seed':
        // Create User One
        const userOne = await User.create({
          name: 'User One',
          email: 'user.one@mail.com',
          phone: '1234567890',
          password,
          bloodType: 'B Positive (B+)',
          address: '1275 Connecticut St San Francisco 94107 United States',
          locationCoordinates: {
            type: 'Point',
            coordinates: [-122.395975, 37.7501383]
          }
        });

        // Create User Two
        await User.create({
          name: 'User Two',
          email: 'user.two@mail.com',
          phone: '1432567890',
          password,
          bloodType: 'A Positive (A+)',
          address: '1275 Connecticut St San Francisco 94107 United States',
          locationCoordinates: {
            type: 'Point',
            coordinates: [-123.395975, 38.7501383]
          }
        });

        // Create Blood Request from User One
        await BloodRequest.create({
          patientName: 'Patient One',
          age: '25',
          bloodType: 'O Negative (O-)',
          status: 'active',
          location: '1275 Connecticut St  San Francisco 94107 United States',
          locationCoordinates: {
            type: 'Point',
            coordinates: [-122.395975, 37.7501383]
          },
          contactNumber: '1432567890',
          unitsRequired: 2,
          timeUntil: new Date(Date.now() + 3600 * 1000 * 24), // Next 24 Hours
          notes: 'Sample Note',
          createdBy: userOne.id
        });

        console.log('Seeded Successful'.green);
        break;
      case '--clean':
        await User.deleteMany({});
        await BloodRequest.deleteMany({});
        await Notification.deleteMany({});
        await Rating.deleteMany({});
        console.log('Clean Successful'.green);
        break;
      default:
        console.log('Unrecognized Command'.yellow);
        break;
    }
  } catch (err) {
    console.log(err);
  } finally {
    process.exit(0);
  }
};

init();
