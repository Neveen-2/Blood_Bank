## ✅ حل مشكلة Firebase Emergency Alert Save

### 🎯 المشكلة:
عند الضغط على "Send Emergency Alert" يظهر خطأ `permission-denied` 
السبب: Firestore Security Rules لا تسمح بـ write في collection emergencyAlerts

### 🔧 الحل (خطوة واحدة فقط):

1. اذهب إلى: https://console.firebase.google.com
2. اختر Project: **blood-bank-2d309**
3. من الـ Sidebar، اختر: **Firestore Database**
4. اضغط على Tab: **Rules** (في الأعلى)
5. **احذف** كل النص الموجود
6. **انسخ** الكود من ملف `firestore.rules` في هذا المشروع
7. **الصقه** في Firebase Rules Editor
8. اضغط الزر الأزرق: **Publish**
9. انتظر ظهور رسالة نجاح (deployed successfully)

### ✅ بعد ذلك:
- افتح التطبيق
- سجل دخول (إذا لم تسجل)
- اذهب إلى Emergency
- جرب إرسال Emergency Alert
- يجب أن ينجح الآن

### 📝 القوانين تقول:
- ✅ أي مستخدم مسجل دخول يمكنه إنشاء Emergency Alert
- ✅ أي مستخدم مسجل دخول يمكنه قراءة Emergency Alerts
- ✅ فقط المستخدم الذي أنشأ الـ Alert يمكنه تعديله أو حذفه

### ⚠️ ملاحظات:
- لا تنسى **Publish** بعد لصق الكود
- لا تحتاج لتعديل أي كود في التطبيق
- الـ saveEmergencyAlert() method سيعمل بدون أخطاء بعد تطبيق هذه القوانين

---

## 📂 ملف القوانين:
انظر إلى ملف: `firestore.rules` في هذا المشروع
