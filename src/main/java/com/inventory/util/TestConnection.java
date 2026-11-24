
package com.inventory.util;

import java.sql.Connection;

public class TestConnection {

    public static void main(String[] args) {

        Connection con = DBCconnection.getConnection();

        if (con != null) {

            System.out.println("Connection Test Passed!");

            try {
                con.close();
                System.out.println("Connection Closed!");

            } catch (Exception e) {
                e.printStackTrace();
            }

        } else {

            System.out.println("Connection Test Failed!");
        }
    }
}
