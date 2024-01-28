const mongoose = require('mongoose');

const connectDB = async () => {
  const conn = await mongoose.connect(process.env.MONGO_URI, {
    useUnifiedTopology: true,
    useNewUrlParser: true
  });

  console.log(`MongoDB Connected -> ${conn.connection.host}`.cyan.underline);
};

module.exports = connectDB;
