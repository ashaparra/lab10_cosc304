<!DOCTYPE html>
<html>
<head>
        <title>Velart Main Page</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<link rel="stylesheet" href="css/index.css">	
<body style="background-color: #f2f1ed;">
	<header id="nav">
		<ul>
			<li style="margin-right: auto; padding-left: 0;"><a href="customer.jsp"><img src="resources/customerinfo.png"></a></li>
			<%
				String userName = (String) session.getAttribute("authenticatedUser");
				if (userName != null){
			%>	
				<li><a href="logout.jsp"><img src="resources/logout.png"></a></li>
			<%
				}else{
			%>
				<li class="right-items"><a href="login.jsp"><img src="resources/login.png"></a></li>
			<%
				}
			%>		
			
		</ul>
	</header>
	
	<div class="container text-center" style="padding-top: 20px;"">
		<h1 style="font-weight:bold; font-size:4rem">Welcome to Velart</h1>
		<%
			if (userName != null){
		%>	
			<h6 style="padding-top: 20px;">It's good to see you again, <%= userName %></h6>
		<%
			}
		%>
	</div>

<div class="container text-center" style="padding-top: 10px;">
	<div class="row">
	  <div class="col">
		<h2 style="padding-top: 100px;"><a href="listprod.jsp" class="menu">Begin Shopping</a></h2>
		<h2 style="padding-top: 30px;""><a href="listorder.jsp" class="menu">List All Orders</a></h2>
		<h2 style="padding-top: 30px;""><a href="admin.jsp" class="menu">Administrators</a></h2>
	  </div>
	  <div class="col">
		<img src="resources/Logo.png" style="max-width:100%">
	  </div>
	</div>
  </div>


<!-- //<h4 align="center"><a href="ship.jsp?orderId=7">Test Ship orderId=7</a></h4> -->

<!-- <h4 align="center"><a href="ship.jsp?orderId=6">Test Ship orderId=6</a></h4> -->

</body>
</head>


