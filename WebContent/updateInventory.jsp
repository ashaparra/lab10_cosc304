<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%
    int productId = Integer.parseInt(request.getParameter("productId"));
    int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
    int quantity = Integer.parseInt(request.getParameter("quantity"));
    BigDecimal price = new BigDecimal(request.getParameter("price"));

    try{
        getConnection();
        String sql="SELECT quantity, price FROM productInventory WHERE productId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, productId);
        ResultSet rs = pstmt.executeQuery();

        if(rs.next()){
            int storedQuantity = rs.getInt("quantity");
            BigDecimal storedPrice = rs.getBigDecimal("price");
            if(quantity != storedQuantity && price != storedPrice){
                String sql2 = "UPDATE productInventory SET quantity = ?, price = ? WHERE productId = ? AND warehouseId = ?";
                PreparedStatement pstmt2 = con.prepareStatement(sql2);
                pstmt2 = con.prepareStatement(sql2);
                pstmt2.setInt(1, quantity);
                pstmt2.setBigDecimal(2, price);
                pstmt2.setInt(3, productId);
                pstmt2.setInt(4, warehouseId);
                pstmt2.executeUpdate();
            } else if(quantity != storedQuantity && price == storedPrice){
                String sql2 = "UPDATE productInventory SET quantity = ? WHERE productId = ? AND warehouseId = ?";
                PreparedStatement pstmt2 = con.prepareStatement(sql2);
                pstmt2 = con.prepareStatement(sql2);
                pstmt2.setInt(1, quantity);
                pstmt2.setInt(2, productId);
                pstmt2.setInt(3, warehouseId);
                pstmt2.executeUpdate();
            } else if (quantity == storedQuantity && price != storedPrice){
                String sql2 = "UPDATE productInventory SET price = ? WHERE productId = ? AND warehouseId = ?";
                PreparedStatement pstmt2 = con.prepareStatement(sql2);
                pstmt2 = con.prepareStatement(sql2);
                pstmt2.setBigDecimal(1, price);
                pstmt2.setInt(2, productId);
                pstmt2.setInt(3, warehouseId);
                pstmt2.executeUpdate();
            } else {
                session.setAttribute("message", "No changes were made to the product inventory.");
            }
        System.out.println("Product ID: " + productId + " updated successfully.");
        } else {
            session.setAttribute("message", "Product ID: " + productId + " is not available in the inventory.");
        }
    }
    catch (SQLException e){
        out.println("SQL Exception: " + e);

        session.setAttribute("message", "An error occurred while updating the product inventory.");
    }
    finally {
        closeConnection();
    }
    response.sendRedirect("warehouse.jsp");



%>