
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.inventory.model.Product" %>

<%
    if (session.getAttribute("admin") == null) {
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
<html>
<head>
<meta charset="UTF-8">
<title>Edit Product</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f4f6f9;
    padding: 30px;
}

.container {
    max-width: 500px;
    margin: auto;
    background: white;
    padding: 25px;
    border-radius: 8px;
}

input {
    width: 95%;
    padding: 11px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 4px;
}

button {
    padding: 11px 20px;
    background: #007bff;
    color: white;
    border: none;
    cursor: pointer;
    border-radius: 4px;
}
</style>
</head>

<body>

<div class="container">

    <h2>Edit Product</h2>

    <form action="products" method="post">

        <input type="hidden" name="action" value="update">

        <input type="hidden" name="id"
            value="<%= product.getId() %>">

        <label>Product Name</label>
        <input type="text" name="name"
            value="<%= product.getName() %>" required>

        <label>Category</label>
        <input type="text" name="category"
            value="<%= product.getCategory() %>" required>

        <label>Price</label>
        <input type="number" name="price"
            value="<%= product.getPrice() %>"
            min="0" step="0.01" required>

        <label>Quantity</label>
        <input type="number" name="quantity"
            value="<%= product.getQuantity() %>"
            min="0" required>

        <label>Supplier ID</label>
        <input type="number" name="supplierId"
            value="<%= product.getSupplierId() %>"
            min="1" required>

        <button type="submit">Update Product</button>

    </form>

    <p><a href="products">Back to Products</a></p>

</div>

</body>
</html>

