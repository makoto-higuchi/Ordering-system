package com.example.servlet;

import com.example.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        System.out.println("Action: " + action); // 调试语句

        if ("添加到购物车".equals(action)) {
            addToCart(request, response);
        } else if ("更新".equals(action)) {
            updateCart(request, response);
        } else if ("删除".equals(action)) {
            deleteFromCart(request, response);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");

        // 检查userId是否为空
        if (userId == null) {
            // 向前端输出提示信息
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('您必须先登录才能选购餐品');window.location.href='products.jsp';</script>");
            out.close();
            return; // 停止后续操作
        }

        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        System.out.println("Adding to cart: userId=" + userId + ", productId=" + productId + ", quantity=" + quantity); // 调试语句

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect();
            }

            // 检查购物车中是否已存在相应的商品记录
            String checkExistSql = "SELECT * FROM cart WHERE user_id = ? AND product_id = ?";
            PreparedStatement checkExistStmt = conn.prepareStatement(checkExistSql);
            checkExistStmt.setInt(1, userId);
            checkExistStmt.setInt(2, productId);
            ResultSet rs = checkExistStmt.executeQuery();

            if (rs.next()) {
                // 如果已存在记录，则更新数量
                String updateSql = "UPDATE cart SET quantity = quantity + ? WHERE user_id = ? AND product_id = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setInt(1, quantity);
                updateStmt.setInt(2, userId);
                updateStmt.setInt(3, productId);
                updateStmt.executeUpdate();
            } else {
                // 如果不存在记录，则插入新记录
                String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, userId);
                insertStmt.setInt(2, productId);
                insertStmt.setInt(3, quantity);
                insertStmt.executeUpdate();
            }

            // 向前端输出添加成功提示
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('餐品添加成功');window.location.href='products.jsp';</script>");
            out.close();

            // 重定向到 products.jsp 页面
            // response.sendRedirect("products.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            // 使用 alert 显示错误信息
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('添加到购物车失败，请重试！');window.location.href='products.jsp';</script>");
            out.close();
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




    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int cartId = Integer.parseInt(request.getParameter("cartId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Connection conn = null; // 声明一个普通的Connection变量

        try {
            conn = DBConnection.getConnection();
            // 检查连接是否已关闭并重新连接
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect();
            }
            if (quantity == 0) {
                deleteCartItem(cartId, conn);
            } else {
                String sql = "UPDATE cart SET quantity = ? WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, quantity);
                stmt.setInt(2, cartId);
                stmt.executeUpdate();
            }
            response.sendRedirect("cart.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp");
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

    private void deleteFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int cartId = Integer.parseInt(request.getParameter("cartId"));

        Connection conn = null; // 声明一个普通的Connection变量

        try {
            conn = DBConnection.getConnection();
            // 检查连接是否已关闭并重新连接
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.reconnect();
            }
            deleteCartItem(cartId, conn);
            response.sendRedirect("cart.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp");
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

    private void deleteCartItem(int cartId, Connection conn) throws SQLException {
        String sql = "DELETE FROM cart WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, cartId);
        stmt.executeUpdate();
    }
}