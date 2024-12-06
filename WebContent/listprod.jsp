<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
	<head>
		<title>Velart</title>
		<link type="text/css" rel="stylesheet" href="css/listprod.css">
	</head>
	<body>
		<div>
			<header id="nav">
				<ul>
					<li style="margin-right: auto; margin-top:55px; padding-left: 0;"><a href=index.jsp><img src="resources/logoT.png" alt="Velart logo" height="120px" style="margin: 0; padding: 0; margin-top:25px; margin-left:10px;" ></li>
					<li class="right-items"><a href="listprod.jsp">Products</a></li>
					<li class="right-items"><a href="listorder.jsp">Orders</a></li>
					<li class="right-items"><a href="showcart.jsp"><img src="resources/shopping-cart.png" alt="Shopping cart icon"  height="40px" justify-content:right ></a></li>
				</ul>
			</header>
		</div>
		<div class="title-search-container">
			<h1 style="margin-left:10px; margin-top:50px;">All Products</h1>
			<div class="form-container">
			<h2 style="text-align:right; margin-right:210px; color:#618244;">Search for products</h2>

			<form method="get" action="listprod.jsp" style="text-align: right; margin-right: 20px;">
			<input type="text" name="productName" size="50">
			<input type="submit" value="Submit"><input type="reset" value="Reset"> 
			<br>
			<span style="font-size: small; margin-top: 10px; display: inline-block; margin-right:230px;">
				(Leave blank for all products)
			</span>
			</form>
		<% // Get product name to search for
		String name = request.getParameter("productName");
		if (name == null) {
			name = "";  
		}

				
		//Note: Forces loading of SQL Server driver
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			out.println("ClassNotFoundException: " +e);
		}

		// Variable name now contains the search string the user entered
		// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

		// Make the connection
		String url = "jdbc:sqlserver://cosc-304-18.cv8agos8ieeu.us-east-2.rds.amazonaws.com:1433;databaseName=orders;encrypt=true;trustServerCertificate=true";
		String uid = "admin";
		String pw = "Ashanat.37";
		try {
			try (Connection con = DriverManager.getConnection(url, uid, pw)){
				ResultSet rs;
				if(name.isEmpty()){
					Statement stmt = con.createStatement();
					rs = stmt.executeQuery("SELECT productId, productName, productPrice, productImageURL FROM product");
				}
				else{
					String SQL = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE ?";
					PreparedStatement pstmt = con.prepareStatement(SQL);
					pstmt.setString(1,"%"+name+"%");
					rs = pstmt.executeQuery();
				}

				%>
				</div>
			</div>
			<div class="product-container"> 
				<%
					while (rs.next()) {
						String productId = rs.getString("productId");
						String productName = rs.getString("productName");
						String productPrice = rs.getBigDecimal("productPrice").toString();
						NumberFormat currFormat = NumberFormat.getCurrencyInstance(); 
						String productImageUrl = rs.getString("productImageURL");
						if (productImageUrl == null || productImageUrl.trim().isEmpty()) {
							// Use a default image if no URL is provided
							productImageUrl = "resources/logo.png";
						}
					%>
					<div class="card"> 
						<img src="<%=productImageUrl%>" alt="<%= productName %>" style="width:100%; height:auto" > 
						<div class="card-content">
							<a href="product.jsp?id=<%=productId%>" class="product-link" style="text-decoration:none;color:black;"><h4><%=productName%></h4></a>
							<p style="margin-top: 0%;">Price: <%= currFormat.format(rs.getBigDecimal("productPrice")) %></p> 
							<a href="addcart.jsp?id=<%=productId%>&name=<%=productName%>&price=<%=productPrice%>" style="display:flex; align-items:center;justify-content:center; margin-bottom: 10px;">
							<img src="resources/button.png" alt="Add to Cart" class="add-to-cart-icon"></a>
						</div>
					</div>
					<%
						}
						rs.close();
					%>
			</div>
			<div class="footer-section">
				<footer>
					<p>©️ 2024 Velart. All Rights Reserved</p>
					<nav>
						<a href="#top" class="back-to-top">Back to Top ↑</a>
					</nav>
				</footer>
			</div>
				
				<%
			} 
		}catch (SQLException ex) {
				out.println("<p>Error: " + ex.getMessage() + "</p>"); 
			}
		finally
			{
				closeConnection();
			}	
		%>
	</body>
</html>