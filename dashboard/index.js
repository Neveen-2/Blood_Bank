import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getDatabase, ref, onValue, get } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-database.js";

// Firebase Config

const firebaseConfig = {
    apiKey: "AIzaSyD31B7-_TTAcsXvM0pJLhKzyTixl6k8HGE",
    authDomain: "blood-donation-bank-c0d10.firebaseapp.com",
    databaseURL: "https://blood-donation-bank-c0d10-default-rtdb.firebaseio.com/",
    projectId: "blood-donation-bank-c0d10",
    storageBucket: "blood-donation-bank-c0d10.firebasestorage.app",
    messagingSenderId: "851498186463",
    appId: "1:851498186463:web:058aafd2d346f4f63d9b6a"
};

const app = initializeApp(firebaseConfig);
const db = getDatabase(app);
const dashboardRef = ref(db, "dashboard");

// Charts
let barChart, pieChart;

function initCharts() {
    const barCtx = document.getElementById("barChart").getContext("2d");

    barChart = new Chart(barCtx, {
        type: "bar",
        data: {
            labels: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
            datasets: [{
                label: "Units",
                data: [],
                backgroundColor: "#e63946"
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });

    const pieCtx = document.getElementById("pieChart").getContext("2d");

    pieChart = new Chart(pieCtx, {
        type: "pie",
        data: {
            labels: ["Available", "Reserved", "Critical"],
            datasets: [{
                data: [],
                backgroundColor: ["#28a745", "#ffc107", "#dc3545"]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
}


// Live Firebase Listener
onValue(dashboardRef, (snapshot) => {
    const data = snapshot.val();

    if (data) {
        updateUI(data);
    }
});


// Manual Refresh

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

// Update UI

function updateUI(data) {

    // Stats
    document.getElementById("val-donors").innerText =
        (data.stats?.donors || 0).toLocaleString();

    document.getElementById("val-units").innerText =
        data.stats?.units || 0;

    document.getElementById("val-month").innerText =
        "+" + (data.stats?.month || 0);

    document.getElementById("val-alerts").innerText =
        data.stats?.alerts || 0;

    // Activity
    const log = document.getElementById("activityLog");

    log.innerHTML = (data.activity || []).map(item => `
        <div class="activity-item">
            <span>
                <span class="activity-dot"></span>
                ${item.text}
            </span>
            <small>${item.time}</small>
        </div>
    `).join("");

    // Charts
    barChart.data.datasets[0].data = data.inventory || [];
    barChart.update();

    pieChart.data.datasets[0].data = data.status || [];
    pieChart.update();
}

initCharts();

window.logout = function () {
    localStorage.removeItem("user");
    window.location.href = "login.html";
}
