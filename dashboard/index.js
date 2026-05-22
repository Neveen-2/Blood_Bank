import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import {
  getDatabase,
  ref,
  onValue,
  get,
  update,
} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-database.js";

// =========================
// Firebase Config
// =========================
const firebaseConfig = {
  apiKey: "AIzaSyAIj38tIL6SJMLGMh6gXVzA7CA1qLMU5vc",
  authDomain: "blood-bank-2d309.firebaseapp.com",
  databaseURL: "https://blood-bank-2d309-default-rtdb.firebaseio.com/",
  projectId: "blood-bank-2d309",
  storageBucket: "blood-bank-2d309.firebasestorage.app",
  messagingSenderId: "1007218222332",
  appId: "1:1007218222332:web:0af86af57b8a32f0746379",
};

const app = initializeApp(firebaseConfig);
const db = getDatabase(app);
const dashboardRef = ref(db, "dashboard");
onValue(dashboardRef, (snapshot) => {
  const data = snapshot.val();

  if (data) {
    updateUI(data);
  }
});
// =========================
// Charts
// =========================
let barChart, pieChart;

function initCharts() {
  const barCtx = document.getElementById("barChart").getContext("2d");

  barChart = new Chart(barCtx, {
    type: "bar",
    data: {
      labels: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
      datasets: [
        {
          label: "Units",
          data: [],
          backgroundColor: "#e63946",
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
    },
  });

  const pieCtx = document.getElementById("pieChart").getContext("2d");

  pieChart = new Chart(pieCtx, {
    type: "pie",
    data: {
      labels: ["Available", "Reserved", "Critical"],
      datasets: [
        {
          data: [],
          backgroundColor: ["#28a745", "#ffc107", "#dc3545"],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
    },
  });
}

// =========================
// Live Firebase Listener
// =========================
const emergencyRef = ref(db, "emergencies");

onValue(emergencyRef, (snapshot) => {
  const data = snapshot.val();
  const log = document.getElementById("activityLog");
  if (!data) {
    log.innerHTML = "<p>No emergencies</p>";
    document.getElementById("val-alerts").innerText = 0;
    return;
  }

  let count = 0;
  let html = "";
  console.log(log);

  Object.entries(data).forEach(([key, item]) => {
    console.log(item);
    if (item.status?.trim().toLowerCase() === "pending") {
      count++;
      console.log("ADDING TO HTML");
      html += `
        <div class="activity-item">

          <span>
            <span class="activity-dot"></span>
            Emergency Need ${item.bloodType} at ${item.location}
          </span>

          <button class="accept-btn" onclick="acceptRequest('${key}', '${item.bloodType}')">
            Accept
          </button>

          <small>${item.time}</small>

        </div>
      `;
    }
  });
});
window.acceptRequest = async function (id, bloodType) {
  try {
    // تغيير الحالة
    await update(ref(db, `emergencies/${id}`), {
      status: "accepted",
    });

    // تقليل blood units
    const dashboardSnapshot = await get(dashboardRef);

    if (dashboardSnapshot.exists()) {
      const dashboardData = dashboardSnapshot.val();

      let currentUnits = dashboardData.stats?.units || 0;

      await update(dashboardRef, {
        "stats/units": currentUnits - 1,
      });
    }

    alert("Emergency Accepted");
  } catch (error) {
    console.error(error);
  }
};
// =========================
// Manual Refresh
// =========================
document.getElementById("manualRefresh").addEventListener("click", async () => {
  try {
    const snapshot = await get(dashboardRef);

    if (snapshot.exists()) {
      updateUI(snapshot.val());
    }
  } catch (error) {
    console.error("Refresh error:", error);
  }
});
// =========================
// Update UI
// =========================
function updateUI(data) {
  // Stats
  document.getElementById("val-donors").innerText = (
    data.stats?.donors || 0
  ).toLocaleString();

  document.getElementById("val-units").innerText = data.stats?.units || 0;

  document.getElementById("val-month").innerText =
    "+" + (data.stats?.month || 0);

  // Charts
  barChart.data.datasets[0].data = data.inventory || [];
  barChart.update();

  pieChart.data.datasets[0].data = data.status || [];
  pieChart.update();
}

// =========================
// Start
// =========================
initCharts();
