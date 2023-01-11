import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as fs from "fs";

admin.initializeApp();

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

// exports.testingAnalysisFunction = functions
//   .region("europe-west3")
//   .https.onRequest(async (req, res) => {
//     functions.logger.info("testing my analysis function");
//     let snapshot = await admin
//       .firestore()
//       .collection("modifiedClassModels")
//       .get();
//     let data = snapshot.docs.map((doc) => {
//       return JSON.parse(doc.data()["data"]);
//     });
//     console.log(data);
//     fs.writeFile(
//       "modifiedClassModels.json",
//       JSON.stringify(data, null, 2),
//       "utf8",
//       function (err) {
//         if (err) {
//           console.log("An error occured while writing JSON Object to File.");
//           return console.log(err);
//         }

//         console.log("JSON file has been saved.");
//       }
//     );
//     res.send("worked");
//   });
