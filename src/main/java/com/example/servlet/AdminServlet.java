package com.example.servlet;

import com.example.db.DBConnection;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        if ("addUser".equals(action)) {
            addUser(request, response);
        } else if ("deleteUser".equals(action)) {
            deleteUser(request, response);
        } else if ("addProduct".equals(action)) {
            addProduct(request, response);
        } else if ("deleteProduct".equals(action)) {
            deleteProduct(request, response);
        } else if ("updateProduct".equals(action)) {
            updateProduct(request, response);
        } else if ("updateUser".equals(action)) {
            updateUser(request, response);
        } else {
            loginAdmin(request, response);
        }
    }

    private void loginAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect();
            }

            String sql = "SELECT * FROM users WHERE username = ? AND is_admin = TRUE AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password); // 直接比较明文密码
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.getSession().setAttribute("adminId", rs.getInt("id"));
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                request.setAttribute("loginError", "用户名或密码错误！");
                request.getRequestDispatcher("admin_login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("loginError", "数据库错误，请稍后再试。");
            request.getRequestDispatcher("admin_login.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    private void addUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean isAdmin = "on".equals(request.getParameter("isAdmin"));

        // 检查用户名或密码是否为空
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            String errorMessage = "用户名和密码不能为空";
            response.sendRedirect("manage_users.jsp?error=" + URLEncoder.encode(errorMessage, "UTF-8"));
            return;
        }

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            // 检查连接是否已关闭并重新连接
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect();
            }

            String sql = "INSERT INTO users (username, password, is_admin) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setBoolean(3, isAdmin);
            stmt.executeUpdate();
            response.sendRedirect("manage_users.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage_users.jsp?error=" + URLEncoder.encode("数据库错误", "UTF-8"));
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));

        Connection conn = null; // 声明一个普通的Connection变量

        try {
            conn = DBConnection.getConnection();
            // 检查连接是否已关闭并重新连接
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect();
            }

            String sql = "DELETE FROM users WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            response.sendRedirect("manage_users.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage_users.jsp");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");

        if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty()) {
            String errorMessage = "餐品名和价格不能为空";
            response.sendRedirect("manage_products.jsp?error=" + URLEncoder.encode(errorMessage, "UTF-8"));
            return;
        }

        double price;
        try {
            price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            String errorMessage = "价格必须是数字";
            response.sendRedirect("manage_products.jsp?error=" + URLEncoder.encode(errorMessage, "UTF-8"));
            return;
        }

        Connection conn = null; // 声明一个普通的Connection变量

        try {
            conn = DBConnection.getConnection();
            // 检查连接是否已关闭并重新连接
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect(); // 一个重新连接的方法
            }

            String sql = "INSERT INTO products (name, price) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setDouble(2, price);
            stmt.executeUpdate();
            response.sendRedirect("manage_products.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage_products.jsp?error=" + URLEncoder.encode("数据库错误，请稍后再试", "UTF-8"));
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));

        Connection conn = null; // 声明一个普通的Connection变量

        try {
            conn = DBConnection.getConnection();
            // 检查连接是否已关闭并重新连接
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect(); // 一个重新连接的方法
            }

            String sql = "DELETE FROM products WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            stmt.executeUpdate();
            response.sendRedirect("manage_products.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("manage_products.jsp");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));

        Connection conn = null; // 声明一个普通的Connection变量
        try {
            conn = DBConnection.getConnection();
            // 检查连接是否已关闭并重新连接
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect(); // 一个重新连接的方法
            }
            String query = "UPDATE products SET name = ?, price = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, name);
            stmt.setDouble(2, price);
            stmt.setInt(3, productId);
            stmt.executeUpdate();
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
        }

        response.sendRedirect("manage_products.jsp");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userIdStr = request.getParameter("userId");
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");
        boolean isAdmin = "on".equals(request.getParameter("isAdmin"));

        Connection conn = null; // 声明一个普通的Connection变量
        try {
            conn = DBConnection.getConnection();
            // 检查连接是否已关闭并重新连接
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect(); // 一个重新连接的方法
            }
            String sql = "UPDATE users SET username = ?, password = ?, is_admin = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newUsername);
            stmt.setString(2, newPassword);
            stmt.setBoolean(3, isAdmin);
            stmt.setInt(4, Integer.parseInt(userIdStr));
            stmt.executeUpdate();
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
        }

        response.sendRedirect("manage_users.jsp");
    }



}