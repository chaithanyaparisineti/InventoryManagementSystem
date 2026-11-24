
package com.inventory.controller;

import java.io.IOException;
import java.util.List;

import com.inventory.dao.SupplierDAO;
import com.inventory.model.Supplier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/suppliers")
public class SupplierServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private SupplierDAO dao = new SupplierDAO();

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("edit".equals(action)) {

            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Supplier supplier = dao.getSupplierById(id);

                if (supplier == null) {
                    response.sendRedirect("suppliers?error=notfound");
                    return;
                }

                request.setAttribute("supplier", supplier);
                request.getRequestDispatcher("editSupplier.jsp")
                       .forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect("suppliers?error=invalid");
            }

        } else {

        	List<Supplier> suppliers = dao.getAllSuppliers();

        	request.setAttribute("suppliers", suppliers);

        	request.getRequestDispatcher("suppliers.jsp")
        	       .forward(request, response);
    }
    }
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {

            if ("add".equals(action) || "update".equals(action)) {

                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");

                if (name == null || name.trim().isEmpty()
                        || email == null || email.trim().isEmpty()
                        || phone == null || phone.trim().isEmpty()) {

                    response.sendRedirect("suppliers?error=invalid");
                    return;
                }

                Supplier s = new Supplier();
                s.setName(name.trim());
                s.setEmail(email.trim());
                s.setPhone(phone.trim());

                boolean success;

                if ("add".equals(action)) {
                    success = dao.addSupplier(s);
                } else {
                    s.setId(Integer.parseInt(request.getParameter("id")));
                    success = dao.updateSupplier(s);
                }

                response.sendRedirect(success
                        ? "suppliers?success=1"
                        : "suppliers?error=failed");

            } else if ("delete".equals(action)) {

                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = dao.deleteSupplier(id);

                response.sendRedirect(success
                        ? "suppliers?success=1"
                        : "suppliers?error=failed");

            } else {
                response.sendRedirect("suppliers");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("suppliers?error=invalid");
        }
    }
}
