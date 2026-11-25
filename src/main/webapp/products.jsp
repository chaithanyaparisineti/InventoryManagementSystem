<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.inventory.model.Product" %>
<%@ page import="com.inventory.model.Supplier" %>

<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");

    int totalProducts = 0;
    int totalUnits = 0;
    double totalValue = 0.0;
    int lowStockCount = 0;

    if (products != null) {
        totalProducts = products.size();
        for (Product p : products) {
            totalUnits += p.getQuantity();
            totalValue += (p.getPrice() * p.getQuantity());
            if (p.getQuantity() <= 10) {
                lowStockCount++;
            }
        }
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Product Management | Inventory System</title>
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
        --success-bg: #ecfdf5;
        --warning: #f59e0b;
        --warning-bg: #fffbeb;
        --danger: #ef4444;
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
        max-width: 1280px;
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

    .back-btn {
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

    .back-btn:hover {
        background: #f1f5f9;
        color: var(--text-main);
        border-color: #cbd5e1;
        transform: translateY(-1px);
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
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
    .icon-purple { background: #faf5ff; color: #a855f7; }
    .icon-amber { background: #fffbeb; color: #f59e0b; }

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
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #ffffff;
    }

    .card-header h2 {
        font-size: 17px;
        font-weight: 700;
        color: var(--text-main);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .badge-count {
        background: #f1f5f9;
        color: var(--secondary);
        font-size: 12px;
        font-weight: 600;
        padding: 3px 9px;
        border-radius: 12px;
    }

    .card-body {
        padding: 24px;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 18px;
        align-items: end;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .form-group label {
        font-size: 13px;
        font-weight: 600;
        color: #334155;
    }

    .form-control {
        width: 100%;
        padding: 10px 14px;
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

    .btn-submit {
        background: var(--primary);
        color: white;
        border: none;
        padding: 11px 22px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2);
        transition: all 0.2s ease;
        height: 42px;
    }

    .btn-submit:hover {
        background: var(--primary-hover);
        box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3);
        transform: translateY(-1px);
    }

    .toolbar-search {
        position: relative;
        max-width: 320px;
        width: 100%;
    }

    .toolbar-search input {
        width: 100%;
        padding: 8px 12px 8px 34px;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        font-size: 13px;
        color: var(--text-main);
        outline: none;
        transition: border-color 0.2s;
    }

    .toolbar-search input:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12);
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
        white-space: nowrap;
    }

    tbody td {
        padding: 16px 20px;
        border-bottom: 1px solid #f1f5f9;
        font-size: 14px;
        color: #1e293b;
        vertical-align: middle;
    }

    tbody tr:hover {
        background: #f8fafc;
    }

    .col-id {
        font-weight: 600;
        color: var(--secondary);
        width: 60px;
    }

    .product-title {
        font-weight: 600;
        color: var(--text-main);
    }

    .category-badge {
        display: inline-block;
        padding: 4px 10px;
        background: #e2e8f0;
        color: #475569;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
    }

    .price-tag {
        font-weight: 700;
        color: #0f172a;
    }

    .stock-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 4px 10px;
        border-radius: 9999px;
        font-size: 12px;
        font-weight: 600;
    }

    .stock-in {
        background: var(--success-bg);
        color: #047857;
    }

    .stock-low {
        background: var(--warning-bg);
        color: #b45309;
    }

    .stock-out {
        background: var(--danger-bg);
        color: #b91c1c;
    }

    .stock-dot {
        width: 6px;
        height: 6px;
        border-radius: 50%;
        background-color: currentColor;
    }

    .supplier-pill {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        background: #f1f5f9;
        border: 1px solid var(--border-color);
        padding: 4px 10px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        color: #334155;
    }

    .actions-cell {
        display: flex;
        align-items: center;
        gap: 8px;
        justify-content: flex-end;
    }

    .btn-edit {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        background: #eff6ff;
        color: #2563eb;
        border: 1px solid #bfdbfe;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s;
    }

    .btn-edit:hover {
        background: #dbeafe;
    }

    .btn-delete {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        background: #fef2f2;
        color: #dc2626;
        border: 1px solid #fecaca;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
    }

    .btn-delete:hover {
        background: #fee2e2;
    }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: var(--secondary);
    }

    @media (max-width: 768px) {
        body { padding: 20px 15px; }
        .form-grid { grid-template-columns: 1fr; }
    }
</style>
</head>

<body>

<div class="container">

    <div class="top-header">
        <div class="title-area">
            <h1>📦 Manage Products</h1>
            <p>Add, edit, track and manage your inventory catalog</p>
        </div>
        <a href="dashboard.jsp" class="back-btn">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="19" y1="12" x2="5" y2="12"></line>
                <polyline points="12 19 5 12 12 5"></polyline>
            </svg>
            Back to Dashboard
        </a>
    </div>

    <!-- Live KPI Summary Stats -->
    <div class="stats-grid">
        <div class="stat-card">
            <div>
                <div class="stat-label">Total Products</div>
                <div class="stat-value"><%= totalProducts %></div>
            </div>
            <div class="stat-icon icon-blue">📋</div>
        </div>

        <div class="stat-card">
            <div>
                <div class="stat-label">Total Stock Units</div>
                <div class="stat-value"><%= totalUnits %></div>
            </div>
            <div class="stat-icon icon-emerald">📦</div>
        </div>

        <div class="stat-card">
            <div>
                <div class="stat-label">Inventory Value</div>
                <div class="stat-value">&#8377;<%= String.format("%,.2f", totalValue) %></div>
            </div>
            <div class="stat-icon icon-purple">💰</div>
        </div>

        <div class="stat-card">
            <div>
                <div class="stat-label">Low Stock Items</div>
                <div class="stat-value" style="<%= lowStockCount > 0 ? "color:#b45309;" : "" %>">
                    <%= lowStockCount %>
                </div>
            </div>
            <div class="stat-icon icon-amber">⚠️</div>
        </div>
    </div>

    <!-- Notification Alerts -->
    <% if ("1".equals(success)) { %>
        <div class="alert alert-success">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
            Product operation completed successfully! Inventory has been updated.
        </div>
    <% } else if ("delete_failed".equals(error)) { %>
        <div class="alert alert-danger">
            ✕ Cannot delete this product because it has recorded transactions in Stock History.
        </div>
    <% } else if ("invalid".equals(error)) { %>
        <div class="alert alert-danger">
            ⚠️ Invalid input data. Please verify product name, positive price, quantity and a valid supplier.
        </div>
    <% } else if ("failed".equals(error)) { %>
        <div class="alert alert-danger">
            ✕ Operation failed. Please ensure a valid supplier is selected.
        </div>
    <% } %>

    <!-- Add Product Card -->
    <div class="card">
        <div class="card-header">
            <h2>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                Add New Product
            </h2>
        </div>
        <div class="card-body">
            <form action="products" method="post">
                <input type="hidden" name="action" value="add">

                <div class="form-grid">
                    <div class="form-group">
                        <label for="name">Product Name</label>
                        <input type="text" id="name" name="name" class="form-control"
                               placeholder="e.g. Wireless Mouse" required>
                    </div>

                    <div class="form-group">
                        <label for="category">Category</label>
                        <input type="text" id="category" name="category" class="form-control"
                               placeholder="e.g. Electronics" required>
                    </div>

                    <div class="form-group">
                        <label for="price">Price (&#8377;)</label>
                        <input type="number" id="price" name="price" class="form-control"
                               placeholder="0.00" min="0" step="0.01" required>
                    </div>

                    <div class="form-group">
                        <label for="quantity">Initial Quantity</label>
                        <input type="number" id="quantity" name="quantity" class="form-control"
                               placeholder="0" min="0" required>
                    </div>

                    <!-- Dropdown populated with existing suppliers -->
                    <div class="form-group">
                        <label for="supplierId">Select Supplier</label>
                        <select id="supplierId" name="supplierId" class="form-control" required>
                            <option value="">-- Choose Supplier --</option>
                            <%
                                if (suppliers != null && !suppliers.isEmpty()) {
                                    for (Supplier s : suppliers) {
                            %>
                            <option value="<%= s.getId() %>">
                                <%= s.getName() %> (ID: #<%= s.getId() %>)
                            </option>
                            <%
                                    }
                                } else {
                            %>
                            <option value="" disabled>No suppliers registered. Add a supplier first!</option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <button type="submit" class="btn-submit">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Add Product
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Product Inventory Table Card -->
    <div class="card">
        <div class="card-header">
            <h2>
                Product Inventory
                <span class="badge-count"><%= totalProducts %> items</span>
            </h2>

            <div class="toolbar-search">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="tableSearch" placeholder="Search by name, category..." onkeyup="filterTable()">
            </div>
        </div>

        <div class="table-responsive">
            <table id="productsTable">
                <thead>
                    <tr>
                        <th class="col-id">#</th>
                        <th>Product Details</th>
                        <th>Category</th>
                        <th>Unit Price</th>
                        <th>Stock Level</th>
                        <th>Supplier</th>
                        <th style="text-align: right; padding-right: 28px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int serialNo = 1;
                        if (products != null && !products.isEmpty()) {
                            for (Product p : products) {
                                String stockClass = "stock-in";
                                String stockText = "In Stock (" + p.getQuantity() + ")";
                                if (p.getQuantity() == 0) {
                                    stockClass = "stock-out";
                                    stockText = "Out of Stock (0)";
                                } else if (p.getQuantity() <= 10) {
                                    stockClass = "stock-low";
                                    stockText = "Low Stock (" + p.getQuantity() + ")";
                                }

                                String suppDisplay = (p.getSupplierName() != null && !p.getSupplierName().trim().isEmpty())
                                    ? p.getSupplierName() + " (ID: #" + p.getSupplierId() + ")"
                                    : "Supplier #" + p.getSupplierId();
                    %>
                    <tr>
                        <td class="col-id"><%= serialNo++ %></td>
                        <td>
                            <div class="product-title"><%= p.getName() %></div>
                            <small style="color: var(--text-muted); font-size: 11px;">Product ID: #<%= p.getId() %></small>
                        </td>
                        <td>
                            <span class="category-badge"><%= p.getCategory() %></span>
                        </td>
                        <td>
                            <span class="price-tag">&#8377;<%= String.format("%,.2f", p.getPrice()) %></span>
                        </td>
                        <td>
                            <span class="stock-badge <%= stockClass %>">
                                <span class="stock-dot"></span>
                                <%= stockText %>
                            </span>
                        </td>
                        <td>
                            <span class="supplier-pill">🏢 <%= suppDisplay %></span>
                        </td>
                        <td>
                            <div class="actions-cell">
                                <a class="btn-edit" href="products?action=edit&id=<%= p.getId() %>">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                    </svg>
                                    Edit
                                </a>

                                <form action="products" method="post" style="display:inline;"
                                      onsubmit="return confirm('Are you sure you want to permanently delete \'<%= p.getName() %>\'?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= p.getId() %>">
                                    <button type="submit" class="btn-delete">
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <polyline points="3 6 5 6 21 6"></polyline>
                                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                        </svg>
                                        Delete
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <h3>No Products in Inventory</h3>
                                <p style="font-size: 13px; margin-top: 4px;">Use the form above to add your first product.</p>
                            </div>
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
function filterTable() {
    const input = document.getElementById("tableSearch");
    const filter = input.value.toLowerCase();
    const table = document.getElementById("productsTable");
    const rows = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

    for (let i = 0; i < rows.length; i++) {
        const text = rows[i].textContent || rows[i].innerText;
        rows[i].style.display = text.toLowerCase().indexOf(filter) > -1 ? "" : "none";
    }
}
</script>

</body>
</html>
