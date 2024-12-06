<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.util.Base64"%>

<html>
    <head>
        <title>Velart- Product Information</title>
        <link href="css/product.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>

    <%@ include file="header.jsp" %>

        <%
        // Get product name to search for
        // TODO: Retrieve and display info for the product
        ResultSet rs;
        PreparedStatement pstmt;
        try {
            getConnection();
        String getproductId = request.getParameter("id");
            String SQL = "SELECT productId, productName, productDesc,productPrice, productImage, productImageURL FROM product WHERE productId = ?";
            pstmt = con.prepareStatement(SQL);
                                pstmt.setString(1,getproductId);
                                rs = pstmt.executeQuery();
                if(rs.next()){
                    String productId = rs.getString("productId");
                    String productName = rs.getString("productName");
                    String productDesc = rs.getString("productDesc");
                    String productPrice = rs.getBigDecimal("productPrice").toString();
                    NumberFormat currFormat = NumberFormat.getCurrencyInstance(); 
                    String productImageURL = rs.getString("productImageURL");
                    if (productImageURL == null || productImageURL.trim().isEmpty()) {
                        productImageURL = "resources/Logo.png";
                    }
                    byte[] productImage = rs.getBytes("productImage");
                
                    
        %>
        <main style="flex: 1; display: flex; flex-direction: column; align-items: center; padding: 20px; overflow-y: auto;"">
        <div class="container text-center">
            <div class="row">
              <div class="col-6">
                <%
                if (productImage != null && productImage.length > 0 ){
                %>
                <img src="<%=productImageURL%>" style="max-width:60% ">
                <img src="displayImage.jsp?id=<%=productId%>" style="max-width:60%">
                <%
                } else {
                %>
                    <img src="<%=productImageURL%>" style="max-width:100%;display: flex; padding-top: 35px; ">
                <%
                }
                %>
              </div>
              <div class="col">
                <h2 style="margin-top: 20%;"><b><%=productName%></b></h2>
                <p style="margin-top: 5%;"><%=productDesc%></p>
                <p style="margin-top: 5%;">Price: <%= currFormat.format(rs.getBigDecimal("productPrice")) %></p> 
                <a href="addcart.jsp?id=<%=productId%>&name=<%=productName%>&price=<%=productPrice%>" 
                    class="add-to-cart-link">
                     <img src="resources/button.png" alt="Add to Cart">
                 </a>
                 
                 <a href="listprod.jsp" 
                    class="continue-shopping-link">
                     <img src="resources/continue.png" alt="Continue Shopping">
                 </a>
              </div>
            </div>
          </div>
          </main>
          <div class="footer-section" style="margin-top: 10px;">
            <footer>
                <p>©️ 2024 Velart. All Rights Reserved</p>
                <nav>
                    <a href="#top" class="back-to-top">Back to Top ↑</a>
                </nav>
            </footer>
        </div>
        
        <%
    }
    }
        catch (SQLException ex){
            out.println("Error: " + ex);   
            ex.printStackTrace();
        }
        finally
		{
			closeConnection();
		}	
         
        %>
        

    </body>
</html>

