<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员界面</title>
    <style>
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
            margin-top: 0; /* 添加此行以消除默认的 margin-top */
        }
    </style>
</head>
<body>
<div id="sidebar">
    <a href="#" onclick="loadPage('manage_users.jsp')">管理用户</a>
    <a href="#" onclick="loadPage('manage_products.jsp')">管理餐品</a>
    <button id="logout-btn" onclick="logout()">退出登录</button>
</div>
<div id="main-content">
    <h2>欢迎进入管理员界面</h2>
    <!-- 这里是主页面内容 -->
</div>
<script>
    function loadPage(pageUrl) {
        fetch(pageUrl)
            .then(response => response.text())
            .then(html => {
                document.getElementById('main-content').innerHTML = html;
            })
            .catch(error => console.error('Error loading page:', error));
    }

    function logout() {
        // 这里添加退出登录的逻辑，例如重定向到 admin_login.jsp 页面
        window.location.href = 'admin_login.jsp';
    }
</script>
</body>
</html>
