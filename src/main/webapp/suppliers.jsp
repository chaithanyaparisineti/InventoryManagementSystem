
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.inventory.model.Supplier" %>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Supplier> suppliers =
        (List<Supplier>) request.getAttribute("suppliers");

    int serialNo = 1;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Supplier Management</title>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f6f9;
        margin: 0;
        padding: 30px;
    }

    .container {
        max-width: 1100px;
        margin: auto;
    }

    h2 {
        color: #333;
        margin-bottom: 10px;
    }

    .back-link {
        display: inline-block;
        margin-bottom: 20px;
        color: #007bff;
        text-decoration: none;
    }

    .section {
        background: white;
        padding: 25px;
        margin-bottom: 25px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }

    .form-group {
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
    }

    input {
        flex: 1;
        min-width: 180px;
        padding: 12px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }

    button {
        padding: 12px 22px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    button:hover {
        background-color: #0056b3;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
        background: white;
    }

    th, td {
        padding: 14px;
        border: 1px solid #ddd;
        text-align: center;
    }

    th {
        background-color: #007bff;
        color: white;
    }

    tr:nth-child(even) {
        background-color: #f8f9fa;
    }

    .edit-btn {
        background-color: #ffc107;
        color: black;
        padding: 7px 13px;
        border-radius: 4px;
        text-decoration: none;
    }

    .delete-btn {
        background-color: #dc3545;
        color: white;
        padding: 7px 13px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .delete-btn:hover {
        background-color: #bd2130;
    }

    .action-form {
        display: inline;
    }

    @media (max-width: 700px) {
        .section {
            overflow-x: auto;
        }

        table {
            min-width: 650px;
        }
    }
</style>

</head>

<body>

<div class="container">

    <h2>Supplier Management</h2>

    <a class="back-link" href="dashboard.jsp">
        ← Back to Dashboard
    </a>

    <!-- Add Supplier Section -->
    <div class="section">

        <h3>Add Supplier</h3>

        <form action="suppliers" method="post">

            <input type="hidden" name="action" value="add">

            <div class="form-group">

                <input type="text"
                       name="name"
                       placeholder="Supplier Name"
                       required>

                <input type="email"
                       name="email"
                       placeholder="Email"
                       required>

                <input type="tel"
                       name="phone"
                       placeholder="Phone"
                       required>

                <button type="submit">
                    + Add Supplier
                </button>

            </div>

        </form>

    </div>

    <!-- Supplier List Section -->
    <div class="section">

        <h3>Supplier List</h3>

        <table>

            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Actions</th>
            </tr>

            <%
                if (suppliers != null && !suppliers.isEmpty()) {
                    for (Supplier s : suppliers) {
            %>

            <tr>

                <td><%= serialNo++ %></td>

                <td><%= s.getName() %></td>

                <td><%= s.getEmail() %></td>

                <td><%= s.getPhone() %></td>

                <td>

                    <a class="edit-btn"
                       href="suppliers?action=edit&id=<%= s.getId() %>">
                        Edit
                    </a>

                    <form class="action-form"
                          action="suppliers"
                          method="post"
                          onsubmit="return confirm('Are you sure you want to delete this supplier?');">

                        <input type="hidden"
                               name="action"
                               value="delete">

                        <input type="hidden"
                               name="id"
                               value="<%= s.getId() %>">

                        <button class="delete-btn" type="submit">
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
                <td colspan="5">No suppliers available.</td>
            </tr>

            <%
                }
            %>

        </table>

    </div>

</div>

</body>
</html>

