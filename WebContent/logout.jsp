<%
	// Remove the user from the session to log them out
	session.setAttribute("authenticatedUser",null);
	session.setAttribute("authenticatedUserName",null);
	session.setAttribute("isAdmin",null);
	session.setAttribute("customerId",null);
	response.sendRedirect("index.jsp");		// Re-direct to main page
%>

