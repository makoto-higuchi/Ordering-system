<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.example.db.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>欢迎使用，祝您用餐愉快</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f2f2f2;
            display: flex;
        }

        #sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 200px;
            background-color: #333;
            color: #fff;
            padding: 20px;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.2);
            border-top-right-radius: 20px;
            border-bottom-right-radius: 20px;
        }

        #sidebar a {
            display: block;
            padding: 10px 15px;
            margin-bottom: 10px;
            color: #fff;
            text-decoration: none;
            transition: background-color 0.3s ease;
            border-radius: 5px;
        }

        #sidebar a:hover {
            background-color: #444;
        }

        #sidebar #logout-btn {
            background-color: #d9534f;
            border: none;
            color: white;
            padding: 10px 15px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }

        #sidebar #logout-btn:hover {
            background-color: #c9302c;
        }

        #main-content {
            flex-grow: 1;
            padding: 20px;
            margin-left: 200px;
            padding-left: 150px; /* 添加左边距 */
        }

        #main-content h2 {
            color: #333;
            margin-top: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 15px;
            text-align: left;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #e9e9e9;
        }

        input[type="number"] {
            width: 60px;
            padding: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        input[type="submit"], input[type="reset"] {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-left: 10px;
        }

        input[type="submit"]:hover, input[type="reset"]:hover {
            background-color: #218838;
        }

        .reset-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-left: 10px;
        }

        .reset-btn:hover {
            background-color: #0056b3;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        a:hover {
            background-color: #0056b3;
        }

        .success-message {
            margin-top: 20px;
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
        }

        #login-btn {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        #login-btn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
<div id="sidebar">
    <a href="products.jsp">餐品列表</a>
    <a href="cart.jsp">购物车</a>
    <%
        // 检查用户是否已登录
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId != null) {
    %>
    <form action="LogoutServlet" method="post">
        <input type="submit" id="logout-btn" value="退出登录">
    </form>
    <%
    } else {
    %>
    <a href="login.jsp" id="login-btn">登录</a>
    <%
        }
    %>
</div>
<div id="main-content">
    <h2>餐品列表</h2>
    <form action="products.jsp" method="get">
        <input type="text" name="search" placeholder="搜索商品...">
        <input type="submit" value="搜索">
        <input type="button" class="reset-btn" value="重置" onclick="window.location.href='products.jsp'">
    </form>
    <table>
        <tr>
            <th>ID</th>
            <th>名称</th>
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
            <td><%= rs.getInt("id") %>
            </td>
            <td><%= rs.getString("name") %>
            </td>
            <td><%= rs.getDouble("price") %>
            </td>
            <td>
                <form action="CartServlet" method="post" accept-charset="UTF-8">
                    <input type="hidden" name="productId" value="<%= rs.getInt("id") %>">
                    <input type="number" name="quantity" value="1" min="1">
                    <input type="submit" name="action" value="添加到购物车">
                </form>
            </td>
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
    <a href="cart.jsp">查看购物车</a>
</div>
</body>
</html>