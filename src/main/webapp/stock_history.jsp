<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.inventory.model.StockHistory" %>

<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<StockHistory> history =
        (List<StockHistory>) request.getAttribute("history");

    int totalTx = 0;
    int totalIn = 0;
    int totalOut = 0;

    if (history != null) {
        totalTx = history.size();
        for (StockHistory h : history) {
            if ("IN".equalsIgnoreCase(h.getType())) {
                totalIn += h.getQuantity();
            } else if ("OUT".equalsIgnoreCase(h.getType())) {
                totalOut += h.getQuantity();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Stock History Log | Inventory System</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        --primary: #3b82f6;
        --primary-hover: #2563eb;
        --secondary: #64748b;
        --success: #10b981;
        --success-bg: #ecfdf5;
        --danger: #ef4444;
        --danger-bg: #fef2f2;
        --bg-body: #f8fafc;
        --card-bg: #ffffff;
        --border-color: #e2e8f0;
        --text-main: #0f172a;
        --text-muted: #64748b;
        --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
        --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.07);
        --radius: 12px;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }

    body {
        background-color: var(--bg-body);
        color: var(--text-main);
        padding: 30px 40px;
        min-height: 100vh;
    }

    .container {
        max-width: 1100px;
        margin: 0 auto;
    }

    .top-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        flex-wrap: wrap;
        gap: 15px;
    }

    .title-area h1 {
        font-size: 26px;
        font-weight: 700;
        color: var(--text-main);
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .title-area p {
        font-size: 14px;
        color: var(--text-muted);
        margin-top: 4px;
    }

    .nav-actions {
        display: flex;
        gap: 10px;
    }

    .nav-btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: #ffffff;
        color: var(--secondary);
        border: 1px solid var(--border-color);
        padding: 10px 18px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        box-shadow: var(--shadow-sm);
        transition: all 0.2s ease;
    }

    .nav-btn:hover {
        background: #f1f5f9;
        color: var(--text-main);
        border-color: #cbd5e1;
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 18px;
        margin-bottom: 25px;
    }

    .stat-card {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: var(--radius);
        padding: 20px;
        box-shadow: var(--shadow-sm);
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .stat-label {
        font-size: 13px;
        font-weight: 600;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.04em;
    }

    .stat-value {
        font-size: 24px;
        font-weight: 700;
        color: var(--text-main);
        margin-top: 4px;
    }

    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
    }

    .icon-blue { background: #eff6ff; color: #3b82f6; }
    .icon-emerald { background: #ecfdf5; color: #10b981; }
    .icon-rose { background: #fff1f2; color: #f43f5e; }

    .card {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: var(--radius);
        box-shadow: var(--shadow-sm);
        overflow: hidden;
    }

    .card-header {
        padding: 20px 24px;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
    }

    .card-header h2 {
        font-size: 18px;
        font-weight: 700;
        color: var(--text-main);
    }

    .toolbar-search {
        position: relative;
        max-width: 300px;
        width: 100%;
    }

    .toolbar-search input {
        width: 100%;
        padding: 8px 12px 8px 34px;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        font-size: 13px;
        outline: none;
    }

    .toolbar-search svg {
        position: absolute;
        left: 10px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--secondary);
    }

    .table-responsive {
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        text-align: left;
    }

    thead th {
        background: #f8fafc;
        color: var(--secondary);
        font-size: 12px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        padding: 14px 20px;
        border-bottom: 1px solid var(--border-color);
    }

    tbody td {
        padding: 14px 20px;
        border-bottom: 1px solid #f1f5f9;
        font-size: 14px;
        color: #1e293b;
        vertical-align: middle;
    }

    tbody tr:hover {
        background: #f8fafc;
    }

    .type-badge {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 4px 10px;
        border-radius: 9999px;
        font-size: 12px;
        font-weight: 700;
    }

    .type-in {
        background: var(--success-bg);
        color: #047857;
    }

    .type-out {
        background: var(--danger-bg);
        color: #b91c1c;
    }

    .qty-bold {
        font-weight: 700;
        font-size: 15px;
    }
</style>
</head>

<body>

<div class="container">

    <div class="top-header">
        <div class="title-area">
            <h1>📜 Stock Audit Log</h1>
            <p>Complete historical log of all Stock IN and Stock OUT transactions</p>
        </div>
        <div class="nav-actions">
            <a href="stock" class="nav-btn">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Stock Management
            </a>
            <a href="dashboard.jsp" class="nav-btn">Dashboard</a>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div>
                <div class="stat-label">Total Transactions</div>
                <div class="stat-value"><%= totalTx %></div>
            </div>
            <div class="stat-icon icon-blue">📊</div>
        </div>

        <div class="stat-card">
            <div>
                <div class="stat-label">Total Units In</div>
                <div class="stat-value" style="color: #047857;">+<%= totalIn %></div>
            </div>
            <div class="stat-icon icon-emerald">📈</div>
        </div>

        <div class="stat-card">
            <div>
                <div class="stat-label">Total Units Out</div>
                <div class="stat-value" style="color: #b91c1c;">-<%= totalOut %></div>
            </div>
            <div class="stat-icon icon-rose">📉</div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h2>Transaction Records</h2>
            <div class="toolbar-search">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="searchHistory" placeholder="Search by product, type..." onkeyup="filterHistory()">
            </div>
        </div>

        <div class="table-responsive">
            <table id="historyTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>TX ID</th>
                        <th>Product Details</th>
                        <th>Type</th>
                        <th>Quantity Adjusted</th>
                        <th>Transaction Date & Time</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int count = 1;
                        if (history != null && !history.isEmpty()) {
                            for (StockHistory h : history) {
                                boolean isIn = "IN".equalsIgnoreCase(h.getType());
                    %>
                    <tr>
                        <td style="color: var(--secondary); font-weight: 600;"><%= count++ %></td>
                        <td style="font-weight: 600;">#<%= h.getId() %></td>
                        <td>
                            <strong><%= h.getProductName() %></strong>
                            <small style="color: var(--text-muted); display: block;">ID: <%= h.getProductId() %></small>
                        </td>
                        <td>
                            <span class="type-badge <%= isIn ? "type-in" : "type-out" %>">
                                <%= isIn ? "↑ STOCK IN" : "↓ STOCK OUT" %>
                            </span>
                        </td>
                        <td>
                            <span class="qty-bold" style="<%= isIn ? "color: #047857;" : "color: #b91c1c;" %>">
                                <%= isIn ? "+" : "-" %><%= h.getQuantity() %> units
                            </span>
                        </td>
                        <td style="color: var(--secondary);"><%= h.getTransactionDate() %></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 40px; color: var(--secondary);">
                            No transactions recorded yet.
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script>
function filterHistory() {
    const filter = document.getElementById("searchHistory").value.toLowerCase();
    const rows = document.getElementById("historyTable").getElementsByTagName("tbody")[0].getElementsByTagName("tr");
    for (let i = 0; i < rows.length; i++) {
        const text = rows[i].textContent || rows[i].innerText;
        rows[i].style.display = text.toLowerCase().indexOf(filter) > -1 ? "" : "none";
    }
}
</script>

</body>
</html>
