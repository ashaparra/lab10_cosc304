<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Velart Order List</title>
    <link rel="stylesheet" href="css/listOrder.css">
</head>
<body>
    <div class="container">
        <h1>Order List</h1>
        <%
            try {
                int customerId = (int) session.getAttribute("customerId");
                getConnection();
                String SQL0 = "SELECT orderId, orderDate, totalAmount, ordersummary.customerId, firstName, lastName FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId WHERE customer.customerId = ?";
                PreparedStatement pstmt0 = con.prepareStatement(SQL0);
                pstmt0.setInt(1, customerId);
                ResultSet rst = pstmt0.executeQuery();
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
