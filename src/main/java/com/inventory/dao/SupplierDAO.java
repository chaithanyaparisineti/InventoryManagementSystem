
package com.inventory.dao;

import java.sql.*;
import java.util.*;
import com.inventory.model.Supplier;
import com.inventory.util.DBCconnection;

public class SupplierDAO {

    public boolean addSupplier(Supplier s) {

        String sql = "INSERT INTO suppliers(name,email,phone) VALUES(?,?,?)";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) return false;

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, s.getName());
                ps.setString(2, s.getEmail());
                ps.setString(3, s.getPhone());

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Supplier> getAllSuppliers() {

        List<Supplier> suppliers = new ArrayList<>();

        String sql = "SELECT * FROM suppliers ORDER BY id ASC";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) {
                return suppliers;
            }

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Supplier supplier = new Supplier();

                    supplier.setId(rs.getInt("id"));
                    supplier.setName(rs.getString("name"));
                    supplier.setEmail(rs.getString("email"));
                    supplier.setPhone(rs.getString("phone"));

                    suppliers.add(supplier);
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return suppliers;
    }

    public Supplier getSupplierById(int id) {

        String sql = "SELECT * FROM suppliers WHERE id=?";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) return null;

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        Supplier s = new Supplier();

                        s.setId(rs.getInt("id"));
                        s.setName(rs.getString("name"));
                        s.setEmail(rs.getString("email"));
                        s.setPhone(rs.getString("phone"));

                        return s;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateSupplier(Supplier s) {

        String sql = "UPDATE suppliers SET name=?, email=?, phone=? WHERE id=?";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) return false;

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, s.getName());
                ps.setString(2, s.getEmail());
                ps.setString(3, s.getPhone());
                ps.setInt(4, s.getId());

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteSupplier(int id) {

        String sql = "DELETE FROM suppliers WHERE id=?";

        try (Connection con = DBCconnection.getConnection()) {

            if (con == null) return false;

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
