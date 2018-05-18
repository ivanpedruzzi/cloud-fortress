package org.cloudfortress.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Statement;
 
public class DBConnect {
	private Connection conn = null;
	
    public DBConnect () {
    	String url = "localhost";
		String port = "3306";
		String username= "root";
		String password = "";
		String dbname = "boston";
        String databaseURL = "jdbc:mysql://" + url + ":" + port + "/" + dbname;
        
        System.out.println("Trying to connect...");
        try {
            conn = DriverManager.getConnection(databaseURL, username, password);
            if (conn != null) {
            	System.out.println("Connection established");
            }
        } catch (SQLException ex) {
            System.out.println("An error occurred. Maybe user/password is invalid");
            ex.printStackTrace();
        }
     
    }
    
    public void CloseConnection () {
    	System.out.println("Trying to disconnect...");
    	try
    	{
    	    if (conn != null)
    	    {
    	        conn.close();
    	        conn = null;
    	        System.out.println("Connection closed!");
    	    }
    	}
    	catch (SQLException sqle) 
    	{
    	    System.out.println("SQL Exception thrown: " + sqle);
    	}
    }
    
    public ResultSet doSelect(String query) {
    	ResultSet rs = null;
    	System.out.println("Trying to query the DB...");
    	try {	    	
    		Statement stmt = conn.createStatement();
	   
	        rs = stmt.executeQuery(query);
	        System.out.println("Query executed successfully!");
	    }
	    catch (SQLException sqle) 
	    {
	      System.out.println("SQL Exception thrown: " + sqle);
	    }
    	return rs;
    }
    
    public void doUpdate(String query) {
    	System.out.println("Trying to update the DB...");
    	try {	    	
    		Statement stmt = conn.createStatement();
	   
	        stmt.executeUpdate(query);
	        System.out.println("Query executed successfully!");
	    }
	    catch (SQLException sqle) 
	    {
	      System.out.println("SQL Exception thrown: " + sqle);
	    }
    }
}