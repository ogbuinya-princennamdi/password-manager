const optGenerator = require("otp-generator");
const crypto = require("crypto");
const key = 'test1234';
const emailServices = require("../services/emailer.service");


async function sendOtp(params, callback) {
    console.log("sendOtp called with params:", params);

    // Validate parameters
    if (!params || !params.email) {
        console.error("Invalid parameters:", params);
        return callback("Invalid parameters: email is required.");
    }

    const otp = optGenerator.generate(6, {
         digits: true,
         upperCaseAlphabets: false,
         specialChars:false,
         lowerCaseAlphabets:false,


    });
    const ttl = 5 * 60 * 1000; // Time to live (TTL) in milliseconds
    const expires = Date.now() + ttl;
    const data = `${params.email}.${otp}.${expires}`;
    const hash = crypto.createHmac("sha256", key).update(data).digest("hex");
    const fullHash = `${hash}.${expires}`;
    const otpMessage = `Dear customer, ${otp} is your OTP to login to your password manager app`;

    const model = {
        email: params.email,
        subject: "Verification OTP",
        body: otpMessage,
        html: true
    };

    emailServices.sendEmail(model, (error, result) => {
        if (error) {
            console.error("Error sending email:", error);
            return callback(`Error sending email: ${error.message || error}`);
        } else {
            console.log("Email sent successfully:", result);
            return callback(null, fullHash);
        }
    });
}
//function send message
async function sendSupportMessage(params, callback) {
    console.log("Sending support called with:", params);

    // Validate parameters
    if (!params || !params.email || !params.support) {
        console.log("Invalid parameters provided:", params);
        return callback("Invalid parameters: Email and support message are required.");
    }

    // Prepare the email model
    const model = {
        email: params.email,
        subject: "User Support Message",
        support: params.support,  // Use the support message from params
        html: true
    };

    // Send the email
    emailServices.UsersSubmitForm(model, (error, result) => {
        if (error) {
            console.log("Error sending support:", error);
            return callback(`Error sending email: ${error.message || error}`);
        } else {
            console.log("Support sent successfully:", result);
            return callback(null, result); // Use result instead of fullHash
        }
    });
}


async function verifyOTP(params, callback) {
    console.log("verifyOTP called with params:", params);

    // Validate parameters
    if (!params || !params.hash || !params.email || !params.otp) {
        console.error("Invalid parameters:", params);
        return callback("Invalid parameters: email, hash, and otp are required.");
    }

    let [HashValue, expires] = params.hash.split('.');
    expires = parseInt(expires);  

    let now = Date.now();
    if (now > expires) {
        console.warn("OTP expired for email:", params.email);
        return callback("OTP Expired");
    }

    let data = `${params.email}.${params.otp}.${expires}`;
    let newCalculatedHash = crypto.createHmac("sha256", key).update(data).digest('hex');

    if (newCalculatedHash === HashValue) {
        console.log("OTP verified successfully for email:", params.email);
        return callback(null, "success");
    } else {
        console.warn("Invalid OTP attempt for email:", params.email);
        return callback("invalid OTP");
    }
}

module.exports = {
    sendOtp,
    sendSupportMessage,
    verifyOTP
};
