<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.inventory.model.Supplier" %>

<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Supplier> suppliers =
        (List<Supplier>) request.getAttribute("suppliers");

    int totalSuppliers = (suppliers != null) ? suppliers.size() : 0;
    int emailCount = 0;
    int phoneCount = 0;

    if (suppliers != null) {
        for (Supplier s : suppliers) {
            if (s.getEmail() != null && !s.getEmail().trim().isEmpty()) emailCount++;
            if (s.getPhone() != null && !s.getPhone().trim().isEmpty()) phoneCount++;
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
<title>Supplier Management | Inventory System</title>
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
        max-width: 1200px;
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
        transition: transform 0.2s;
    }

    .stat-card:hover {
        transform: translateY(-2px);
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
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
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
        padding: 16px 20px;
        border-bottom: 1px solid #f1f5f9;
        font-size: 14px;
        color: #1e293b;
        vertical-align: middle;
    }

    tbody tr:hover {
        background: #f8fafc;
    }

    .supplier-name {
        font-weight: 600;
        color: var(--text-main);
    }

    .contact-link {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        color: #475569;
        text-decoration: none;
        font-size: 13px;
    }

    .contact-link:hover {
        color: var(--primary);
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
            <h1>🚚 Supplier Management</h1>
            <p>Maintain vendor directories, contact details and supply line accounts</p>
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
                <div class="stat-label">Active Suppliers</div>
                <div class="stat-value"><%= totalSuppliers %></div>
            </div>
            <div class="stat-icon icon-blue">🏢</div>
        </div>

        <div class="stat-card">
            <div>
                <div class="stat-label">Connected Emails</div>
                <div class="stat-value"><%= emailCount %></div>
            </div>
            <div class="stat-icon icon-emerald">✉️</div>
        </div>

        <div class="stat-card">
            <div>
                <div class="stat-label">Phone Contacts</div>
                <div class="stat-value"><%= phoneCount %></div>
            </div>
            <div class="stat-icon icon-purple">📞</div>
        </div>
    </div>

    <!-- Alert Messages -->
    <% if ("1".equals(success)) { %>
        <div class="alert alert-success">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
            Supplier saved successfully!
        </div>
    <% } else if ("invalid".equals(error)) { %>
        <div class="alert alert-danger">
            ⚠️ Invalid supplier data. Name, valid email, and phone number are required.
        </div>
    <% } else if ("failed".equals(error)) { %>
        <div class="alert alert-danger">
            ✕ Operation failed. If deleting, please ensure no products are linked to this supplier.
        </div>
    <% } %>

    <!-- Add Supplier Card -->
    <div class="card">
        <div class="card-header">
            <h2>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                Add New Supplier
            </h2>
        </div>

        <div class="card-body">
            <form action="suppliers" method="post">
                <input type="hidden" name="action" value="add">

                <div class="form-grid">
                    <div class="form-group">
                        <label for="name">Supplier / Company Name</label>
                        <input type="text" id="name" name="name" class="form-control"
                               placeholder="e.g. Acme Components" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" class="form-control"
                               placeholder="contact@supplier.com" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               placeholder="e.g. +91 9876543210" required>
                    </div>

                    <button type="submit" class="btn-submit">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Add Supplier
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Supplier Directory Card -->
    <div class="card">
        <div class="card-header">
            <h2>
                Supplier Directory
                <span class="badge-count"><%= totalSuppliers %> vendors</span>
            </h2>

            <div class="toolbar-search">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="supplierSearch" placeholder="Search suppliers..." onkeyup="filterSuppliers()">
            </div>
        </div>

        <div class="table-responsive">
            <table id="supplierTable">
                <thead>
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th>Supplier Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th style="text-align: right; padding-right: 25px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int serialNo = 1;
                        if (suppliers != null && !suppliers.isEmpty()) {
                            for (Supplier s : suppliers) {
                    %>
                    <tr>
                        <td style="color: var(--secondary); font-weight: 600;">#<%= s.getId() %></td>
                        <td>
                            <div class="supplier-name"><%= s.getName() %></div>
                        </td>
                        <td>
                            <a href="mailto:<%= s.getEmail() %>" class="contact-link">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                    <polyline points="22,6 12,13 2,6"></polyline>
                                </svg>
                                <%= s.getEmail() %>
                            </a>
                        </td>
                        <td>
                            <a href="tel:<%= s.getPhone() %>" class="contact-link">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                </svg>
                                <%= s.getPhone() %>
                            </a>
                        </td>
                        <td>
                            <div class="actions-cell">
                                <a class="btn-edit" href="suppliers?action=edit&id=<%= s.getId() %>">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                    </svg>
                                    Edit
                                </a>

                                <form action="suppliers" method="post" style="display:inline;"
                                      onsubmit="return confirm('Are you sure you want to delete supplier \'<%= s.getName() %>\'?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= s.getId() %>">
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
                        <td colspan="5" style="text-align: center; padding: 40px; color: var(--secondary);">
                            No suppliers found. Use the form above to add a supplier.
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
function filterSuppliers() {
    const filter = document.getElementById("supplierSearch").value.toLowerCase();
    const rows = document.getElementById("supplierTable").getElementsByTagName("tbody")[0].getElementsByTagName("tr");
    for (let i = 0; i < rows.length; i++) {
        const text = rows[i].textContent || rows[i].innerText;
        rows[i].style.display = text.toLowerCase().indexOf(filter) > -1 ? "" : "none";
    }
}
</script>

</body>
</html>
