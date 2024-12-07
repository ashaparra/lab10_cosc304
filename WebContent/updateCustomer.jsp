<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phonenum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String customerId = request.getParameter("customerId");


    try{
        getConnection();
        String sql = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE customerId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, email);
        pstmt.setString(4, phonenum);
        pstmt.setString(5, address);
        pstmt.setString(6, city);
        pstmt.setString(7, state);
        pstmt.setString(8, postalCode);
        pstmt.setString(9, country);
        pstmt.setString(10, customerId);
        pstmt.executeUpdate();

        if(pstmt.getUpdateCount() > 0){
            session.setAttribute("message", "Customer ID: " + customerId + " updated successfully.");
        } else {
            session.setAttribute("message", "No changes were made to the customer information.");
        }
        response.sendRedirect("customer.jsp");
    }
    catch (SQLException e){
        out.println("SQL Exception: " + e);
        session.setAttribute("message", "An error occurred while updating the customer information.");
    }
    finally {
        closeConnection();
    }
%>