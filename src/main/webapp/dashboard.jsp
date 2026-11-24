
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
<html>
<head>

<meta charset="UTF-8">
<title>Admin Dashboard</title>

<link rel="stylesheet" href="css/style.css">

</head>

<body>

    <div class="container">

        <h1>Inventory Management Dashboard</h1>

        <h2>
            Welcome, <%= admin.getUsername() %>!
        </h2>

        <p>You have successfully logged in.</p>

        <div class="menu">
		<a href="products">Manage Products</a>

        <a href="suppliers">Manage Suppliers</a>
<a href="stock">Manage Stock</a>
      
        </div>

        <br>

        <a href="logout">Logout</a>

    </div>

</body>
</html>
