<%@ page import="java.util.Base64" %>
<%
    response.setContentType("application/json");
    String productName = request.getParameter("productName");
    String productPrice = request.getParameter("productPrice");
    String productDesc = request.getParameter("productDesc");
    String productCategory = request.getParameter("productCategory");
    byte[] productImage = null;

    try {
        Part filePart = request.getPart("productImage");
        if (filePart != null) {
            InputStream fileContent = filePart.getInputStream();
            productImage = fileContent.readAllBytes();
        }

        getConnection();
        String SQL = "INSERT INTO product (productName, productPrice, productImage, productDesc, categoryId) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, productName);
        pstmt.setBigDecimal(2, new BigDecimal(productPrice));
        pstmt.setBytes(3, productImage);
        pstmt.setString(4, productDesc);
        pstmt.setInt(5, Integer.parseInt(productCategory));
        pstmt.executeUpdate();

        ResultSet generatedKeys = pstmt.getGeneratedKeys();
        int productId = 0;
        if (generatedKeys.next()) {
            productId = generatedKeys.getInt(1);
        }

        String base64Image = Base64.getEncoder().encodeToString(productImage);
        out.print("{\"productId\": \"" + productId + "\", \"productName\": \"" + productName + "\", \"productPrice\": \"" + productPrice + "\", \"productImage\": \"" + base64Image + "\"}");
    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"error\": \"" + e.getMessage() + "\"}");
    } finally {
        closeConnection();
    }
%>
