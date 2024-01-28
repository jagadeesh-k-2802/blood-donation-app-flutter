const { createServer } = require('http');
const dotenv = require('dotenv');
const colors = require('colors');

// Config
dotenv.config({ path: './config/config.env' });

const app = require('./app');
const connectDB = require('./config/db')();

const PORT = process.env.PORT || 3000;
const httpServer = createServer(app);

// Express Server
const server = httpServer.listen(PORT, () => {
  console.log(`Server Running On Port -> ${PORT}`.yellow.underline);
});

// Promise rejection is taken seriously
process.on('unhandledRejection', reason => {
  console.log(`unhandledRejection ${reason}`.red);
  server.close(() => process.exit(1));
});
