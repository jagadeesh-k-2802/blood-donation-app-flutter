const nodemailer = require('nodemailer');
const ejs = require('ejs');
const { htmlToText } = require('html-to-text');

class Email {
  constructor(user, data) {
    this.name = user.name;
    this.to = user.email;
    this.data = data;
    this.from = `Blood Donation <noreply@blood-donation.com>`;
  }

  _newTransport() {
    if (process.env.NODE_ENV === 'production') {
      // Sendgrid
      return nodemailer.createTransport({
        service: 'SendGrid',
        auth: {
          user: process.env.SENDGRID_USERNAME,
          pass: process.env.SENDGRID_PASSWORD
        }
      });
    }

    // MailTrap
    return nodemailer.createTransport({
      host: process.env.EMAIL_HOST,
      port: process.env.EMAIL_PORT,
      auth: {
        user: process.env.EMAIL_USERNAME,
        pass: process.env.EMAIL_PASSWORD
      }
    });
  }

  // Send the actual email
  async _send(template, subject) {
    const path = `${__dirname}/../templates/${template}.ejs`;
    const data = { name: this.name, ...this.data };
    const html = await ejs.renderFile(path, data);

    const mailOptions = {
      from: this.from,
      to: this.to,
      subject,
      html,
      text: htmlToText(html)
    };

    await this._newTransport().sendMail(mailOptions);
  }

  // Methods to send different mails
  async sendWelcome() {
    await this._send('welcome', 'Welcome To Blood Donation App');
  }

  async sendPasswordReset() {
    await this._send('password-reset', 'Blood Donation - Password Reset');
  }
}

module.exports = Email;
