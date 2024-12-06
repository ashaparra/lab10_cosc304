<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>

<%
// Retrieve the current product list from the session
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

                if (updatedQuantity > 0) {
                    product.set(3, updatedQuantity); 
                } else if (updatedQuantity == 0) {
                    productList.remove(productId);
                    
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
