
const express = require('express');
const otpController = require('../Api/controllers/otp.controller');

const app = express();
app.use(express.json()); // Middleware to parse JSON bodies

// Define your routes
app.post('/otpLogin', otpController.otpLogin);
app.post('/otpVerify', otpController.otpVerify);
app.post('/sendSupport',otpController.sendSupport);

// Start the server
const PORT = process.env.PORT || 4500;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
