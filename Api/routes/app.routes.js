const otpController = require('../controllers/otp.controller');

const express= require("express");
const router= express.Router();
router.post("/otpLogin", otpController.otpLogin);
router.post("/otp-verify", otpController.otpVerify);
router.post("/sendSupport",otpController.sendSupport);

module.exports=router;
