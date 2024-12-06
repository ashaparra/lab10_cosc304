<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title >Your Shopping Cart</title>
</head>
<link rel="stylesheet" href="css/showcart.css">
<body style=" margin: 20; padding: 0; background-color:white ">
<header id="nav">
	<ul>
		<li style="margin-right: auto; margin-top:55px; padding-left: 0;"><a href="index.jsp"><img src="resources/logoT.png" alt="Velart logo" height="100px" style="margin: 0; padding: 0;" ></a></li>
		<li class="right-items"><a href="listprod.jsp">Products</a></li>
		<li class="right-items"><a href="listorder.jsp">Orders</a></li>
		<li class="right-items"><a href="showcart.jsp"><img src="resources/shopping-cart.png" alt="Shopping cart icon"  height="40px" justify-content:right ></a></li>
	</ul>
</header>


<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	

	out.println("<h1>Your shopping cart is empty!</h1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
%>
<div style="display: flex; flex-direction: column; align-items: center; margin-top: 20px;">
	<h1 style='color:#618244'>Your Shopping Cart</h1>
</div>
<div style="justify-items:center; flex: 1;">
	<form action="updatecart.jsp" method="post">
	<table style="border-spacing: 10px; ">
		<tr>
			<th>Product Id</th>
			<th>Product Name</th>
			<th>Quantity</th>
			<th>Price</th>
			<th>Subtotal</th>
		</tr>

<%
	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		String productId = (String) product.get(0); 
%>

		<tr>
			<td><%= product.get(0) %></td>
			<td><%= product.get(1) %></td>
			<td align="center">
				<input type="number" name="quantity_<%= product.get(0) %>" value="<%= product.get(3) %>" min="0" style="width: 50px;">
			</td>
		
<% 
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}
		finally
		{
			closeConnection();
		}		
%>
		<td align="right"><%=currFormat.format(pr)%></td>
		<td align="right"><%=currFormat.format(pr*qty)%></td>
		<td align="center">
			<a href="removeitem.jsp?productId=<%=productId%>">
				<img src="resources/trash.png" alt="Remove Item" style="width: 30px; height: auto; border-radius: 5px;">
			</a>
		</td>
		</tr>
		
		
<%
		total = total +pr*qty;
	}
%>
	
		<tr style="border-top: 2px solid #ddd; padding-top: 20px;">
			<td colspan="4" align="right"><b style='color:#618244'>Order Total</b></td>
			<td align="right"><%=currFormat.format(total)%></td>
		</tr>
		<td colspan="5" align="right">
        <form action="updatecart.jsp" method="post" style="margin: 0; display: inline-block;">
            <input type="image" src="resources/updatecart.png" alt="Update Cart" style="width: 150px; height: auto; border-radius: 5px; cursor: pointer;">
        </form>
    </td>
</tr>
	</table>
	</form>

		<a href='checkout.jsp' style='display: inline-block; padding: 10px 20px; margin: 10px; text-align: center;'>
			<img src='resources/checkout.png' alt='Check Out' style='width: 150px; height: auto; border-radius: 5px;'>
		</a>
		<a href='listprod.jsp' style='display: inline-block; padding: 10px 20px; margin: 10px; text-align: center;'>
				<img src='resources/continue.png' alt='Continue Shopping' style='width: 150px; height: auto; border-radius: 5px;'>
		</a>
	</div>
<%
		
}
%>
<%
String message = (String) session.getAttribute("message");
if (message != null) {
%>
    <div style="color: red; text-align: center; margin: 10px;">
        <%= message %>
    </div>
<%
    // Clear the message after displaying it
    session.removeAttribute("message");
}
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

</body>
</html> 


