<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ include file="jdbc.jsp" %>


<%
    getConnection();

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
if (productList != null) {
    // Iterate over the productList and update quantities based on form inputs
    for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
        String productId = entry.getKey();
        ArrayList<Object> product = entry.getValue();

        // Retrieve the updated quantity from the form data
        String quantityParam = request.getParameter("quantity_" + productId);
        if (quantityParam != null) {
            try {
                int updatedQuantity = Integer.parseInt(quantityParam);
                String sql="SELECT quantity FROM productInventory WHERE productId = ?";
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, productId);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    int quantity = rs.getInt("quantity");
                    if (updatedQuantity > quantity) {
                        session.setAttribute("message", "Not enough stock for product ID: " + productId);
                        continue;
                    }
                } else {
                    session.setAttribute("message", "Product ID: " + productId + " is not available in the inventory.");
                    continue;
                }

                if (updatedQuantity > 0) {
                    product.set(3, updatedQuantity); 
                } else if (updatedQuantity == 0) {
                    productList.remove(productId);
                    session.setAttribute("message", "Not enough stock for product ID: " + productId);
                   
                    
                }
            } catch (NumberFormatException e) {
                out.println("Invalid quantity for product ID: " + productId);
            }
        }
    }
}

// Update the session with the modified productList
session.setAttribute("productList", productList);

// Redirect back to the shopping cart page
response.sendRedirect("showcart.jsp");
%>
