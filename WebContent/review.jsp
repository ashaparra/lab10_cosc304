<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*, java.math.BigDecimal" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Review</title>
    <link rel="stylesheet" href="css/review.css">
</head>

<%
//String productId = request.getParameter("productId");
//String productName = request.getParameter("productName");
    String productName = "Lavender Scented Candle";
    String productId = "1";
%>

<body>
    <header id="nav">
        <ul>
            <li style="margin-right: auto; margin-top:55px; padding-left: 0;">
                <a href="index.jsp"><img src="resources/logoT.png" alt="Velart logo" height="100px"></a>
            </li>
            <li class="right-items"><a href="listprod.jsp">Products</a></li>
            <li class="right-items"><a href="listorder.jsp">Orders</a></li>
            <li class="right-items">
                <a href="showcart.jsp"><img src="resources/shopping-cart.png" alt="Shopping cart icon" height="40px"></a>
            </li>
        </ul>
    </header>

    <!-- Main Content -->
    <main class="review-container">
        <h1 class="product-title">Review: <%= productName %></h1>

        <!-- Star Rating -->
        <form action="submitReview.jsp" method="post">
            <div class="rating-section">
                <p>Select Rating:</p>
                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5">
                    <label for="star5" title="5 stars">&#9733;</label>
                    <input type="radio" id="star4" name="rating" value="4">
                    <label for="star4" title="4 stars">&#9733;</label>
                    <input type="radio" id="star3" name="rating" value="3">
                    <label for="star3" title="3 stars">&#9733;</label>
                    <input type="radio" id="star2" name="rating" value="2">
                    <label for="star2" title="2 stars">&#9733;</label>
                    <input type="radio" id="star1" name="rating" value="1">
                    <label for="star1" title="1 star">&#9733;</label>
                </div>
            </div>

            <!-- Comment Box -->
            <div class="comment-section">
                <label for="comment">Leave a Comment:</label>
                <textarea id="comment" name="comment" rows="5" placeholder="Share your thoughts about the product..." required></textarea>
                <input type="hidden" name="productId" value="<%= productId %>">
                
            </div>

            <!-- Submit Button -->
            <div class="submit-section">
                <button type="submit" class="btn-submit">Submit Review</button>
            </div>
        </form>
    </main>

    <!-- Footer -->
    <footer class="footer-section">
        <p>©️ 2024 Velart. All Rights Reserved</p>
    </footer>
</body>
</html>
