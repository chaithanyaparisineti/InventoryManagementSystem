
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Admin Login</title>

<link rel="stylesheet" href="css/style.css">

</head>

<body>

    <div class="container">

        <h1>Admin Login</h1>

        <p>Please enter your login details</p>

        <% if (request.getAttribute("error") != null) { %>

            <p style="color:red;">
                <%= request.getAttribute("error") %>
            </p>

        <% } %>

        <form action="login" method="post">

            <p>
                <input type="text"
                       name="username"
                       placeholder="Enter Username"
                       required>
            </p>

            <p>
                <input type="password"
                       name="password"
                       placeholder="Enter Password"
                       required>
            </p>

            <button type="submit">Login</button>

        </form>

    </div>

</body>
</html>
