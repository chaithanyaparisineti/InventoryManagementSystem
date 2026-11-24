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

    String error   = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Stock Management</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f4f6f9;
    padding: 30px;
}
.container {
    max-width: 800px;
    margin: auto;
}
.card {
    background: white;
    padding: 25px;
    border-radius: 8px;
    box-shadow: 0 2px 8px #ddd;
    margin-bottom: 20px;
}
h1 { color: #1769aa; }
label { display: block; margin-top: 12px; font-weight: bold; }
select, input[type="number"] {
    width: 100%;
    padding: 9px;
    margin-top: 5px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 14px;
    box-sizing: border-box;
}
.btn-group { margin-top: 18px; display: flex; gap: 10px; }
button {
    padding: 10px 24px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    font-weight: bold;
}
.btn-in  { background: #28a745; color: white; }
.btn-out { background: #dc3545; color: white; }
.btn-in:hover  { background: #218838; }
.btn-out:hover { background: #c82333; }
.alert {
    padding: 12px 16px;
    border-radius: 4px;
    margin-bottom: 16px;
    font-weight: bold;
}
.alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
.alert-error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
.links { margin-top: 16px; }
.links a { margin-right: 16px; color: #1769aa; text-decoration: none; }
.links a:hover { text-decoration: underline; }
</style>
</head>

<body>
<div class="container">
<div class="card">

    <h1>Stock Management</h1>

    <div class="links">
        <a href="stock?action=history">&#128203; View Stock History</a>
        <a href="dashboard.jsp">&#8592; Back to Dashboard</a>
    </div>

    <%-- Success / Error messages --%>
    <% if ("1".equals(success)) { %>
        <div class="alert alert-success">&#10003; Stock updated successfully!</div>
    <% } else if ("invalid".equals(error)) { %>
        <div class="alert alert-error">&#10007; Invalid input. Please check product, quantity and type.</div>
    <% } else if ("insufficient".equals(error)) { %>
        <div class="alert alert-error">&#10007; Insufficient stock. Not enough quantity available.</div>
    <% } else if ("notfound".equals(error)) { %>
        <div class="alert alert-error">&#10007; Product not found in database.</div>
    <% } else if ("failed".equals(error)) { %>
        <div class="alert alert-error">&#10007; Stock update failed. Please try again.</div>
    <% } %>

    <form action="stock" method="post">

        <label for="productId">Select Product</label>
        <select name="productId" id="productId" required>
            <option value="">-- Select a product --</option>
            <%
                if (products != null) {
                    for (Product p : products) {
            %>
            <option value="<%= p.getId() %>">
                <%= p.getName() %> (Current Stock: <%= p.getQuantity() %>)
            </option>
            <%
                    }
                }
            %>
        </select>

        <label for="quantity">Quantity</label>
        <input type="number" name="quantity" id="quantity"
               min="1" placeholder="Enter quantity" required>

        <input type="hidden" name="type" id="stockType" value="IN">

        <div class="btn-group">
            <button type="submit" class="btn-in"
                    onclick="document.getElementById('stockType').value='IN'">
                &#43; Stock IN
            </button>
            <button type="submit" class="btn-out"
                    onclick="document.getElementById('stockType').value='OUT'">
                &#8722; Stock OUT
            </button>
        </div>

    </form>

</div>
</div>
</body>
</html>
