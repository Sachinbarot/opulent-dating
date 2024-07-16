
package com.opulent.dating;
import android.util.Log;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;


public class MyFirebaseMessagingService extends FirebaseMessagingService {
    private static final String TAG = "MyFirebaseMessagingServ";

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);

        // Handle the message received from Firebase
        Log.d(TAG, "From: " + remoteMessage.getFrom());
        Log.d(TAG, "Notification Message Body: " + remoteMessage.getNotification().getBody());

        // You can customize further handling of the message as per your app's requirements
    }

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);

        // Handle the new FCM token generated for the device
        Log.d(TAG, "Refreshed token: " + token);

        // You can send this token to your server to associate it with the user
    }
}
