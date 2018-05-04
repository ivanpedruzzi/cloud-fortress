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
		// TODO Auto-generated method stub
		super.init(config);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
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
			jsonResponse.write(httpWriter);
			
		} catch (JSONException e) {
			//send error to client, good for debugging 	
			e.printStackTrace(httpWriter);
		} 
		
		
		super.doPost(req, resp);
	}
	
	private JSONObject createUser(JSONObject createUserRequest) throws JSONException{
		JSONObject jsonResponse = new JSONObject();

		jsonResponse.put("success", true);
		jsonResponse.put("message", "Create User succeded");
		jsonResponse.put("request", createUserRequest);
		
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
