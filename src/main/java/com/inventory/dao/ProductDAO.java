

package com.inventory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.inventory.model.Product;
import com.inventory.util.DBCconnection;

public class ProductDAO {

    // 1. Add Product
    public boolean addProduct(Product product) {

        String sql = "INSERT INTO products "
                + "(name, category, price, quantity, supplier_id) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) {
                return false;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, product.getName());
                ps.setString(2, product.getCategory());
                ps.setDouble(3, product.getPrice());
                ps.setInt(4, product.getQuantity());
                ps.setInt(5, product.getSupplierId());

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // 2. Get All Products
    public List<Product> getAllProducts() {

        List<Product> products = new ArrayList<>();

        String sql = "SELECT * FROM products";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) {
                return products;
            }

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Product product = new Product();

                    product.setId(rs.getInt("id"));
                    product.setName(rs.getString("name"));
                    product.setCategory(rs.getString("category"));
                    product.setPrice(rs.getDouble("price"));
                    product.setQuantity(rs.getInt("quantity"));
                    product.setSupplierId(rs.getInt("supplier_id"));

                    products.add(product);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    // 3. Get Product By ID
    public Product getProductById(int id) {

        Product product = null;

        String sql = "SELECT * FROM products WHERE id = ?";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) {
                return null;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        product = new Product();

                        product.setId(rs.getInt("id"));
                        product.setName(rs.getString("name"));
                        product.setCategory(rs.getString("category"));
                        product.setPrice(rs.getDouble("price"));
                        product.setQuantity(rs.getInt("quantity"));
                        product.setSupplierId(rs.getInt("supplier_id"));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return product;
    }

    // 4. Update Product
    public boolean updateProduct(Product product) {

        String sql = "UPDATE products SET name = ?, category = ?, "
                + "price = ?, quantity = ?, supplier_id = ? WHERE id = ?";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) {
                return false;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, product.getName());
                ps.setString(2, product.getCategory());
                ps.setDouble(3, product.getPrice());
                ps.setInt(4, product.getQuantity());
                ps.setInt(5, product.getSupplierId());
                ps.setInt(6, product.getId());

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // 5. Delete Product
    public boolean deleteProduct(int id) {

        String sql = "DELETE FROM products WHERE id = ?";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) {
                return false;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
