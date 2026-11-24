<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.inventory.model.Product" %>

<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Product product = (Product) request.getAttribute("product");

    if (product == null) {
        response.sendRedirect("products");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Product | Inventory System</title>
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
        padding: 40px 20px;
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .edit-container {
        max-width: 580px;
        width: 100%;
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: var(--radius);
        box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.03);
        overflow: hidden;
    }

    .card-header {
        padding: 24px 30px;
        border-bottom: 1px solid var(--border-color);
        background: #ffffff;
    }

    .card-header h2 {
        font-size: 20px;
        font-weight: 700;
        color: var(--text-main);
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .card-header p {
        font-size: 13px;
        color: var(--text-muted);
        margin-top: 4px;
    }

    .card-body {
        padding: 30px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: #334155;
        margin-bottom: 6px;
    }

    .form-control {
        width: 100%;
        padding: 11px 15px;
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

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
    }

    .actions-footer {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 12px;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid var(--border-color);
    }

    .btn-cancel {
        display: inline-flex;
        align-items: center;
        padding: 10px 18px;
        background: #f1f5f9;
        color: var(--text-muted);
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s;
    }

    .btn-cancel:hover {
        background: #e2e8f0;
        color: var(--text-main);
    }

    .btn-submit {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: var(--primary);
        color: white;
        border: none;
        padding: 11px 24px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2);
        transition: all 0.2s ease;
    }

    .btn-submit:hover {
        background: var(--primary-hover);
        box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3);
        transform: translateY(-1px);
    }
</style>
</head>

<body>

<div class="edit-container">

    <div class="card-header">
        <h2>✏️ Edit Product</h2>
        <p>Update product information and stock values for ID #<%= product.getId() %></p>
    </div>

    <div class="card-body">
        <form action="products" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= product.getId() %>">

            <div class="form-group">
                <label for="name">Product Name</label>
                <input type="text" id="name" name="name" class="form-control"
                       value="<%= product.getName() %>" required>
            </div>

            <div class="form-group">
                <label for="category">Category</label>
                <input type="text" id="category" name="category" class="form-control"
                       value="<%= product.getCategory() %>" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="price">Price (&#8377;)</label>
                    <input type="number" id="price" name="price" class="form-control"
                           value="<%= product.getPrice() %>" min="0" step="0.01" required>
                </div>

                <div class="form-group">
                    <label for="quantity">Quantity</label>
                    <input type="number" id="quantity" name="quantity" class="form-control"
                           value="<%= product.getQuantity() %>" min="0" required>
                </div>
            </div>

            <div class="form-group">
                <label for="supplierId">Supplier ID</label>
                <input type="number" id="supplierId" name="supplierId" class="form-control"
                       value="<%= product.getSupplierId() %>" min="1" required>
            </div>

            <div class="actions-footer">
                <a href="products" class="btn-cancel">Cancel</a>
                <button type="submit" class="btn-submit">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    Save Changes
                </button>
            </div>
        </form>
    </div>

</div>

</body>
</html>
