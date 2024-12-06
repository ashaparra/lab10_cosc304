<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>


<html>
<head>
<title>Velart Shipment Processing</title>
<link rel="stylesheet" href="css/ship.css">
</head>
<body>

	<main style="flex: 1; display: flex; flex-direction: column; align-items: center; padding: 20px; overflow-y: auto;">
		<div class="main-container">
		<%
		int productId = -1;
		try{
			// TODO: Get order id
			String getorderId = request.getParameter("orderId");
				
			// TODO: Check if valid order id in database
			getConnection();
			// TODO: Start a transaction (turn-off auto-commit)
				con.setAutoCommit(false);
			ResultSet rs;
			String sql = "SELECT orderId from ordersummary WHERE orderId = ?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1,getorderId);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				// TODO: Retrieve all items in order with given id
				int getorderId2 = rs.getInt("orderId");
				String sql2="SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
				PreparedStatement pstmt2 = con.prepareStatement(sql2);
				pstmt2.setInt(1,getorderId2);
				ResultSet rst = pstmt2.executeQuery();

				// TODO: Create a new shipment record.
				Statement stmt = con.createStatement();
				stmt.executeUpdate("INSERT INTO shipment (shipmentDate,warehouseId) VALUES (GETDATE(),1)");
		%>		
				<table>
					<tr>
						<th>Product ID</th>
						<th>Quantity Ordered</th>
						<th>Previous Inventory</th>
						<th>New Inventory</th>
					</tr>
		<%
				// TODO: For each item verify sufficient quantity available in warehouse 1.
				boolean canBeShipped=true;
				while(rst.next()){
					int orderporductId = rst.getInt("productId");
					int orderQuantity= rst.getInt("quantity");
					productId = orderporductId;
					String sql3="SELECT productId, quantity FROM productinventory WHERE productId = ? AND ? <= quantity AND warehouseId=1";
					PreparedStatement pstmt3 = con.prepareStatement(sql3);
					pstmt3.setInt(1,orderporductId);
					pstmt3.setInt(2,orderQuantity);
					ResultSet rst2 = pstmt3.executeQuery();
					// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
					if(rst2.next()){
						int previousInventory = rst2.getInt("quantity");
						int newInventory = previousInventory - orderQuantity;
						String sql4="UPDATE productinventory SET quantity = quantity-? WHERE productId=?";
						PreparedStatement pstmt4 = con.prepareStatement(sql4); 
						pstmt4.setInt(1,orderQuantity);
						pstmt4.setInt(2,orderporductId);
						pstmt4.executeUpdate();
						con.commit();
		%>			
						<tr>
							<td><%= rst2.getInt("productId") %></td>
							<td><%= rst2.getInt("quantity") %></td>
							<td><%= previousInventory %></td>
							<td><%= newInventory %></td>
						</tr>
		<%
						
					}

					else{
		%>
				<div class="message error">
					<p>Error: Insufficient inventory for Product ID:<%=productId%></p>
				</div>
		<%
						con.rollback();
						canBeShipped=false;
						break;
					}
				}
		%>
			</table>
		<%
				if(canBeShipped){
		%>
					
						<div class= "message success">
							<h3>It's shipped</h3>
						</div>
		<%

				}

					// TODO: Auto-commit should be turned back on
					con.setAutoCommit(true);
				}
					
				}
				catch (SQLException ex){
					out.println("<p>Error: " + ex.getMessage()+ "</p>");
				}
				finally
				{
					closeConnection();
				}	
				
			%>                       				
			<div>
				<h2><a href="index.jsp">Back to Main Page</a></h2>
			</div>
		</main>   
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