<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.example.db.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理餐品</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        form {
            margin-bottom: 20px;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-bottom: 10px;
            color: #333;
        }

        input[type="text"],
        input[type="submit"],
        input[type="button"] {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        input[type="submit"],
        input[type="button"] {
            background-color: #4CAF50;
            color: #fff;
            cursor: pointer;
        }

        input[type="submit"]:hover,
        input[type="button"]:hover {
            background-color: #45a049;
        }

        input#deleteButton {
            background-color: #dc3545;
        }

        input#deleteButton:hover {
            background-color: #c82333;
        }

        input#resetButton {
            background-color: #007bff;
        }

        input#resetButton:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: #fff;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #ddd;
        }

        .button-container {
            text-align: center;
            margin-top: 20px;
        }

        .button-container a {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
        }

        .button-container a:hover {
            background-color: #0056b3;
        }
    </style>
    <script>
        window.onload = function () {
            const urlParams = new URLSearchParams(window.location.search);
            const errorMessage = urlParams.get('error');
            if (errorMessage) {
                alert(decodeURIComponent(errorMessage));
            }
        }
    </script>
</head>
<body>
<h2>管理餐品</h2>
<form action="AdminServlet" method="post">
    <input type="hidden" name="action" value="addProduct">
    <label for="name">餐品名：</label>
    <input type="text" id="name" name="name">
    <label for="price">价格：</label>
    <input type="text" id="price" name="price">
    <input type="submit" id="addproductButton" value="添加餐品">
</form>

<form action="manage_products.jsp" method="get">
    <label for="search">搜索餐品：</label>
    <input type="text" id="search" name="search" placeholder="输入餐品名">
    <input type="submit" id="searchButton" value="搜索">
    <input type="button" id="resetButton" value="重置" onclick="window.location.href='admin_dashboard.jsp'">
</form>

<h3>现有餐品</h3>
<table>
    <tr>
        <th>餐品ID</th>
        <th>餐品名</th>
        <th>价格</th>
        <th>操作</th>
    </tr>
    <%
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect();
            }
            String search = request.getParameter("search");
            String query = "SELECT * FROM products";
            if (search != null && !search.trim().isEmpty()) {
                query += " WHERE name LIKE ?";
            }
            PreparedStatement stmt = conn.prepareStatement(query);
            if (search != null && !search.trim().isEmpty()) {
                stmt.setString(1, "%" + search + "%");
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
    %>
    <tr>
        <form action="AdminServlet" method="post">
            <td><%= rs.getInt("id") %>
            </td>
            <td><input type="text" name="name" value="<%= rs.getString("name") %>"></td>
            <td><input type="text" name="price" value="<%= rs.getDouble("price") %>"></td>
            <td><input type="hidden" name="action" value="updateProduct">
                <input type="hidden" name="productId" value="<%= rs.getInt("id") %>">
                <input type="submit" id="updateButton" value="更新">
                <input type="button" id="deleteButton" value="删除"
                       onclick="if(confirm('确定删除吗?')) { this.form.action='AdminServlet'; this.form.method='post'; this.form.action.value='deleteProduct'; this.form.submit(); }">
            </td>
        </form>
    </tr>
    <%
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } %>
</table>
<div class="button-container">
    <a href="admin_dashboard.jsp">返回管理页面</a>
</div>
</body>
</html>