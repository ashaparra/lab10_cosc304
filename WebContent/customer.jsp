<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp"%>
<!DOCTYPE html>
<html>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/listprod.css" rel="stylesheet">
    <head>
        <title>Customer Page</title>
    </head>
    <body>
        <header id="nav">
            <ul>
                <li style="margin-right: auto; margin-top:55px; padding-left: 0;"><a href="index.jsp"><img src="resources/logoT.png" alt="Velart logo" height="100px" style="margin: 0; padding: 0;" ></a></li>
                <li class="right-items"><a href="listprod.jsp">Products</a></li>
                <li class="right-items"><a href="listorder.jsp">Orders</a></li>
                <li class="right-items"><a href="showcart.jsp"><img src="resources/shopping-cart.png" alt="Shopping cart icon"  height="40px" justify-content:right ></a></li>
            </ul>
        </header>


    <%
    getConnection();
    ResultSet rs;
    String userName = (String) session.getAttribute("authenticatedUser");
     
    try{
    // TODO: Print Customer information
    String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid from customer where userid= ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, userName);
    rs = pstmt.executeQuery();
    if (rs.next()) {
    %>
    <main style="flex: 1; display: flex; flex-direction: column; align-items: center;">
    <div style="display: flex; flex-direction: column; align-items: center; margin-top: 20px;">
        <h6>Logged in user: <%=userName%></h6>
    </div>

    <div style="width: 100%; max-height: 100%; margin: 20px 0; overflow-y: auto; display: flex; justify-content: center;">
        <table class="table table-borderless" style="width: 40%; margin: auto; ">
            <tr>
                <th>Id</th>
                <td><%=rs.getInt("customerId")%></td>
            </tr>
            <tr>
                <th>First Name</th>
                <td><%=rs.getString("firstName")%></td>
            </tr>
            <tr>
                <th>Last Name</th>
                <td><%=rs.getString("lastName")%></td>
            </tr>
            <tr>
                <th>Email</th>
                <td><%=rs.getString("email")%></td>
            </tr>
            <tr>
                <th>Phone</th>
                <td><%=rs.getString("phonenum")%></td>
            </tr>
            <tr>
                <th>Address</th>
                <td><%=rs.getString("address")%></td>
            </tr>
            <tr>
                <th>City</th>
                <td><%=rs.getString("city")%></td>
            </tr>
            <tr>
                <th>State</th>
                <td><%=rs.getString("state")%></td>
            </tr>
            <tr>
                <th>Postal Code</th>
                <td><%=rs.getString("postalCode")%></td>
            </tr>
            <tr>
                <th>Country</th>
                <td><%=rs.getString("country")%></td>
            </tr>
            <tr>
                <th>User id</th>
                <td><%=rs.getString("userId")%></td>
            </tr>
        <%
    }
        else{
            out.println("<p>No customer data found for this user.</p>");
        }
        }catch(SQLException ex){
                out.println("<p>Error: " + ex.getMessage()+ "</p>");
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

