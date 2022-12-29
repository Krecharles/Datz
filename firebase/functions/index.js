// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

// exports.helloWorld = functions
//   .region("europe-west3")
//   .https.onRequest((request, response) => {
//     functions.logger.info("Hello logs!", { structuredData: true });
//     response.send("Hello from Firebase!");
//   });

// // Take the text parameter passed to this HTTP endpoint and insert it into

// // Firestore under the path /messages/:documentId/original
// exports.addMessage = functions
//   .region("europe-west3")
//   .https.onRequest(async (req, res) => {
//     // Grab the text parameter.
//     const original = req.query.text;
//     original = "test_message_12345678";
//     // Push the new message into Firestore using the Firebase Admin SDK.
//     const writeResult = await admin
//       .firestore()
//       .collection("messages")
//       .add({ original: original });
//     // Send back a message that we've successfully written the message
//     res.json({ result: `Message with ID: ${writeResult.id} added.` });
//   });

exports.addModifiedClassModel = functions
  .region("europe-west3")
  .https.onCall((data, _) => {
    let d = data.toString();
    functions.logger.info("Got class: ", d);
    admin.firestore().collection("modifiedClassModels").add({ data: d });
  });

exports.addMissingClassModel = functions
  .region("europe-west3")
  .https.onCall((data, _) => {
    let d = data.toString();
    functions.logger.info("Got class: ", d);
    admin.firestore().collection("missingClassModels").add({ data: d });
  });
