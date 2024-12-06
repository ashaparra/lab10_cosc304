<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Velart Order Confirmation</title>
    <link rel="stylesheet" href="css/checkout.css"> 
</head>
<body>
    <div class="container">
        <h1>Confirm Your Order</h1>
        <%
            int customerId = (int) session.getAttribute("customerId");
            String custAddress = null, custCity = null, custState = null, custPostalCode = null, custCountry = null;

            try {
                getConnection();

                String SQL = "SELECT address, city, state, postalCode, country FROM customer WHERE customerId = ?";
                PreparedStatement pstmt = con.prepareStatement(SQL);
                pstmt.setInt(1, customerId);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    custAddress = rs.getString("address");
                    custCity = rs.getString("city");
                    custState = rs.getString("state");
                    custPostalCode = rs.getString("postalCode");
                    custCountry = rs.getString("country");
                }
            } catch (SQLException e) {
                out.println("Error: " + e.getMessage());
            } finally {
                closeConnection();
            }
        %>

        <form method="post" action="order.jsp">
            <!-- Customer Information -->
            <input type="hidden" name="customerId" value="<%= customerId %>">

            <div class="form-group">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address" value="<%= custAddress %>" size="50" required>
            </div>

            <div class="form-group">
                <label for="city">City:</label>
                <input type="text" id="city" name="city" value="<%= custCity %>" size="30" required>
            </div>

            <div class="form-group">
                <label for="state">State:</label>
                <input type="text" id="state" name="state" value="<%= custState %>" size="30" required>
            </div>

            <div class="form-group">
                <label for="postalCode">Postal Code:</label>
                <input type="text" id="postalCode" name="postalCode" value="<%= custPostalCode %>" size="20" required>
            </div>

            <div class="form-group">
                <label for="country">Country:</label>
                <input type="text" id="country" name="country" value="<%= custCountry %>" size="30" required>
            </div>

            <!-- Payment Information -->
            <h2>Payment Details</h2>
            <div class="form-group">
                <label for="paymentType">Payment Type:</label>
                <select id="paymentType" name="paymentType" required>
                    <option value="Credit Card">Credit Card</option>
                    <option value="Debit Card">Debit Card</option>
                </select>
            </div>

            <div class="form-group">
                <label for="paymentNumber">Payment Number:</label>
                <input type="text" id="paymentNumber" name="paymentNumber" maxlength="16" placeholder="Enter card number" required>
            </div>
            <div class="form-group">
                <label>Expiry Date:</label>
                <div class="expiry-date-container">
                    <select name="expiryMonth" required>
                        <option value="" disabled selected>Month</option>
                        <% for (int i = 1; i <= 12; i++) { %>
                            <option value="<%= i %>"><%= String.format("%02d", i) %></option>
                        <% } %>
                    </select>
                    <select name="expiryYear" required>
                        <option value="" disabled selected>Year</option>
                        <% for (int i = java.time.Year.now().getValue(); i <= java.time.Year.now().getValue() + 10; i++) { %>
                            <option value="<%= i %>"><%= i %></option>
                        <% } %>
                    </select>
                </div>
            <button type="submit">Confirm Order</button>
        </form>
    </div>
</body>
</html>
