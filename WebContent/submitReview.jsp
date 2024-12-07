<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%
    String reviewRating = request.getParameter("rating");
    Timestamp reviewDate = new Timestamp(System.currentTimeMillis());
    int customerId = (int) session.getAttribute("customerId");
    String productId = request.getParameter("productId");
    String reviewComment = request.getParameter("comment");

    try{
        getConnection();
        String sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, reviewRating);
        pstmt.setTimestamp(2, reviewDate);
        pstmt.setInt(3, customerId);
        pstmt.setString(4, productId);
        pstmt.setString(5, reviewComment);
        pstmt.executeUpdate();
        if (pstmt.getUpdateCount() > 0){
            response.sendRedirect("listprod.jsp");
        }
    } catch (SQLException e){
        out.println("<p>Error inserting review: " + e.getMessage() + "</p>");
    }
    finally{
        closeConnection();
    }
%>