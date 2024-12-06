<!--
A JSP file that encapsulates database connections.

Public methods:
- public void getConnection() throws SQLException
- public void closeConnection() throws SQLException  
-->

<%@ page import="java.sql.*"%>

<%!
	// User id, password, and server information
	private String url = "jdbc:sqlserver://cosc-304-18.cv8agos8ieeu.us-east-2.rds.amazonaws.com:1433;databaseName=orders;trustServerCertificate=true";
	private String uid = "admin";
	private String pw = "Ashanat.37";
	
	// Do not modify this url
	private String urlForLoadData = "jdbc:sqlserver://cosc-304-18.cv8agos8ieeu.us-east-2.rds.amazonaws.com:1433;databaseName=orders;trustServerCertificate=true";

	
	// Connectionx
	private Connection con = null;
%>

<%!
	public void getConnection() throws SQLException 
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			throw new SQLException("ClassNotFoundException: " +e);
		}
	
		con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();
	}
   
	public void closeConnection() 
	{
		try {
			if (con != null)
				con.close();
			con = null;
		}
		catch (Exception e)
		{ }
	}
%>
