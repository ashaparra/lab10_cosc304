<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="styles.css"> <!-- Optional external CSS -->
    <style>
        /* Signup Page Styles */
        .signup-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-color: #f8f9fa;
            padding: 20px;
        }

        .signup-container h1 {
            font-size: 2rem;
            color: #618244;
            margin-bottom: 20px;
        }

        form {
            width: 100%;
            max-width: 400px;
            background: #d6dfce;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 15px;
        }

        .form-group label {
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }

        .form-group input {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-family: 'Anka/Coder', monospace;
            font-size: 16px;
        }

        button {
            width: 100%;
            background-color: #618244;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background-color: #45a049;
        }

        footer {
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: #333;
        }

        footer a {
            color: #618244;
            text-decoration: none;
        }

        footer a:hover {
            text-decoration: underline;
        }
    </style>
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
            
            <button type="submit"><a href="index.jsp">Sign Up</a></button>

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
                        response.sendRedirect("index.jsp");
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
