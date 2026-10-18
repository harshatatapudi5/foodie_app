package com.tap.util;

import java.sql.Connection;
import java.sql.ResultSet;

public class Test {
    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection()) {
            System.out.println("--- COLUMNS IN user_details ---");
            try (ResultSet rs = con.getMetaData().getColumns(null, null, "user_details", null)) {
                while (rs.next()) {
                    System.out.println(rs.getString("COLUMN_NAME") + " (" + rs.getString("TYPE_NAME") + ")");
                }
            }
            System.out.println("--- COLUMNS IN orders ---");
            try (ResultSet rs = con.getMetaData().getColumns(null, null, "orders", null)) {
                while (rs.next()) {
                    System.out.println(rs.getString("COLUMN_NAME") + " (" + rs.getString("TYPE_NAME") + ")");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
