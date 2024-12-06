<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
	<head>
		<title>Velart</title>
		<link type="text/css" rel="stylesheet" href="css/listprod.css">
		<script>
			function toggleForm() {
				const formContainer = document.getElementById('product-add-container');
				if (formContainer.style.display === 'none' || formContainer.style.display === '') {
					formContainer.style.display = 'block';
				} else {
					formContainer.style.display = 'none';
				}
			}
		</script>
	</head>
	<body>
		<div>
			<header id="nav">
				<ul>
					<li style="margin-right: auto; margin-top:55px; padding-left: 0;"><a href=index.jsp><img src="resources/logoT.png" alt="Velart logo" height="120px" style="margin: 0; padding: 0; margin-top:25px; margin-left:10px;" ></a></li>
						<%
					String userName = (String) session.getAttribute("authenticatedUserName");
					if (userName != null){
				%>	
					<li class="right-items"><a href="customer.jsp">Hi there <%= userName %> |</a></li>
				<%
					}
				%>		
					<li class="right-items"><a href="listprod.jsp">Products</a></li>
					<li class="right-items"><a href="listorder.jsp">Orders</a></li>
					<li class="right-items"><a href="showcart.jsp"><img src="resources/shopping-cart.png" alt="Shopping cart icon"  height="40px" justify-content:right ></a></li>
			
				</ul>
			</header>
		</div>
		<div class="title-search-container">
			<div class="title-search-container">
				<div>
					<h1>All Products</h1>
					<p>Ordered by most popular product</p>
					<div style="margin-top: 20px;">
					<button onclick="toggleForm()" style="background-color: #618244; color: white; padding: 10px 20px; border: none; border-radius: 5px; font-size: 16px;">
						Add New Product
					</button>
				</div>
				</div>
			</div>
			<div id="product-add-container" class="card" style="display: none; max-width: 500px; margin: 20px auto; padding: 20px;">
				<h2>Add New Product</h2>
				<form action="saveprod.jsp" method="post">
					<div style="margin-bottom: 10px;">
						<label for="productName">Product Name:</label>
						<input type="text" id="productName" name="productName" required style="width: 100%; padding: 8px;">
					</div>
					<div style="margin-bottom: 10px;">
						<label for="productPrice">Price:</label>
						<input type="number" id="productPrice" name="productPrice" step="0.01" required style="width: 100%; padding: 8px;">
					</div>
					<div style="margin-bottom: 10px;">
						<label for="productdesc">Product description:</label>
						<input type="text" id="productDesc" name="productDesc" step="0.01" required style="width: 100%; padding: 8px;">
					</div>
					<div style="margin-bottom: 10px;">
						<label for="productCategory">Category:</label>
						<select id="productCategory" name="productCategory" required style="width: 100%; padding: 8px;">
							<option value="">Select Category</option>
							<%
								try {
									getConnection();
									Statement stmt = con.createStatement();
									ResultSet rs = stmt.executeQuery("SELECT categoryId, categoryName FROM category");
									while (rs.next()) {
										int categoryId = rs.getInt("categoryId");
										String categoryName = rs.getString("categoryName");
							%>
							<option value="<%= categoryId %>"><%= categoryName %></option>
							<%
									}
									rs.close();
								} catch (SQLException ex) {
									out.println("<p>Error: " + ex.getMessage() + "</p>");
								} finally {
									closeConnection();
								}
							%>
						</select>
					</div>
					<div style="margin-bottom: 10px;">
						<label for="productImage">Product Image:</label>
						<input type="file" id="productImage" name="productImage" accept="image/*" required style="width: 100%; padding: 8px;">
					</div>
					<button type="submit" style="background-color: #618244; color: white; padding: 10px 20px; border: none; border-radius: 5px;">Submit</button>
				</form>
			</div>
          
			<div class="form-container" style="align-items: start; text-align: left; width: 35%;">
				<h2 style="margin-left: 10px; color:#618244;">Search for products</h2>
				<form method="get" action="listprod.jsp" style="margin-left: 10px;">
					<div class="form-group" style="width: 84%; margin-bottom: 10px;">
						<select name="category" id="category" style="
						display: block;
						width: 100%;
						padding: 0.375rem 0.75rem;
						font-size: 1rem;
						line-height: 1.5;
						color: #495057;
						background-color: #fff;
						border: 1px solid #ced4da;
						border-radius: 0.25rem;
						box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
						transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
						font-family: 'Anka/Coder', monospace;">
							<option value="">All Categories</option>
							<%
								try {
									getConnection();
									Statement stmt = con.createStatement();
									ResultSet rs = stmt.executeQuery("SELECT categoryName FROM category");
									while (rs.next()) {
										String category = rs.getString("categoryName");
										%>
										<option value="<%=category%>"><%=category%></option>
										<%
									}
									rs.close();
								} catch (SQLException ex) {
									out.println("<p>Error: " + ex.getMessage() + "</p>"); 
								}
							%>
						</select>
					</div>	
					<div style="width: 80%; margin-bottom: 10px;">
						<input type="text" name="productName" class="form-control" style="width: 100%;line-height: 1.5; ">
					</div>
					<div>
						<input type="submit" value="Submit" class="btn btn-success mr-2">
						<input type="reset" value="Reset" class="btn btn-secondary">
					</div>
					<span style="font-size: small; margin-top: 10px; display: inline-block;">
						(Leave blank for all products)
					</span>
				</form>
			</div>

		<% // Get product name to search for
		String name = request.getParameter("productName");
		if (name == null) {
			name = "";  
		}
		//Get category to search for
		String category = request.getParameter("category");
		int categoryId = 0;
		if (category == null || category == "All Categories") {
			category = "";  
		}
		else{
			try{
			getConnection();
			String SQL = "SELECT categoryId FROM category WHERE categoryName = ?";
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setString(1,category);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()){
				categoryId = rs.getInt("categoryId");
			}
			}catch(SQLException ex){
				out.println("<p>Error: " + ex.getMessage() + "</p>"); 
			}
			finally
			{
				closeConnection();
				
			}
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
		try {
			try (Connection con = DriverManager.getConnection(url, uid, pw)){
				ResultSet rs = null;
				if (name.isEmpty() && categoryId == 0) {
					Statement stmt = con.createStatement();
					rs = stmt.executeQuery("SELECT product.productId, product.productName, product.productPrice, product.productImageURL FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId GROUP BY product.productId,product.productName,product.productPrice,product.productImageURL ORDER BY SUM(orderproduct.quantity) DESC");

				} else if (name.isEmpty()) {
					String SQL = "SELECT product.productId, product.productName, product.productPrice, product.productImageURL FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId WHERE product.categoryId = ? GROUP BY product.productId,product.productName,product.productPrice,product.productImageURL ORDER BY SUM(orderproduct.quantity) DESC";
					PreparedStatement pstmt = con.prepareStatement(SQL);
					pstmt.setInt(1, categoryId);
					rs = pstmt.executeQuery();

				} else if (categoryId == 0) {
					System.out.println("Searching for: " + name);
					String SQL = "SELECT product.productId, product.productName, product.productPrice, product.productImageURL FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId WHERE productName LIKE ? GROUP BY product.productId,product.productName,product.productPrice,product.productImageURL ORDER BY SUM(orderproduct.quantity) DESC";
					PreparedStatement pstmt = con.prepareStatement(SQL);
					pstmt.setString(1, "%" + name + "%");
					rs = pstmt.executeQuery();

				} else {
					System.out.println("Searching for: " + name + " in category: " + categoryId);
					String SQL = "SELECT product.productId, product.productName, product.productPrice, product.productImageURL FROM product LEFT JOIN orderproduct ON product.productId = orderproduct.productId WHERE categoryId = ? AND productName LIKE ? GROUP BY product.productId,product.productName,product.productPrice,product.productImageURL ORDER BY SUM(orderproduct.quantity) DESC";
					PreparedStatement pstmt = con.prepareStatement(SQL);
					pstmt.setInt(1, categoryId);
					pstmt.setString(2, "%" + name + "%");
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