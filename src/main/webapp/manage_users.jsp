<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.example.db.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理用户</title>
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
        input[type="password"],
        input[type="submit"],
        input[type="checkbox"],
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
<%
    Connection conn = null;
    try {
        conn = DBConnection.getConnection();
        // 检查连接是否已关闭并重新连接
        if (conn == null || conn.isClosed()) {
            conn = DBConnection.reconnect();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // 获取搜索关键词
    String searchKeyword = request.getParameter("search");

    // SQL 查询语句
    String query = "SELECT * FROM users";
    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
        query += " WHERE username LIKE ? OR id LIKE ?";
    }
%>
<h2>管理用户</h2>
<form action="AdminServlet" method="post">
    <input type="hidden" name="action" value="addUser">
    <label for="username">用户名：</label>
    <input type="text" id="username" name="username">
    <label for="password">密码：</label>
    <input type="password" id="password" name="password">
    <label for="isAdmin">管理员：</label>
    <input type="checkbox" id="isAdmin" name="isAdmin">
    <input type="submit" id="adduserButton" value="添加用户">
</form>
<form action="manage_users.jsp" method="get">
    <label for="search">搜索用户：</label>
    <input type="text" id="search" name="search" placeholder="输入用户信息">
    <input type="submit" id="searchButton" value="搜索">
    <input type="button" id="resetButton" value="重置" onclick="window.location.href='manage_users.jsp'">
</form>

<h3>现有用户</h3>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>用户名</th>
        <th>密码</th>
        <th>是否为管理员</th>
        <th>操作</th>
    </tr>
    </thead>
    <%
        try {
            PreparedStatement stmt = conn.prepareStatement(query);
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword + "%";
                stmt.setString(1, searchPattern);
                stmt.setString(2, searchPattern);
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
    %>
    <tbody>
    <tr>
        <form action="AdminServlet" method="post">
            <td><%=rs.getInt("id")%>
            </td>
            <td><input type="text" name="username" value="<%=rs.getString("username")%>"></td>
            <td><input type="text" name="password" value="<%=rs.getString("password")%>"></td>
            <td><input type="checkbox" name="isAdmin" <% if(rs.getInt("is_admin") == 1) { %> checked <% } %> ></td>
            <td><input type="hidden" name="action" value="updateUser">
                <input type="hidden" name="userId" value="<%= rs.getInt("id") %>">
                <input type="submit" id="updateButton" value="更新">
                <input type="button" id="deleteButton" value="删除"
                       onclick="if(confirm('确定删除吗?')) { this.form.action='AdminServlet'; this.form.method='post'; this.form.action.value='deleteUser'; this.form.submit(); }">
            </td>
        </form>
    </tr>
    </tbody>
    <%
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // 关闭连接
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
