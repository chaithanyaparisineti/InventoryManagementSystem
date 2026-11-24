
package com.inventory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.inventory.model.Admin;
import com.inventory.util.DBCconnection;

public class AdminDAO {

    public Admin login(String username, String password) {

        Admin admin = null;

        String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";

        try (
            Connection con = DBCconnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                admin = new Admin();

                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));

            }

            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return admin;
    }
}
