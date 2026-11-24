
package com.inventory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.inventory.model.StockHistory;
import com.inventory.util.DBCconnection;

public class StockDAO {

    // Stock IN and Stock OUT
    public String updateStock(int productId, int quantity, String type)
            throws SQLException {

        String selectSql =
            "SELECT quantity FROM products WHERE id = ? FOR UPDATE";

        String updateSql =
            "UPDATE products SET quantity = ? WHERE id = ?";

        String insertSql =
            "INSERT INTO stock_history " +
            "(product_id, type, quantity, transaction_date) " +
            "VALUES (?, ?, ?, NOW())";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) {
                throw new SQLException("Database connection failed.");
            }

            con.setAutoCommit(false);

            try {

                int currentQuantity;

                // Get existing stock
                try (PreparedStatement ps =
                        con.prepareStatement(selectSql)) {

                    ps.setInt(1, productId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            con.rollback();
                            return "NOT_FOUND";
                        }

                        currentQuantity = rs.getInt("quantity");
                    }
                }

                int newQuantity;

                if ("IN".equals(type)) {
                    newQuantity = currentQuantity + quantity;

                } else if ("OUT".equals(type)) {

                    if (quantity > currentQuantity) {
                        con.rollback();
                        return "INSUFFICIENT";
                    }

                    newQuantity = currentQuantity - quantity;

                } else {
                    con.rollback();
                    return "INVALID";
                }

                // Update product quantity
                try (PreparedStatement ps =
                        con.prepareStatement(updateSql)) {

                    ps.setInt(1, newQuantity);
                    ps.setInt(2, productId);

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException("Stock update failed.");
                    }
                }

                // Insert transaction history
                try (PreparedStatement ps =
                        con.prepareStatement(insertSql)) {

                    ps.setInt(1, productId);
                    ps.setString(2, type);
                    ps.setInt(3, quantity);

                    ps.executeUpdate();
                }

                con.commit();

                return "SUCCESS";

            } catch (SQLException e) {

                con.rollback();
                throw e;

            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    // Get all stock history
    public List<StockHistory> getAllHistory() throws SQLException {

        List<StockHistory> history = new ArrayList<>();

        String sql =
            "SELECT h.id, h.product_id, p.name AS product_name, " +
            "h.type, h.quantity, h.transaction_date " +
            "FROM stock_history h " +
            "LEFT JOIN products p ON h.product_id = p.id " +
            "ORDER BY h.id DESC";

        try (Connection con = DBCconnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                StockHistory h = new StockHistory();

                h.setId(rs.getInt("id"));
                h.setProductId(rs.getInt("product_id"));
                h.setProductName(rs.getString("product_name"));
                h.setType(rs.getString("type"));
                h.setQuantity(rs.getInt("quantity"));
                h.setTransactionDate(
                    rs.getTimestamp("transaction_date")
                );

                history.add(h);
            }

        }
        // SQLException now propagates — servlet catches and wraps it in ServletException

        return history;
    }
}
