<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="auth.jsp"%>
<%
    String userName = (String) session.getAttribute("authenticatedUser");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/listprod.css" rel="stylesheet">
</head>
    <body style="display: flex; flex-direction: column; min-height: 100vh;">
    <%
    // TODO: Write SQL query that prints out total order amount by day
    try{
    getConnection();
    Statement stmt = con.createStatement();
    ResultSet rst= stmt.executeQuery("SELECT YEAR(orderDate) as orderYear, MONTH(orderDate) AS orderMonth, DAY(orderDate) AS orderDay, SUM(totalAmount) AS totalAmount FROM ordersummary GROUP BY YEAR(orderDate),MONTH(orderDate),DAY(orderDate) ORDER BY  YEAR(orderDate),MONTH(orderDate),DAY(orderDate) DESC");
    %>
    <header id="nav">
        <ul>
            <li style="margin-right: auto; margin-top:55px; padding-left: 0;"><a href="index.jsp"><img src="resources/logoT.png" alt="Velart logo" height="100px" style="margin: 0; padding: 0;" ></a></li>
            <li class="right-items"><a href="listprod.jsp">Products</a></li>
            <li class="right-items"><a href="listorder.jsp">Orders</a></li>
            <li class="right-items"><a href="showcart.jsp"><img src="resources/shopping-cart.png" alt="Shopping cart icon"  height="40px" justify-content:right ></a></li>
        </ul>
    </header>
    <main style="flex: 1; display: flex; flex-direction: column; align-items: center; padding: 20px; overflow-y: auto;"">
    <div style="display: flex; flex-direction: column; align-items: center; margin-top: 20px;">
        <h1 style='color:#618244'>Order totals by day</h1>
        
        <table  style="border-spacing: 20px; width: 80%; margin: auto; ">
                <tr>
                    <th>Order Date</th>
                    <th>Total Order Amount</th>
                </tr>
            <%
                while(rst.next()){
                    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                    String year = rst.getString("orderYear");
                    String month = rst.getString("orderMonth");
                    String day = rst.getString("orderDay");
                    BigDecimal totalAmount = rst.getBigDecimal("totalAmount");
                
            %>
                <tr>
                    <td><%= year + "-" + month + "-" + day %></td>
                    <td><%=currFormat.format(totalAmount)%></td>
                </tr>
            <%
            }
        }catch(SQLException ex){
            out.println("<p>Error: " + ex.getMessage() + "</p>");
        }
        finally
		{
			closeConnection();
		}	
            %>

                
            </table>
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
    </body>
</html>

