const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.cert('./config/firebase-admin.json')
});

module.exports = async ({ title, body, tokens, data = {} }) => {
  try {
    await admin.messaging().sendEachForMulticast({
      notification: { title, body },
      data,
      tokens
    });
  } catch (e) {
    // Do Nothing
  }
};
