<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Velart Order List</title>
    <link rel="stylesheet" href="css/listOrder.css">
</head>
<body>
    <div class="container">
        <h1>Order List</h1>
        <%
            String url = "jdbc:sqlserver://cosc-304-18.cv8agos8ieeu.us-east-2.rds.amazonaws.com:1433;databaseName=orders;encrypt=true;trustServerCertificate=true";
            String uid = "admin";
            String pw = "Ashanat.37";

            try {
                // Load the SQL Server driver class
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            } catch (ClassNotFoundException e) {
                out.println("ClassNotFoundException: " + e);
            }

            try (Connection con = DriverManager.getConnection(url, uid, pw);
                 Statement stmt = con.createStatement();) {
                // Query to retrieve order summary details
                ResultSet rst = stmt.executeQuery(
                    "SELECT orderId, orderDate, totalAmount, ordersummary.customerId, firstName, lastName " +
                    "FROM ordersummary " +
                    "JOIN customer ON ordersummary.customerId = customer.customerId"
                );
        %>
        <table class="order-table">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Order Date</th>
                    <th>Customer ID</th>
                    <th>Customer Name</th>
                    <th>Total Amount</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rst.next()) {
                        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                        int orderId = rst.getInt("orderId");

                        // Query to retrieve products in the order
                        String SQL = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";
                        PreparedStatement pstmt = con.prepareStatement(SQL);
                        pstmt.setInt(1, orderId);
                        ResultSet rs = pstmt.executeQuery();
                %>
                <tr>
                    <td><%= rst.getInt("orderId") %></td>
                    <td><%= rst.getTimestamp("orderDate") %></td>
                    <td><%= rst.getInt("customerId") %></td>
                    <td><%= rst.getString("firstName") + " " + rst.getString("lastName") %></td>
                    <td><%= currFormat.format(rst.getDouble("totalAmount")) %></td>
                </tr>
                <tr>
                    <td colspan="5">
                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th>Product ID</th>
                                    <th>Quantity</th>
                                    <th>Price</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getInt("productId") %></td>
                                    <td><%= rs.getInt("quantity") %></td>
                                    <td><%= currFormat.format(rs.getDouble("price")) %></td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
            } catch (SQLException ex) {
                out.println("SQL Exception: " + ex);
            } finally {
                closeConnection();
            }
        %>
    </div>
</body>
</html>
