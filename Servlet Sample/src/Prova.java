import java.util.Date;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public final class Prova extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

	response.setContentType("text/html");
	PrintWriter writer = response.getWriter();
	Date data = new Date();
	
	writer.println("<html>");
	writer.println("<head>");
	writer.println("<title>Sample Application: Date Time</title>");
	writer.println("</head>");
	writer.println("<body bgcolor=white>");

	writer.println("<h1>Sample Application: Date Time</h1>");
	writer.println("<b>Sample application that prints date and time</b> <br>");
	writer.println("Date and time: ");
	writer.println(data);
	writer.println("<br><br>");
	

	if(data.getHours()<=12) {
		writer.println("Buongiorno!");
	} else {
		writer.println("Buonasera!");
	}

	writer.println("</body>");
	writer.println("</html>");

    }


}