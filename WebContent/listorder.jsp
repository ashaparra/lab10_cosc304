<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Velart Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
	
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

try (Connection con = DriverManager.getConnection(url,uid,pw);
	Statement stmt = con.createStatement();)
	{
		ResultSet rst = stmt.executeQuery("SELECT orderId, orderDate, totalAmount, ordersummary.customerId, firstName,lastName from ordersummary JOIN customer ON ordersummary.customerId=customer.customerId");
%>
		<table border="1">
			<thead>
				<tr>
					<th>Order Id</th>
					<th>Order Date</th>
					<th>Customer Id</th>
					<th>Customer Name</th>
					<th>Total Ammount</th>
				</tr>
				
			</thead>
			<tbody>
<%

			while(rst.next())
			{
				NumberFormat currFormat = NumberFormat.getCurrencyInstance();
				int orderId = rst.getInt("orderId");
				String SQL = "SELECT productId,quantity,price FROM orderproduct WHERE orderId = ?";
				PreparedStatement pstmt = con.prepareStatement(SQL);
				pstmt.setInt(1,orderId);

				ResultSet rs = pstmt.executeQuery();
%>
				<tr>
					<td><%= rst.getInt("orderId")%></td>
					<td><%= rst.getTimestamp("orderDate")%></td>
					<td><%= rst.getInt("customerId")%></td>
					<td><%= rst.getString("firstName")+" "+rst.getString("lastName")%></td>
					<td><%= currFormat.format(rst.getDouble("totalAmount"))%></td>
				
				</tr>
				<tr>
					<td colspan="5">
						<table border="1" >
							<thead>
								<tr>
									
									<th>Product Id</th>
									<th>Quantity</th>
									<th>Price</th>
									
								</tr>
							</thead>
							<tbody>
<%
					while(rs.next())	
					{	
%>
							<tr>
								<td><%= rs.getInt("productId")%></td>
								<td><%= rs.getInt("quantity")%></td>
								<td><%= rs.getInt("price")%></td>
							</tr>
<%
					}
%>
							</tbody>
						</table>
					</td>
				</tr>
<%
}
%>
			</tbody>
		</table>
	
<%
		}
	catch (SQLException ex) {
			out.println("SQL Exception: " + ex);
		}
	finally
	{
		closeConnection();
	}	



// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>

</body>
</html>