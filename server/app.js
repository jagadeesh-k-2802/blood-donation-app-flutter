const express = require('express');
const path = require('path');
const morgan = require('morgan');

const authRoutes = require('./routes/auth');
const errorHandler = require('./middlewares/error');

const app = express();

// Middlewares
app.use(morgan('dev'));
app.use(express.json({ limit: '10kb' }));
app.use(express.static(path.join(__dirname, 'public')));

// Routes
app.use('/api/v1/auth', authRoutes);

// Error Handler
app.use(errorHandler);

module.exports = app;
