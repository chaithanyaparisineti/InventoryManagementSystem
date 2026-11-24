
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.inventory.model.Product" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Product> products =
        (List<Product>) request.getAttribute("products");

    int serialNo = 1;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Products</title>

<link rel="stylesheet" href="css/style.css">

<style>
    body {
        font-family: Arial, sans-serif;
        margin: 30px;
        background-color: #f4f6f9;
    }

    h2 {
        color: #333;
    }

    form {
        margin-bottom: 25px;
    }

    input, button {
        padding: 9px;
        margin: 5px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 12px;
        text-align: center;
    }

    th {
        background-color: #007bff;
        color: white;
    }

    .edit {
        color: blue;
        text-decoration: none;
    }

    .delete {
        color: red;
        text-decoration: none;
        border: none;
        background: none;
        cursor: pointer;
    }
</style>
</head>

<body>

<h2>Manage Products</h2>

<a href="dashboard.jsp">Back to Dashboard</a>

<hr>

<h3>Add New Product</h3>

<form action="products" method="post">

    <input type="hidden" name="action" value="add">

    <input type="text" name="name"
        placeholder="Product Name" required>

    <input type="text" name="category"
        placeholder="Category" required>

    <input type="number" name="price"
        placeholder="Price" min="0" step="0.01" required>

    <input type="number" name="quantity"
        placeholder="Quantity" min="0" required>

    <input type="number" name="supplierId"
        placeholder="Supplier ID" min="1" required>

    <button type="submit">Add Product</button>

</form>

<hr>

<h3>Product List</h3>

<table>

    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Category</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Supplier ID</th>
        <th>Actions</th>
    </tr>

    <%
        if (products != null && !products.isEmpty()) {
            for (Product p : products) {
    %>

    <tr>

        <!-- Display sequential number -->
        <td><%= serialNo++ %></td>

        <td><%= p.getName() %></td>

        <td><%= p.getCategory() %></td>

        <td><%= p.getPrice() %></td>

        <td><%= p.getQuantity() %></td>

        <td><%= p.getSupplierId() %></td>

        <td>

            <a class="edit"
               href="products?action=edit&id=<%= p.getId() %>">
                Edit
            </a>

            |

            <form action="products" method="post"
                  style="display:inline;"
                  onsubmit="return confirm('Are you sure you want to delete this product?');">

                <input type="hidden" name="action" value="delete">

                <!-- Actual database ID is used for deletion -->
                <input type="hidden" name="id"
                       value="<%= p.getId() %>">

                <button type="submit" class="delete">
                    Delete
                </button>

            </form>

        </td>

    </tr>

    <%
            }
        } else {
    %>

    <tr>
        <td colspan="7">No products available.</td>
    </tr>

    <%
        }
    %>

</table>

</body>
</html>


