<%
	// Remove the user from the session to log them out
	session.setAttribute("authenticatedUser",null);
	session.setAttribute("authenticatedUserName",null);
	response.sendRedirect("index.jsp");		// Re-direct to main page
%>

