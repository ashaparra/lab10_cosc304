<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="css/createAccount.css">

</head>
<body>
    <div class="signup-container">
        <img src="resources/logoT.png" alt="Velart logo" height="100px">
        <h1>Create an account</h1>
        <form action="createAccount.jsp" method="POST">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <div class="form-group">
                <label for="confirm-password">Confirm Password:</label>
                <input type="password" id="confirm-password" name="confirm_password" required>
            </div>
            
            <button type="submit">Sign Up</button>

        <%
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");


        if (username != null && email != null && password != null && confirmPassword != null) {
            // Check if the passwords match
            if (!password.equals(confirmPassword)) {
                out.println("<p style='color:red;'>Passwords do not match</p>");
            } else {
                try {
                    getConnection();
                    String SQL = "SELECT userid FROM customer WHERE userid = ?";
                    PreparedStatement pstmt = con.prepareStatement(SQL);
                    pstmt.setString(1,username);
                    ResultSet rs = pstmt.executeQuery();

                    if (rs.next()) {
                        out.println("<p style='color:red;'>Username already taken</p>");
                    } else {
                        // Insert the user into the database
                        SQL = "INSERT INTO customer (userid, email, password) VALUES (?, ?, ?)";
                        pstmt = con.prepareStatement(SQL);
                        pstmt.setString(1, username);
                        pstmt.setString(2, email);
                        pstmt.setString(3, password);
                        pstmt.executeUpdate();
                        out.println("<p style='color:green;'>Account created successfully</p>");
                        response.sendRedirect("login.jsp");
                        return; // Stop further processing
                    }
               
                } catch (SQLException ex) {
                    out.println("<p>Error: " + ex.getMessage() + "</p>");
                } finally {
                    closeConnection();
                }
            }
        }
        %>
        </form>
        <footer>
            Already have an account? <a href="login.jsp">Log in</a>
        </footer>
    </div>
</body>
</html>
