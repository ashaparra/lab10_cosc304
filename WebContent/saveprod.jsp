<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%
String getproductname = request.getParameter("productName");
String getproductprice = request.getParameter("productPrice");
String getproductdesc = request.getParameter("productDesc");
String getproductcategory = request.getParameter("productCategory");


try {
    getConnection();
    String SQL = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?,?)";
    PreparedStatement pstmt = con.prepareStatement(SQL);
    pstmt.setString(1, getproductname);
    pstmt.setString(2, getproductprice);
    pstmt.setString(3, getproductdesc);
    pstmt.setString(4, getproductcategory);
    pstmt.executeUpdate();
    con.close();
} catch (Exception e) {
    out.println("Error: " + e);
}
%>  