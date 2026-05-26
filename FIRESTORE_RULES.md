# Firebase Firestore Security Rules

## ضع هذه القوانين في Firestore Console

اذهب إلى: https://console.firebase.google.com -> blood-bank-2d309 -> Firestore -> Rules

ثم انسخ والصق القوانين التالية:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // السماح بـ read/write للمستخدمين المسجلين فقط
    match /users/{userId} {
      allow read: if request.auth.uid != null;
      allow create: if request.auth.uid == userId;
      allow update, delete: if request.auth.uid == userId;
    }
    
    // السماح بـ write للطلبات الطارئة
    match /emergencyAlerts/{document=**} {
      allow create: if request.auth.uid != null;
      allow read, list: if request.auth.uid != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }
    
    // السماح بـ read للمستشفيات والبنوك
    match /bloodBanks/{document=**} {
      allow read: if request.auth.uid != null;
    }
    
    // السماح بـ read/write للتاريخ
    match /donationHistory/{document=**} {
      allow read, create: if request.auth.uid != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }
  }
}
```

## الخطوات:
1. افتح Firebase Console
2. اختر Firestore Database
3. اذهب إلى Rules tab
4. احذف القوانين الحالية
5. انسخ والصق القوانين أعلاه
6. اضغط Publish
7. حاول مجدداً في التطبيق

---

## ملاحظات مهمة:
- تأكد أنك مسجل دخول في التطبيق قبل محاولة إرسال Emergency Alert
- تأكد من الاتصال بـ Internet
- في حالة الخطأ، جرب تسجيل الخروج والدخول مرة أخرى
