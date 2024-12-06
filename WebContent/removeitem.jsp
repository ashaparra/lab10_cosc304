<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>

<%
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList != null) {
        // Get the product ID to remove
        String productId = request.getParameter("productId");
        if (productId != null && productList.containsKey(productId)) {
            // Remove the product from the list
            productList.remove(productId);
        }
    }

    session.setAttribute("productList", productList);

    response.sendRedirect("showcart.jsp");
%>
