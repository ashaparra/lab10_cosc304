<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/listprod.css" rel="stylesheet">
    <style>
        /* Custom Styles */
        .small-table {
            width: 60%; 
            margin: auto; 
        }

        .logged-user {
            text-align: center; 
            margin: 20px 0;
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
        }

        #editBtn {
            background-color: #28a745; 
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        #editBtn:hover {
            background-color: #218838;
        }
        footer {
            padding: 10px 0;
            margin-top: 20px;
        }
        html, body {
            margin: 0; 
            padding: 0;
            width: 100%;
            height: 100%;
            font-family: 'Anka/Coder', monospace;
        }
    </style>
    <script>
        function enableEditing() {
            document.querySelectorAll(".editable").forEach(function(input) {
                input.removeAttribute("readonly");
            });
            document.getElementById("saveBtn").style.display = "inline-block";
            document.getElementById("editBtn").style.display = "none";
        }
    </script>
</head>
<body>
    <!-- Navigation -->
    <header id="nav">
        <ul>
            <li style="margin-right: auto; margin-top:55px; padding-left: 0;">
                <a href="index.jsp"><img src="resources/logoT.png" alt="Velart logo" height="100px"></a>
            </li>
            <li class="right-items"><a href="listprod.jsp">Products</a></li>
            <li class="right-items"><a href="listorder.jsp">Orders</a></li>
            <li class="right-items">
                <a href="showcart.jsp"><img src="resources/shopping-cart.png" alt="Shopping cart icon" height="40px"></a>
            </li>
        </ul>
    </header>

    <%
        getConnection();
        ResultSet rs;
        String userName = (String) session.getAttribute("authenticatedUser");
        try {
            // Retrieve customer information
            String sql = "SELECT customerId, firstName, lastName, password, email, phonenum, address, city, state, postalCode, country, userid FROM customer WHERE userid = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userName);
            rs = pstmt.executeQuery();

            if (rs.next()) {
    %>
    <main class="container mt-4">
        <!-- Logged-In User -->
        <div class="logged-user">Logged in user: <%= userName %></div>

        <form action="updateCustomer.jsp" method="post">
            <table class="table table-bordered table-sm ">
                <tr>
                    <th>ID</th>
                    <td><%= rs.getInt("customerId") %></td>
                    <input type="hidden" name="customerId" value="<%= rs.getInt("customerId") %>">
                </tr>
                <tr>
                    <th>User name</th>
                    <td><%= rs.getString("userid") %></td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td><%= rs.getString("email") %></td>
                </tr>
                <tr>
                    <th>Password</th>
                    <td><input type="text" name="password" value="<%= rs.getString("password") %>" class="form-control editable" readonly></td>
                </tr>
                <tr>
                    <th>First Name</th>
                    <td><input type="text" name="firstName" value="<%= rs.getString("firstName") %>" class="form-control editable" readonly></td>
                </tr>
                <tr>
                    <th>Last Name</th>
                    <td><input type="text" name="lastName" value="<%= rs.getString("lastName") %>" class="form-control editable" readonly></td>
                </tr>
                <tr>
                    <th>Phone</th>
                    <td><input type="text" name="phonenum" value="<%= rs.getString("phonenum") %>" class="form-control editable" readonly></td>
                </tr>
                <tr>
                    <th>Address</th>
                    <td><input type="text" name="address" value="<%= rs.getString("address") %>" class="form-control editable" readonly></td>
                </tr>
                <tr>
                    <th>City</th>
                    <td><input type="text" name="city" value="<%= rs.getString("city") %>" class="form-control editable" readonly></td>
                </tr>
                <tr>
                    <th>State</th>
                    <td><input type="text" name="state" value="<%= rs.getString("state") %>" class="form-control editable" readonly></td>
                </tr>
                <tr>
                    <th>Postal Code</th>
                    <td><input type="text" name="postalCode" value="<%= rs.getString("postalCode") %>" class="form-control editable" readonly></td>
                </tr>
                <tr>
                    <th>Country</th>
                    <td><input type="text" name="country" value="<%= rs.getString("country") %>" class="form-control editable" readonly></td>
                </tr>
            </table>

            <!-- Buttons -->
            <div class="text-center">
                <button type="button" id="editBtn" class="btn btn-success" onclick="enableEditing()">Edit</button>
                <button type="submit" id="saveBtn" class="btn btn-success" style="display: none;">Save Changes</button>
            </div>
        </form>
    </main>
    <%
            } else {
                out.println("<p class='text-center text-danger'>No customer data found for this user.</p>");
            }
        } catch (SQLException ex) {
            out.println("<p class='text-center text-danger'>Error: " + ex.getMessage() + "</p>");
        } finally {
            closeConnection();
        }
    %>

    <!-- Footer -->
    <div class="footer-section text-center mt-4">
        <footer>
            <p>©️ 2024 Velart. All Rights Reserved</p>
            <nav>
                <a href="#top" class="back-to-top">Back to Top ↑</a>
            </nav>
        </footer>
    </div>
</body>
</html>
