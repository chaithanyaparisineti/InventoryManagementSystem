<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.inventory.model.Admin" %>

<%
    Admin admin = (Admin) session.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard | Inventory System</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        --primary: #3b82f6;
        --primary-hover: #2563eb;
        --bg-body: #f8fafc;
        --card-bg: #ffffff;
        --border-color: #e2e8f0;
        --text-main: #0f172a;
        --text-muted: #64748b;
        --radius: 12px;
        --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
        --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.07);
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
        padding: 40px 30px;
        min-height: 100vh;
    }

    .container {
        max-width: 1080px;
        margin: 0 auto;
    }

    .header-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        padding: 24px 30px;
        border-radius: var(--radius);
        box-shadow: var(--shadow-sm);
        margin-bottom: 30px;
        flex-wrap: wrap;
        gap: 15px;
    }

    .welcome-text h1 {
        font-size: 24px;
        font-weight: 700;
        letter-spacing: -0.02em;
    }

    .welcome-text p {
        font-size: 14px;
        color: var(--text-muted);
        margin-top: 4px;
    }

    .btn-logout {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background: #fef2f2;
        color: #dc2626;
        border: 1px solid #fecaca;
        padding: 9px 18px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s ease;
    }

    .btn-logout:hover {
        background: #fee2e2;
        color: #b91c1c;
    }

    .module-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 24px;
    }

    .module-card {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: var(--radius);
        padding: 28px 24px;
        box-shadow: var(--shadow-sm);
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .module-card:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow-md);
    }

    .module-icon {
        width: 52px;
        height: 52px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 26px;
        margin-bottom: 20px;
    }

    .icon-products { background: #eff6ff; color: #3b82f6; }
    .icon-suppliers { background: #faf5ff; color: #a855f7; }
    .icon-stock { background: #ecfdf5; color: #10b981; }

    .module-card h2 {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 8px;
        color: var(--text-main);
    }

    .module-card p {
        font-size: 13px;
        color: var(--text-muted);
        line-height: 1.5;
        margin-bottom: 24px;
    }

    .module-link {
        display: inline-flex;
        align-items: center;
        justify-content: space-between;
        background: #f8fafc;
        border: 1px solid var(--border-color);
        color: var(--text-main);
        padding: 11px 16px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s ease;
    }

    .module-link:hover {
        background: var(--primary);
        color: #ffffff;
        border-color: var(--primary);
    }
</style>
</head>

<body>

<div class="container">

    <div class="header-bar">
        <div class="welcome-text">
            <h1>Welcome, <%= admin.getUsername() %>! 👋</h1>
            <p>Inventory Control & Warehouse Management Dashboard</p>
        </div>
        <a href="logout" class="btn-logout">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                <polyline points="16 17 21 12 16 7"></polyline>
                <line x1="21" y1="12" x2="9" y2="12"></line>
            </svg>
            Sign Out
        </a>
    </div>

    <div class="module-grid">
        <!-- Products -->
        <div class="module-card">
            <div>
                <div class="module-icon icon-products">📦</div>
                <h2>Product Catalog</h2>
                <p>Register new products, manage unit prices, stock levels, and assign verified suppliers.</p>
            </div>
            <a href="products" class="module-link">
                <span>Manage Products</span>
                <span>→</span>
            </a>
        </div>

        <!-- Suppliers -->
        <div class="module-card">
            <div>
                <div class="module-icon icon-suppliers">🚚</div>
                <h2>Supplier Directory</h2>
                <p>Maintain vendor directories, verified email channels, and phone contact information.</p>
            </div>
            <a href="suppliers" class="module-link">
                <span>Manage Suppliers</span>
                <span>→</span>
            </a>
        </div>

        <!-- Stock -->
        <div class="module-card">
            <div>
                <div class="module-icon icon-stock">📊</div>
                <h2>Stock Management</h2>
                <p>Perform live Stock IN and Stock OUT operations with real-time audit transaction tracking.</p>
            </div>
            <a href="stock" class="module-link">
                <span>Manage Stock</span>
                <span>→</span>
            </a>
        </div>
    </div>

</div>

</body>
</html>
