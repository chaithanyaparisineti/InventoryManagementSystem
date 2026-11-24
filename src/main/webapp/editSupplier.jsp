
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.inventory.model.Supplier" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Supplier s = (Supplier) request.getAttribute("supplier");

    if (s == null) {
        response.sendRedirect("suppliers");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Supplier</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="container">

    <h1>Edit Supplier</h1>

    <form action="suppliers" method="post">

        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<%= s.getId() %>">

        <label>Supplier Name</label>
        <input type="text" name="name"
               value="<%= s.getName() %>" required>

        <label>Email</label>
        <input type="email" name="email"
               value="<%= s.getEmail() %>" required>

        <label>Phone</label>
        <input type="text" name="phone"
               value="<%= s.getPhone() %>" required>

        <button type="submit">Update Supplier</button>

    </form>

    <p><a href="suppliers">Back to Suppliers</a></p>

</div>

</body>
</html>
