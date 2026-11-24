<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.inventory.model.Product" %>

<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");

    int totalProducts = 0;
    int totalUnits = 0;
    int lowStockCount = 0;

    if (products != null) {
        totalProducts = products.size();
        for (Product p : products) {
            totalUnits += p.getQuantity();
            if (p.getQuantity() <= 10) {
                lowStockCount++;
            }
        }
    }

    String error   = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Stock Management | Inventory System</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        --primary: #3b82f6;
        --primary-hover: #2563eb;
        --primary-light: #eff6ff;
        --secondary: #64748b;
        --success: #10b981;
        --success-hover: #059669;
        --success-bg: #ecfdf5;
        --warning: #f59e0b;
        --warning-bg: #fffbeb;
        --danger: #ef4444;
        --danger-hover: #dc2626;
        --danger-bg: #fef2f2;
        --bg-body: #f8fafc;
        --card-bg: #ffffff;
        --border-color: #e2e8f0;
        --text-main: #0f172a;
        --text-muted: #64748b;
        --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
        --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.07), 0 2px 4px -2px rgb(0 0 0 / 0.05);
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
        max-width: 1000px;
        margin: 0 auto;
    }

    /* Top Navigation Header */
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
        letter-spacing: -0.02em;
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
        align-items: center;
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
        transform: translateY(-1px);
    }

    .nav-btn-primary {
        background: var(--primary-light);
        color: var(--primary);
        border-color: #bfdbfe;
    }

    .nav-btn-primary:hover {
        background: #dbeafe;
        color: var(--primary-hover);
    }

    /* KPI Stats Grid */
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
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .stat-card:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
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
    .icon-amber { background: #fffbeb; color: #f59e0b; }

    /* Alert Messages */
    .alert {
        padding: 14px 18px;
        border-radius: 10px;
        margin-bottom: 22px;
        font-size: 14px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
        animation: slideDown 0.3s ease;
    }

    .alert-success {
        background: var(--success-bg);
        color: #065f46;
        border: 1px solid #a7f3d0;
    }

    .alert-danger {
        background: var(--danger-bg);
        color: #991b1b;
        border: 1px solid #fecaca;
    }

    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* Main Operation Card */
    .card {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: var(--radius);
        box-shadow: var(--shadow-sm);
        margin-bottom: 30px;
        overflow: hidden;
    }

    .card-header {
        padding: 20px 24px;
        border-bottom: 1px solid var(--border-color);
        background: #ffffff;
    }

    .card-header h2 {
        font-size: 18px;
        font-weight: 700;
        color: var(--text-main);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .card-body {
        padding: 28px 24px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: #334155;
        margin-bottom: 8px;
    }

    .form-control {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        font-size: 14px;
        color: var(--text-main);
        background: #ffffff;
        transition: all 0.2s ease;
    }

    .form-control:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
    }

    /* Live Preview Banner */
    .preview-box {
        background: #f8fafc;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        padding: 14px 18px;
        margin-bottom: 24px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .preview-info {
        font-size: 13px;
        color: var(--text-muted);
    }

    .preview-stock {
        font-size: 15px;
        font-weight: 700;
        color: var(--text-main);
    }

    /* Button Group */
    .btn-group {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
        margin-top: 10px;
    }

    .btn-in {
        background: var(--success);
        color: white;
        border: none;
        padding: 13px 20px;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
        transition: all 0.2s ease;
    }

    .btn-in:hover {
        background: var(--success-hover);
        box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
        transform: translateY(-1px);
    }

    .btn-out {
        background: var(--danger);
        color: white;
        border: none;
        padding: 13px 20px;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        box-shadow: 0 2px 4px rgba(239, 68, 68, 0.2);
        transition: all 0.2s ease;
    }

    .btn-out:hover {
        background: var(--danger-hover);
        box-shadow: 0 4px 8px rgba(239, 68, 68, 0.3);
        transform: translateY(-1px);
    }

    @media (max-width: 640px) {
        body { padding: 20px 15px; }
        .btn-group { grid-template-columns: 1fr; }
    }
</style>
</head>

<body>

<div class="container">

    <!-- Top Header Navigation -->
    <div class="top-header">
        <div class="title-area">
            <h1>📊 Stock Management</h1>
            <p>Perform live Stock IN and Stock OUT operations with real-time audit logging</p>
        </div>
        <div class="nav-actions">
            <a href="stock?action=history" class="nav-btn nav-btn-primary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                    <polyline points="10 9 9 9 8 9"></polyline>
                </svg>
                View Stock History
            </a>
            <a href="dashboard.jsp" class="nav-btn">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Dashboard
            </a>
        </div>
    </div>

    <!-- Live KPI Summary Stats -->
    <div class="stats-grid">
        <div class="stat-card">
            <div>
                <div class="stat-label">Tracked Products</div>
                <div class="stat-value"><%= totalProducts %></div>
            </div>
            <div class="stat-icon icon-blue">📋</div>
        </div>

        <div class="stat-card">
            <div>
                <div class="stat-label">Warehouse Stock Units</div>
                <div class="stat-value"><%= totalUnits %></div>
            </div>
            <div class="stat-icon icon-emerald">📦</div>
        </div>

        <div class="stat-card">
            <div>
                <div class="stat-label">Low Stock Warnings</div>
                <div class="stat-value" style="<%= lowStockCount > 0 ? "color:#b45309;" : "" %>">
                    <%= lowStockCount %>
                </div>
            </div>
            <div class="stat-icon icon-amber">⚠️</div>
        </div>
    </div>

    <!-- Feedback Notification Alerts -->
    <% if ("1".equals(success)) { %>
        <div class="alert alert-success">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
            Stock updated successfully! Transaction recorded in history log.
        </div>
    <% } else if ("insufficient".equals(error)) { %>
        <div class="alert alert-danger">
            ⚠️ Insufficient stock available. Cannot deduct more quantity than existing warehouse balance.
        </div>
    <% } else if ("notfound".equals(error)) { %>
        <div class="alert alert-danger">
            ✕ Product not found in database. Please re-select a valid product.
        </div>
    <% } else if ("invalid".equals(error)) { %>
        <div class="alert alert-danger">
            ⚠️ Invalid input data. Please select a product and enter a positive integer quantity.
        </div>
    <% } else if ("failed".equals(error)) { %>
        <div class="alert alert-danger">
            ✕ Transaction failed due to a database error. Please try again.
        </div>
    <% } %>

    <!-- Stock Operation Card -->
    <div class="card">
        <div class="card-header">
            <h2>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                    <polyline points="2 17 12 22 22 17"></polyline>
                    <polyline points="2 12 12 17 22 12"></polyline>
                </svg>
                Inventory Adjustment Form
            </h2>
        </div>

        <div class="card-body">
            <form action="stock" method="post">
                <input type="hidden" name="type" id="stockType" value="IN">

                <div class="form-group">
                    <label for="productId">Select Product</label>
                    <select name="productId" id="productId" class="form-control" onchange="updatePreview()" required>
                        <option value="">-- Choose a product to adjust --</option>
                        <%
                            if (products != null) {
                                for (Product p : products) {
                        %>
                        <option value="<%= p.getId() %>" data-stock="<%= p.getQuantity() %>" data-name="<%= p.getName() %>">
                            <%= p.getName() %> (Current Balance: <%= p.getQuantity() %> units)
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <!-- Interactive Stock Balance Preview Box -->
                <div class="preview-box" id="previewBox" style="display: none;">
                    <div class="preview-info">
                        Selected: <strong id="previewName">-</strong>
                    </div>
                    <div class="preview-stock">
                        Current Balance: <span id="previewStockValue" style="color: var(--primary);">0</span> units
                    </div>
                </div>

                <div class="form-group">
                    <label for="quantity">Adjustment Quantity</label>
                    <input type="number" name="quantity" id="quantity" class="form-control"
                           min="1" placeholder="Enter number of units" required>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn-in" onclick="document.getElementById('stockType').value='IN'">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Stock IN (Add Units)
                    </button>

                    <button type="submit" class="btn-out" onclick="document.getElementById('stockType').value='OUT'">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Stock OUT (Deduct Units)
                    </button>
                </div>
            </form>
        </div>
    </div>

</div>

<script>
function updatePreview() {
    const select = document.getElementById("productId");
    const selectedOption = select.options[select.selectedIndex];
    const previewBox = document.getElementById("previewBox");

    if (selectedOption && selectedOption.value) {
        document.getElementById("previewName").textContent = selectedOption.getAttribute("data-name");
        document.getElementById("previewStockValue").textContent = selectedOption.getAttribute("data-stock");
        previewBox.style.display = "flex";
    } else {
        previewBox.style.display = "none";
    }
}
</script>

</body>
</html>
