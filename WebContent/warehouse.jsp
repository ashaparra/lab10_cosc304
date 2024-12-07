<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*, java.math.BigDecimal" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouses</title>
    <link rel="stylesheet" href="css/warehouse.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <!-- Main Container -->
    <div class="container">
        <h1 style="margin-top: 50px;">Warehouses Inventory</h1>    
        <%
            int previousWarehouseId = -1; 
            try {
                getConnection();
                Statement stmt = con.createStatement();
                ResultSet rst = stmt.executeQuery(
                    "SELECT productInventory.productId, product.productName, productInventory.warehouseId, warehouse.warehouseName, productInventory.quantity, productInventory.price " +
                    "FROM productInventory " +
                    "JOIN product ON productInventory.productId = product.productId " +
                    "JOIN warehouse ON warehouse.warehouseId = productInventory.warehouseId " +
                    "ORDER BY warehouseId ASC"
                );

                while (rst.next()) {
                    int productId = rst.getInt("productId");
                    int warehouseId = rst.getInt("warehouseId");
                    int quantity = rst.getInt("quantity");
                    String productName = rst.getString("productName");
                    String warehouseName = rst.getString("warehouseName");
                    BigDecimal price = rst.getBigDecimal("price");

                    // When warehouseId changes, close the previous table and start a new one
                    if (previousWarehouseId != warehouseId) {
                        if (previousWarehouseId != -1) {
                            // Close the previous table
        %>
                            </tbody>
                        </table>
                        <br>
        <%
                        }
                        // Start a new table for the current warehouse
        %>
        <h2>Warehouse: <%= warehouseName %> (ID: <%= warehouseId %>)</h2>
        <table class="order-table">
            <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Warehouse ID</th>
                    <th>Product Name</th>
                    <th>Warehouse Name</th>
                    <th>Quantity</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody>
        <%
                        previousWarehouseId = warehouseId;
                    }
        %>
            <tr>
                <form method="post" action="updateInventory.jsp">
                    <td><%= productId %></td>
                    <td><%= warehouseId %></td>
                    <td><%= productName %></td>
                    <td><%= warehouseName %></td>
                    <td>
                        <input type="number" name="quantity" value="<%= quantity %>" min="0" style="  box-sizing: border-box; height:100%" />
                        <input type="hidden" name="warehouseId" value="<%= warehouseId %>" />
                        <input type="hidden" name="productId" value="<%= productId %>" />
                    </td>
                    <td>
                        <input type="number" name="price" value="<%=price  %>" min="0" step="0.01"/>
                    </td>
                    <td style="border: 0cap; align-items:center; justify-items:center">
                        <button type="submit" class="update-button">Update Product</button>
                    </td>
            </tr>
        <%
                }
                if (previousWarehouseId != -1) {
        %>
            </tbody>
        </table>
        <%
                }
            } catch (SQLException ex) {
                out.println("<p>Error: " + ex.getMessage() + "</p>");
            } finally {
                closeConnection();
            }
        %>
    </div>
    
    <!-- Footer -->
    <div class="footer-section">
        <footer>
            <p>©️ 2024 Velart. All Rights Reserved</p>
            <nav>
                <a href="#top" class="back-to-top">Back to Top ↑</a>
            </nav>
        </footer>
    </div>
</body>
</html>
