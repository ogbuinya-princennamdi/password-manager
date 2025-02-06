const otpService = require("../services/otp.service");

exports.otpLogin = (req, res, next) => {
    console.log("otpLogin called with body:", req.Support);

    // If the request body contains a query field
    const requestBody = req.body.query ? JSON.parse(req.body.query) : req.body;

    // Validate request body
    if (!requestBody || !requestBody.email) {
        console.error("Invalid request body:", requestBody);
        return res.status(400).send({
            message: "error",
            data: "Invalid parameters: email is required."
        });
    }

    const params = { email: requestBody.email };

    otpService.sendOtp(params, (error, results) => {
        if (error) {
            console.error("Error sending OTP:", error);
            return res.status(400).send({
                message: "error",
                data: error,
            });
        }
        return res.status(200).send({
            message: "success",
            data: results,
        });
    });
};
//send support controller
exports.sendSupport = (req, res, next) => {
    console.log("Sending support message called:", req.support);

    // Extract the request body and handle parsing
    const requestBody = req.body.query ? JSON.parse(req.body.query) : req.body;

    // Validate request body
    if (!requestBody || !requestBody.email || !requestBody.support) {
        console.error("Invalid request body:", requestBody);
        return res.status(400).send({
            message: "Invalid parameters: Email and support message are required",
            data: null
        });
    }

    const params = {
        email: requestBody.email,
        support: requestBody.support
    };

    // Call the service to send the support message
    otpService.sendSupportMessage(params, (error, results) => {
        if (error) {
            console.error("Error sending support message:", error);
            return res.status(400).send({
                message: "Error sending support message",
                data: error
            });
        }
        return res.status(200).send({
            message: "Success",
            data: results
        });
    });
};


// Verifying OTP
exports.otpVerify = (req, res, next) => {
    console.log("otpVerify called with body:", req.body);

    // Validate request body
    if (!req.body || !req.body.hash || !req.body.email || !req.body.otp) {
        console.error("Invalid request body:", req.body);
        return res.status(400).send({
            message: "error",
            data: "Invalid parameters: email, hash, and otp are required."
        });
    }

    otpService.verifyOTP(req.body, (error, results) => {
        if (error) {
            console.error("Error verifying OTP:", error);
            return res.status(400).send({
                message: "error",
                data: error,
            });
        }
        return res.status(200).send({
            message: "success",
            data: results,
        });
    });
};
