# Firebase Firestore Rules - تعليمات تفصيلية

## الخطوة 1: اذهب إلى Firebase Console
- URL: https://console.firebase.google.com
- اختر Project: `blood-bank-2d309`

## الخطوة 2: فتح Firestore Database
1. من الـ Sidebar الأيسر، اختر: **Firestore Database**
2. تأكد أنك في Tab: **Rules**

## الخطوة 3: انسخ القوانين الجديدة

قم بحذف أي نص موجود في الـ Rules editor واستبدله بالتالي:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // السماح للمستخدمين المسجلين فقط بـ read من قسم users
    match /users/{userId} {
      allow read: if request.auth.uid != null;
      allow create: if request.auth.uid == userId;
      allow update, delete: if request.auth.uid == userId;
    }
    
    // السماح بـ create و read في Emergency Alerts
    // أي مستخدم مسجل دخول يمكنه عمل Emergency Alert
    match /emergencyAlerts/{document=**} {
      allow create: if request.auth.uid != null;
      allow read, list: if request.auth.uid != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }
    
    // السماح بـ read من قسم Blood Banks
    match /bloodBanks/{document=**} {
      allow read: if request.auth.uid != null;
    }
    
    // السماح بـ read/write في Donation History
    match /donationHistory/{document=**} {
      allow read, create: if request.auth.uid != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }
    
    // أي collections أخرى: رفض بشكل افتراضي
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## الخطوة 4: حفظ القوانين
1. اضغط الزر الأزرق: **Publish**
2. انتظر حتى تظهر رسالة النجاح (عادة تظهر في الأسفل)

## الخطوة 5: اختبر التطبيق
1. افتح التطبيق
2. سجل دخول (إذا لم تسجل بعد)
3. اذهب إلى Emergency Screen
4. حاول إرسال Emergency Alert
5. يجب أن ينجح بدون أخطاء

---

## إذا مازال يحصل خطأ:

### ✅ الفحوصات:
1. تأكد من أن النصوص مطابقة تماماً (لا مسافات إضافية)
2. تأكد من Publish (لا تنسى هذه الخطوة!)
3. تأكد من أنك مسجل دخول في التطبيق
4. تحقق من Internet Connection

### 🔄 جرب:
1. أغلق وافتح التطبيق
2. تسجيل الخروج → تسجيل الدخول مرة أخرى
3. حذف التطبيق وأعد تثبيته

### 📞 للمساعدة:
- تحقق من Firestore Logs في Firebase Console
- اضغط على **Logs** في أسفل صفحة Rules
- ستجد رسائل مفصلة عن الأخطاء

---

## القوانين شرح:

| القاعدة | المعنى |
|--------|--------|
| `request.auth.uid != null` | المستخدم مسجل دخول |
| `request.auth.uid == userId` | المستخدم يعدل بيانات نفسه فقط |
| `allow create` | السماح بإنشاء مستندات جديدة |
| `allow read` | السماح بـ قراءة المستندات |
| `allow list` | السماح بـ البحث عن المستندات |
| `allow delete` | السماح بـ حذف المستندات |

