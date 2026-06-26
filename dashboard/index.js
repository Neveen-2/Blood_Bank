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

      scales: {
        y: {
          beginAtZero: true,
          max: 10,
          ticks: {
            stepSize: 1,
          },
        },
      },
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
// Listening to emergencies in real-time
const emergencyRef = ref(db, "dashboard/activity/emergency");
let emergencyData = {};
onValue(emergencyRef, (snapshot) => {
  emergencyData = snapshot.val() || {};
  renderActivity();
});
const donationRef = ref(db, "dashboard/activity/donation");
let donationData = {};
onValue(donationRef, (snapshot) => {
  donationData = snapshot.val();
  renderActivity();
  get(dashboardRef).then((snap) => {
    if (snap.exists()) {
      updateUI(snap.val());
    }
  });
});
window.acceptRequest = async function (id, bloodType) {
  try {
    // تغيير الحالة
    await update(ref(db, `dashboard/activity/emergency/${id}`), {
      status: "accepted",
    });

    // تقليل blood units
    const dashboardSnapshot = await get(dashboardRef);

    if (dashboardSnapshot.exists()) {
      const dashboardData = dashboardSnapshot.val();

      let currentUnits = dashboardData.stats?.units || 0;
      currentUnits = Math.max(0, currentUnits - 1);

      await update(dashboardRef, {
        "stats/units": currentUnits,
      });
      const inventoryRef = ref(db, "dashboard/inventory");

      const inventorySnapshot = await get(inventoryRef);

      if (inventorySnapshot.exists()) {
        let inventory = inventorySnapshot.val();

        const bloodMap = {
          "A+": 0,
          "A-": 1,
          "B+": 2,
          "B-": 3,
          "O+": 4,
          "O-": 5,
          "AB+": 6,
          "AB-": 7,
        };

        let index = bloodMap[bloodType];

        inventory[index] = Math.max(0, inventory[index] - 1);

        await update(ref(db, "dashboard"), {
          inventory: inventory,
        });
      }
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
  const now = new Date();

  let monthlyDonations = 0;

  Object.values(donationData || {}).forEach((item) => {
    const donationDate = new Date(item.time);

    if (
      donationDate.getMonth() === now.getMonth() &&
      donationDate.getFullYear() === now.getFullYear()
    ) {
      monthlyDonations++;
    }
  });

  document.getElementById("val-month").innerText = "+" + monthlyDonations;
  // Charts
  barChart.data.datasets[0].data = data.inventory || [];
  barChart.update();

  // =========================
  // Pie Chart Data
  // =========================

  let available = data.stats?.units || 0;

  let critical = 0;
  let reserved = 0;

  Object.values(emergencyData || {}).forEach((item) => {
    if (item.status === "pending") {
      critical++;
    }

    if (item.status === "accepted") {
      reserved++;
    }
  });

  pieChart.data.datasets[0].data = [available, reserved, critical];

  pieChart.update();
}
function renderActivity() {
  const log = document.getElementById("activityLog");

  let html = "";
  let count = 0;

  // ======================
  // Emergency
  // ======================
  Object.entries(emergencyData || {}).forEach(([key, item]) => {
    if (item.status !== "pending") return;
    html += `
      <div class="activity-item">
        <span>
          <span class="activity-dot"></span>
          Emergency (${item.bloodType}) - ${item.location}
        </span>
         
       ${
         item.notes
           ? `<div style="margin-top:6px;font-size:13px;color:#666;">
         <b>Case Details:</b><br>
         ${item.notes}
       </div>`
           : ""
       }

        ${
          item.status === "pending"
            ? `<button class="accept-btn" onclick="acceptRequest('${key}', '${item.bloodType}')">
              Accept
             </button>`
            : ""
        }

        <small>${item.time}</small>
      </div>
    `;

    if (item.status === "pending") count++;
  });

  // ======================
  // Donation
  // ======================
  Object.entries(donationData || {}).forEach(([key, item]) => {
    html += `
      <div class="activity-item">
        <span>
          <span class="activity-dot"></span>
          Donation (${item.bloodType})
        </span>
        <small>${item.time}</small>
      </div>
    `;
  });

  log.innerHTML = html;
  document.getElementById("val-alerts").innerText = count;
}
// =========================
// Start
// =========================
initCharts();
renderActivity();
window.logout = function () {
  localStorage.removeItem("user");
  window.location.href = "login.html";
};
