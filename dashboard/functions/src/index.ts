import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const fcm = admin.messaging();

function formatTime(timestamp: FirebaseFirestore.Timestamp) {
  const time = timestamp.toDate();
  const now = new Date();
  const daysDiff = Math.floor((now.getTime() - time.getTime()) / 86400000);

  const timeString =
    ', ' +
    time.getHours() +
    ':' +
    time
      .getMinutes()
      .toString()
      .padStart(2, '0');

  if (now.getFullYear() == time.getFullYear()) {
    if (now.getMonth() == time.getMonth() && now.getDate() == time.getDate()) {
      return 'Heute' + timeString;
    } else if (daysDiff < 2) {
      return 'Gestern' + timeString;
    }
  }

  return 'vor ' + daysDiff + ' Tagen' + timeString;
}

export const sendNotifications = functions.firestore
  .document('news/{newsId}')
  .onCreate(async snapshot => {
    const news = snapshot.data() as any;
    const payload = {
      notification: {
        title: news.title,
        body: news.content.length > 120 ? news.content.substring(0, 120) + '...' : news.content,
      },
      data: {
        title: news.title,
        content: news.content,
        time: formatTime(news.time),
      },
      android: {
        ttl: 3 * 24 * 60 * 60,
        notification: {
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
      },
      topic: "news",
    };

    return fcm.send(payload);
  });
