<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.sql.*, com.example.db.DBConnection" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>购物车</title>
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
        }

        label {
            display: block;
            margin-bottom: 10px;
            color: #333;
        }

        input[type="text"],
        input[type="submit"] {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: #fff;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
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
            margin-top: 20px;
        }

        .button-container a:hover {
            background-color: #0056b3;
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

<h2>您的购物车</h2>

<!-- 输出 session 中的 userId 以进行调试
<p>Debug: Session userId = <c:out value="${sessionScope.userId}"/></p>-->

<c:if test="${empty sessionScope.userId}">
    <p>您需要登录才能查看购物车。</p>
</c:if>
<c:if test="${not empty sessionScope.userId}">
    <!-- <p>Debug: userId = ${sessionScope.userId}</p> 调试语句 -->
    <form action="CartServlet" method="post">
        <table>
            <tr>
                <th>名称</th>
                <th>价格</th>
                <th>数量</th>
                <th>总价</th>
                <th>操作</th>
            </tr>
            <%
                Integer userId = (Integer) session.getAttribute("userId");
                Connection conn = null;
                double totalAmount = 0.0;

                if (userId != null) {
                    try {
                        conn = DBConnection.getConnection();
                        if (conn == null || conn.isClosed()) {
                            conn = DBConnection.reconnect();
                        }
                        String sql = "SELECT p.name, p.price, c.quantity, (p.price * c.quantity) AS total, c.id AS cart_id " +
                                "FROM cart c JOIN products p ON c.product_id = p.id " +
                                "WHERE c.user_id = ?";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, userId);
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                            String name = rs.getString("name");
                            double price = rs.getDouble("price");
                            int quantity = rs.getInt("quantity");
                            double total = rs.getDouble("total");
                            totalAmount += total;
            %>
            <tr>
                <td><%= name %>
                </td>
                <td><%= price %>
                </td>
                <td><%= quantity %>
                </td>
                <td><%= total %>
                </td>
                <td>
                    <input type="hidden" name="cartId" value="<%= rs.getInt("cart_id") %>">
                    <input type="number" name="quantity" value="<%= quantity %>" min="0">
                    <input type="submit" name="action" value="更新">
                    <input type="submit" name="action" value="删除">
                </td>
            </tr>
            <%
                }
                rs.close();
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            %>
            <p>Debug: SQLException - <%= e.getMessage() %>
            </p> <!-- 调试语句 -->
            <%
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
            %>
            <p>Debug: SQLException (finally) - <%= e.getMessage() %>
            </p> <!-- 调试语句 -->
            <%
                        }
                    }
                }
            } else {
            %>
            <p>Debug: userId is null</p> <!-- 调试语句 -->
            <%
                }
            %>
            <tr>
                <td colspan="3">总金额</td>
                <td><%= totalAmount %>
                </td>
                <td></td>
            </tr>
        </table>
    </form>
</c:if>
<div class="button-container">
    <a href="products.jsp">返回餐品列表</a>
</div>
</body>
</html>
