<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Screen</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
    <!-- Main container -->
    <div class="login-container">
        <!-- Logo Section -->
        <div class="logo">
            <img src="resources/logoT.png" alt="Logo" />
        </div>

        <!-- Login Form Card -->
        <div class="login-card">
            <h2>Log in to Velart</h2>

            <!-- Display login error message -->
            <% 
                if (session.getAttribute("loginMessage") != null) { 
            %>
                <p class="error-message"><%= session.getAttribute("loginMessage").toString() %></p>
            <% } %>

            <!-- Login Form -->
            <form name="MyForm" method="post" action="validateLogin.jsp">
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" maxlength="10" required />
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" maxlength="10" required />
                </div>
                <button type="submit" class="submit-button">Log In</button>
            </form>
        </div>
    </div>
</body>
</html>
