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
		
		PrintWriter httpWriter = resp.getWriter();
		try {
			StringWriter writer = new StringWriter(); 
			IOUtils.copy(req.getInputStream(), writer, StandardCharsets.UTF_8);
			JSONObject js = new JSONObject(writer.toString());
			Object obj;
			JSONObject jsonResponse;
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

			writer = new StringWriter();
			jsonResponse.write(writer, 2, 0);
			System.out.println("org.cloudfortress.service.Service.doPost() content:" + writer.toString());
			httpWriter.write(writer.toString());
			httpWriter.flush();
			
		} catch (JSONException e) {
			//send error to client, good for debugging 	
			e.printStackTrace(httpWriter);
		} 
	}
	
	private JSONObject createUser(JSONObject createUserRequest) throws JSONException{
		JSONObject jsonResponse = new JSONObject();

		jsonResponse.put("success", true);
		jsonResponse.put("message", "Create User succeded");
		jsonResponse.put("request", createUserRequest);
		
		/*CallableStatement cStmt = conn.prepareCall("{call createUser(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
		createUserRequest.get
		cStmt.setString(1, "abcdefg");
		cStmt.execute();*/
		
		return jsonResponse;
	}
	
	private JSONObject createAccount(JSONObject createAccountRequest) throws JSONException{
		JSONObject jsonResponse = new JSONObject();

		jsonResponse.put("success", true);
		jsonResponse.put("message", "Create account succeded");
		jsonResponse.put("request", createAccountRequest);
		
		return jsonResponse;
	}
}
