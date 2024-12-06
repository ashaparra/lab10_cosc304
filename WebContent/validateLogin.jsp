<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	String authenticatedUserName = null;
	session = request.getSession(true);
	Integer isAdmin = null;

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

    // Retrieve isAdmin value from session
    if (session.getAttribute("isAdmin") != null) {
        isAdmin = (Integer) session.getAttribute("isAdmin");
    }

    if (authenticatedUser != null && (isAdmin == null || isAdmin == 0)) {
        response.sendRedirect("index.jsp");     // Successful login for regular users
    } else if (authenticatedUser != null && isAdmin == 1) {
        response.sendRedirect("admin.jsp");    // Successful login for admin
    } else {
        response.sendRedirect("login.jsp");    // Failed login
    }
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;
		String firstName = null;
		int isAdmin = 0;
		int customerId = 0;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			ResultSet rs;
			String sql = "SELECT userId, password, firstName, isAdmin, customerId FROM customer WHERE userId= ? AND password = ?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, username);
			pstmt.setString(2,password);
			rs = pstmt.executeQuery();
			if(rs.next()){
				retStr = username;		
				firstName = rs.getString("firstName");
				isAdmin = rs.getInt("isAdmin");
				customerId = rs.getInt("customerId");
			}		
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
			session.setAttribute("authenticatedUserName",firstName);
			session.setAttribute("isAdmin",isAdmin);
			session.setAttribute("customerId",customerId);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

