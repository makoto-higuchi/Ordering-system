<%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2024/6/1
  Time: 9:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>注册</title>
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
            max-width: 300px;
            margin: 0 auto;
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

        .error-message {
            color: red;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<h2>用户注册</h2>
<form id="registration-form" action="UserServlet" method="post" onsubmit="return validateForm()">
    <input type="hidden" name="action" value="register">
    <label for="username">用户名：</label>
    <input type="text" id="username" name="username">
    <div id="username-error" class="error-message"></div>
    <label for="password">密码：</label>
    <input type="password" id="password" name="password">
    <div id="password-error" class="error-message"></div>
    <input type="submit" value="注册">
</form>

<script>
    function validateForm() {
        var username = document.getElementById("username").value;
        var password = document.getElementById("password").value;
        var usernameError = document.getElementById("username-error");
        var passwordError = document.getElementById("password-error");

        if (username.trim() === "") {
            usernameError.innerHTML = "请输入用户名";
            return false;
        } else {
            usernameError.innerHTML = "";
        }

        if (password.trim() === "") {
            passwordError.innerHTML = "请输入密码";
            return false;
        } else {
            passwordError.innerHTML = "";
        }

        return true;
    }

    // 在注册成功后弹出提示框并进行页面跳转
    var registrationForm = document.getElementById("registration-form");
    registrationForm.addEventListener("submit", function(event) {
        var isValid = validateForm();
        if (isValid) {
            alert("注册成功！请等待页面跳转。");
            // 延迟一秒钟后跳转到其他页面
            setTimeout(function() {
                window.location.href = "login.jsp"; // 替换为注册成功后跳转的页面
            }, 1000);
        } else {
            event.preventDefault(); // 阻止表单提交
        }
    });
</script>
</body>
</html>
