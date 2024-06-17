<%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2024/6/1
  Time: 9:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>登录</title>
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
            width: 100%;
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

        a {
            display: block;
            text-align: center;
            margin-top: 10px;
            color: #007bff;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
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
<h2>用户登录</h2>
<form action="UserServlet" method="post">
    <input type="hidden" name="action" value="login">
    <label for="username">用户名：</label>
    <input type="text" id="username" name="username"><br><br>
    <label for="password">密码：</label>
    <input type="password" id="password" name="password"><br><br>
    <input type="submit" value="登录">
</form>
<a href="register.jsp">注册</a>
</body>
</html>
