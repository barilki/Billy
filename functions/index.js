import * as functions from 'firebase-functions';                // The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
import * as admin from 'firebase-admin';                        // The Firebase Admin SDK to access the Firebase Firestore Database.

admin.initializeApp(functions.config().firebase);               //this will initialize the firebase app 
//here notification is the collection id
//{notification_id} is the Id of Each notification
exports.sendNotification = functions.firestore.document('users/{users_id}').onWrite(event=>{


    const title=event.after.get('title')                            //retrive the title
    const body=event.after.get('body')                              //retrive body

    //create payload regarding notification details
    const payload={                                 //here we create payload as a const
        notification:{
            title:title,                            //assign title in payload title
            body:body                               //assign body in payload title
        }
    }

    //create topics
    const topics = "notification"

    //send notification with the help of FCM using topic 
    //.sendToTopic(topics, payload) need 2 parameters 
    //1st is topic: we used topic here is constant, but in real app we use mostly topic as a 
    //subscription/follow model. like who follow will only get notified
    //2nd is payload: this is just like sending an extra detail of the message
    return admin.messaging().sendToTopic(topics,payload).then(res=>{              
    console.log('notification sent ')                   //if notification is deliverd then "notification sent is displayed in the log files"
    }).catch(err=>{                                     //catch error here
    console.log('notification sent '+err)            //if notification is failed then "notification err is displayed in the log files"
    })

})