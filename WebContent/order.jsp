<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Velart Order Processing</title>
</head>
<body>

<% 
// Get customer id
int custId = Integer.parseInt(request.getParameter("customerId"));
String custAddress = request.getParameter("address");
String custCity = request.getParameter("city");
String custState = request.getParameter("state");
String custPostalCode = request.getParameter("postalCode");
String custCountry = request.getParameter("country");
String paymentType = request.getParameter("paymentType");
String paymentNumber = request.getParameter("paymentNumber");
String expiryMonth = request.getParameter("expiryMonth");
String expiryYear = request.getParameter("expiryYear");
String paymentExpiryDate = expiryYear + "-" + String.format("%02d", Integer.parseInt(expiryMonth)) + "-01";

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

try
	{	// Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	}
	catch (java.lang.ClassNotFoundException e)
	{
		out.println("ClassNotFoundException: " +e);
	}
	String url = "jdbc:sqlserver://cosc-304-18.cv8agos8ieeu.us-east-2.rds.amazonaws.com:1433;databaseName=orders;encrypt=true;trustServerCertificate=true";
	String uid = "admin";
	String pw = "Ashanat.37";
	try (Connection con = DriverManager.getConnection(url, uid, pw)){
			ResultSet rs;
			// Determine if valid customer id was entered
			String SQL = "SELECT * FROM customer WHERE customerId = ?";
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setInt(1,custId);

			rs = pstmt.executeQuery();
			if(rs.next()){
				// Determine if there are products in the shopping cart
				if (productList == null)
				{
%>
					<h1>Your cart is empty</h1>
					<body>Please select a product to continue</body>
<%
					return;
				}
			}
			else{
%>
				<h1>Invalid Customer Id</h1>
				<body>Please enter a valid customer id</body>
<%
			}
			try {
				// Insert payment details into the paymentmethod table
				String SQL1 = "INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES (?, ?, ?, ?)";
				PreparedStatement pstmt1 = con.prepareStatement(SQL1);
				pstmt1.setString(1, paymentType);
				pstmt1.setString(2, paymentNumber);
				pstmt1.setString(3, paymentExpiryDate);
				pstmt1.setInt(4, custId);
				pstmt1.executeUpdate();
		
				// Use out.println to display debug information
				out.println("<h3>Payment Details Debug Info:</h3>");
				out.println("<p>Payment Type: " + paymentType + "</p>");
				out.println("<p>Payment Number " + paymentNumber + "</p>");
				out.println("<p>Payment Expiry Date: " + paymentExpiryDate + "</p>");
		
			} catch (SQLException e) {
				// Log error to the JSP page
				out.println("<p>Error inserting payment details: " + e.getMessage() + "</p>");
			}
			
		
		// Save order information to database
		String SQL2 = "INSERT INTO ordersummary (customerId, orderDate, shiptoAddress,shiptoCity,shiptoState,shiptoPostalCode, shiptoCountry) VALUES (?,?,?,?,?,?,?)";
		PreparedStatement pstmt2 = con.prepareStatement(SQL2,Statement.RETURN_GENERATED_KEYS);
		pstmt2.setInt(1,custId);
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		pstmt2.setTimestamp(2,timestamp);
		pstmt2.setString(3,custAddress);
		pstmt2.setString(4,custCity);
		pstmt2.setString(5,custState);
		pstmt2.setString(6,custPostalCode);
		pstmt2.setString(7,custCountry);
		pstmt2.executeUpdate();
	
		ResultSet keys = pstmt2.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);

	// Insert each item into OrderProduct table using OrderId from previous INSERT
	String SQL3 = "INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (?,?,?,?)";
	PreparedStatement pstmt3 = con.prepareStatement(SQL3);
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
		String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
		pstmt3.setInt(1,orderId);
		pstmt3.setString(2,productId);
		pstmt3.setInt(3,qty);
		pstmt3.setDouble(4,pr);
		pstmt3.executeUpdate();
	}
	
// Update total amount for order record
String SQL4 = "SELECT SUM(quantity*price) AS totalAmount FROM orderproduct WHERE orderId = ?";
PreparedStatement pstmt4 = con.prepareStatement(SQL4);
pstmt4.setInt(1,orderId);
ResultSet rs4 = pstmt4.executeQuery();

String SQL5 = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
PreparedStatement pstmt5 = con.prepareStatement(SQL5);
BigDecimal totalAmount = BigDecimal.ZERO;
if(rs4.next()){
	totalAmount = rs4.getBigDecimal("totalAmount");
	pstmt5.setBigDecimal(1,totalAmount);
	pstmt5.setInt(2,orderId);
	pstmt5.executeUpdate();
}
else{
%>
	<h1>Something went wrong</h1>
<%
}
// Print out order summary
String SQL6 = "SELECT orderproduct.productId, productName, quantity, orderproduct.price, (quantity*price) AS subtotal, totalAmount FROM product JOIN orderproduct ON product.productId=orderproduct.productId JOIN ordersummary ON ordersummary.orderId = orderproduct.orderId WHERE orderproduct.orderId= ?";
PreparedStatement pstmt6 = con.prepareStatement(SQL6);
pstmt6.setInt(1,orderId);
ResultSet rs5 = pstmt6.executeQuery();
%>
<h2>You got them!</h2>
	<p1>You have successfully placed your order</p1>
	<br>
	<table>
		<thead>
			<tr>
				<th>Product Id</th>
				<th>Product Name</th>
				<th>Quantity</th>
				<th>Price</th>
				<th>Subtotal</th>
			</tr>
		</thead>
		<tbody>
	
<%
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
;
while(rs5.next()){
	
%>

		<tr>
			<td><%=rs5.getInt("productId")%></td>
			<td><%=rs5.getString("productName")%></td>
			<td><%=rs5.getInt("quantity")%></td>
			<td><%=currFormat.format(rs5.getBigDecimal("price"))%></td>
			<td><%=currFormat.format(rs5.getBigDecimal("subtotal"))%></td>
		</tr>
<%
	}
%>		
		</tbody>
	</table>
	<h2>Order Total: <%= currFormat.format(totalAmount) %></h2>
<%

session.setAttribute("productList", null);
}
catch (Exception e)
{
	
	out.println("Error: " +e);
}
finally
{
	closeConnection();
}	
%>


</body>
</html>

