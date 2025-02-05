var nodemailer= require('nodemailer');


async function sendEmail(params, callback) {
    const transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 587,
        secure: false,
        auth: {
            user: 'litmaclimited@gmail.com',
            pass: 'tjyo ejxf zvdg idbu'
        }
    });

    const mailOptions = {
        from: 'litmaclimited@gmail.com',
        to: params.email,
        subject: 'Your OTP',
        text: params.body,
    };

    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            console.error("Error sending email:", error);
            return callback(error, null);
        }
        console.log("Email sent successfully:", info);
        return callback(null, info);
    });
}

async function UsersSubmitForm( params, callback){
const transporter =nodemailer.createTransport({
host: 'smtp.gmail.com',
port:587,
secure:false,
auth: {
            user: 'litmaclimited@gmail.com',
            pass: 'tjyo ejxf zvdg idbu'
        }

});
  const mailOptions={
  from:'litmaclimited@gmail.com',
  to: 'litmaclimited@gmail.com',
  subject: 'KinApp: Users support',
  text: params.support,
  replyTo: params.email
  };

  transporter.sendMail(mailOptions,( error, info)=>{
  if(error){
  console.error('Error submitting form:', error);
  return callback(error, null);

  }
  console.info('Form submitted succesfully:', info);
  return callback(null,info)
  });
}

module.exports={
sendEmail,
UsersSubmitForm

}