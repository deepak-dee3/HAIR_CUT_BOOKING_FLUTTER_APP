/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Import necessary modules
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Firebase Admin
admin.initializeApp();

// Define the Cloud Function for Firestore trigger
exports.sendNotification = functions.firestore
    .document('{date}/{timeSlot}')
    .onUpdate((change, context) => {
        const afterData = change.after.data();
        const beforeData = change.before.data();

        // Check for a new "Requested" seat booking
        if (JSON.stringify(afterData.seats) !== JSON.stringify(beforeData.seats)) {
            const newBooking = afterData.seats.find(
                (seat, index) => seat.status === "Requested" && beforeData.seats[index]?.status !== "Requested"
            );

            if (newBooking) {
                // Prepare the notification payload
                const payload = {
                    notification: {
                        title: 'New Seat Booking Request',
                        body: `Seat ${newBooking.index + 1} has been requested.`,
                    },
                    data: {
                        seatNumber: `${newBooking.index + 1}`,
                        customerName: newBooking.name,
                    },
                };

                // Replace <Admin_Device_Token> with the token from Firestore
                const adminToken = '<Admin_Device_Token>'; // Update this!
                return admin.messaging().sendToDevice(adminToken, payload)
                    .then(response => {
                        console.log('Notification sent successfully:', response);
                    })
                    .catch(error => {
                        console.error('Error sending notification:', error);
                    });
            }
        }
        return null;
    });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
