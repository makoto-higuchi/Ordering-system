<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理员登录</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        form {
            width: 300px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        label {
            display: block;
            margin-bottom: 10px;
            color: #333;
        }

        input[type="text"],
        input[type="password"],
        input[type="submit"] {
            width: 100%; /* 让输入框和按钮都占据父容器的100%宽度 */
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box; /* 计算 padding 和 border 在内的尺寸 */
        }

        input[type="submit"] {
            background-color: #007bff;
            color: #fff;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .error-message {
            color: #d9534f;
            text-align: center;
            margin-top: 10px;
        }
    </style>
    <script type="text/javascript">
        <%
            String loginError = (String) request.getAttribute("loginError");
            if (loginError != null) {
        %>
        window.onload = function () {
            alert("<%= loginError %>");
        }
        <%
            }
        %>
    </script>
</head>
<body>
<h2>管理员登录</h2>
<form action="AdminServlet" method="post">
    <label for="username">用户名：</label>
    <input type="text" id="username" name="username">
    <label for="password">密码：</label>
    <input type="password" id="password" name="password">
    <input type="submit" value="登录">
    <%-- 错误消息显示区域 --%>
    <% if (loginError != null) { %>
    <div class="error-message"><%= loginError %>
    </div>
    <% } %>
</form>
</body>
</html>
