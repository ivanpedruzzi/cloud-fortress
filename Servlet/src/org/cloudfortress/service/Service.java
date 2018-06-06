package org.cloudfortress.service;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Statement;

@SuppressWarnings("serial")
public class Service extends HttpServlet {
	
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		super.destroy();
	}

	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}
	
	/*@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1) throws ServletException, IOException {
		super.service(arg0, arg1);
		System.out.println("org.cloudfortress.service.Service.service()");
	}*/
	
	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.getWriter().write("Hello World");
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("org.cloudfortress.service.Service.doPost()");
		
		String contentType = "application/json";
		resp.setContentType(contentType);
		
		StringWriter outputWriter = new StringWriter();
		StringWriter writer = new StringWriter();
		JSONObject jsonResponse= new JSONObject();
		PrintWriter httpWriter = resp.getWriter();
		try {
			IOUtils.copy(req.getInputStream(), writer, StandardCharsets.UTF_8);
			JSONObject js = new JSONObject(writer.toString());
			Object obj;
			
			if( (obj = js.get("create_user")) != null){
				jsonResponse = createUser((JSONObject)obj);
			}
			else if( (obj = js.get("create_account")) != null){
				jsonResponse = createAccount((JSONObject)obj);
			}
			else {
				jsonResponse = new JSONObject();
				jsonResponse.put("success", false);
				jsonResponse.put("error", "Request unknown");
			}
		
		} catch (Exception e) {
			e.printStackTrace();
			jsonResponse.put("success", false);
			jsonResponse.put("error", e.getMessage());
		}
		jsonResponse.write(outputWriter, 2, 0);
		httpWriter.write(outputWriter.toString());
		httpWriter.flush();

	}
	
	private JSONObject createUser(JSONObject createUserRequest) throws JSONException, SQLException{
		JSONObject jsonResponse = new JSONObject();
		JSONObject jsonAddress = (JSONObject)createUserRequest.get("address");
		
		try {
			Connection conn = DBConnect();
			//CallableStatement cStmt = conn.prepareCall("{call createUser(user, password, first, last, phone, mail, street, zip, city, state, countryCode)}");
			CallableStatement cStmt = conn.prepareCall("{call createUser(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
			cStmt.setString(1, createUserRequest.getString("user"));
			cStmt.setString(2, createUserRequest.getString("password"));
			cStmt.setString(3, createUserRequest.getString("first"));
			cStmt.setString(4, createUserRequest.getString("last"));
			cStmt.setString(5, createUserRequest.getString("phone"));
			cStmt.setString(6, createUserRequest.getString("email"));
			cStmt.setString(7,  jsonAddress.getString("addresstreet"));
			cStmt.setString(8,  jsonAddress.getString("postalCode"));
			cStmt.setString(9,  jsonAddress.getString("city"));
			cStmt.setString(10, jsonAddress.getString("state"));
			cStmt.setString(11, jsonAddress.getString("countryCode"));
			cStmt.execute();
			conn.close();
			
			jsonResponse.put("success", true);
			jsonResponse.put("message", "Create User succeded");
			jsonResponse.put("request", createUserRequest);

		} catch(SQLException ex) {
            ex.printStackTrace();
            throw ex;
		}
		
		return jsonResponse;
	}
	
	private JSONObject createAccount(JSONObject createAccountRequest) throws JSONException{
		JSONObject jsonResponse = new JSONObject();

		jsonResponse.put("success", true);
		jsonResponse.put("message", "Create account succeded");
		jsonResponse.put("request", createAccountRequest);
		
		return jsonResponse;
	}
	
	private Connection DBConnect() throws SQLException 
	{
		Connection conn = null;
		String url = "localhost";
		String port = "3306";
		String username= "root";
		String password = "IVI2017#MySQL";
		String dbname = "boston";
        String databaseURL = "jdbc:mysql://" + url + ":" + port + "/" + dbname;
        try {
        	
        	try{//Force JDBC driver register into the DriverManager 
        		 Class.forName("com.mysql.jdbc.Driver").newInstance();
        	}catch(Exception e){}
        	
        	
            conn = DriverManager.getConnection(databaseURL, username, password);
        } catch (SQLException ex) {
            ex.printStackTrace();
            throw ex;
        }
        return conn;
	}
}
