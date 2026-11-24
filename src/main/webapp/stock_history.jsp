
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.inventory.model.StockHistory" %>

<%
    // Null-safe session check (session object itself may be null in edge cases)
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<StockHistory> history =
        (List<StockHistory>) request.getAttribute("history");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Stock History</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f4f6f9;
    padding: 30px;
}
.container {
    max-width: 1100px;
    margin: auto;
}
.card {
    background: white;
    padding: 25px;
    border-radius: 8px;
    box-shadow: 0 2px 8px #ddd;
}
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}
th, td {
    padding: 12px;
    border: 1px solid #ddd;
    text-align: center;
}
th {
    background: #1769aa;
    color: white;
}
.in {
    color: green;
    font-weight: bold;
}
.out {
    color: red;
    font-weight: bold;
}
</style>
</head>

<body>
<div class="container">
<div class="card">

<h1>Stock Transaction History</h1>

<p><a href="stock">Back to Stock Management</a></p>
<p><a href="dashboard.jsp">Back to Dashboard</a></p>

<table>
<tr>
    <th>S.No</th>
    <th>Transaction ID</th>
    <th>Product ID</th>
    <th>Product Name</th>
    <th>Type</th>
    <th>Quantity</th>
    <th>Transaction Date</th>
</tr>

<%
    int count = 1;

    if (history != null && !history.isEmpty()) {
        for (StockHistory h : history) {
%>
<tr>
    <td><%= count++ %></td>
    <td><%= h.getId() %></td>
    <td><%= h.getProductId() %></td>
    <td><%= h.getProductName() %></td>
    <td class='<%= "IN".equals(h.getType()) ? "in" : "out" %>'>
        <%= h.getType() %>
    </td>
    <td><%= h.getQuantity() %></td>
    <td><%= h.getTransactionDate() %></td>
</tr>
<%
        }
    } else {
%>
<tr>
    <td colspan="7">No stock transactions found.</td>
</tr>
<%
    }
%>

</table>

</div>
</div>
</body>
</html>

