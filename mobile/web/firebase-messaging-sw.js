importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyDILRY8Ir97a_kGzIGZc73RzSP0S4HLRsI",
  authDomain: "mensajeria-corporativa.firebaseapp.com",
  projectId: "mensajeria-corporativa",
  storageBucket: "mensajeria-corporativa.firebasestorage.app",
  messagingSenderId: "109948491316",
  appId: "1:109948491316:web:3bd6c4ce78b31623f5dc61",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const { title, body } = payload.notification ?? {};
  self.registration.showNotification(title ?? '', {
    body: body ?? '',
    icon: '/icons/Icon-192.png',
  });
});