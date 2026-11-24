
package com.inventory.controller;

import java.io.IOException;
import java.util.List;

import com.inventory.dao.ProductDAO;
import com.inventory.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO dao = new ProductDAO();

    // DISPLAY PRODUCTS AND OPEN EDIT PAGE
    @Override
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

                Product product = dao.getProductById(id);

                if (product == null) {
                    response.sendRedirect("products?error=notfound");
                    return;
                }

                request.setAttribute("product", product);

                request.getRequestDispatcher("editProduct.jsp")
                        .forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect("products?error=invalid");
            }

        } else {

            List<Product> products = dao.getAllProducts();

            request.setAttribute("products", products);

            request.getRequestDispatcher("products.jsp")
                    .forward(request, response);
        }
    }

    // ADD, UPDATE AND DELETE PRODUCTS
    @Override
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
                String category = request.getParameter("category");

                double price = Double.parseDouble(
                        request.getParameter("price"));

                int quantity = Integer.parseInt(
                        request.getParameter("quantity"));

                int supplierId = Integer.parseInt(
                        request.getParameter("supplierId"));

                if (name == null || name.trim().isEmpty()
                        || category == null || category.trim().isEmpty()
                        || price < 0 || quantity < 0 || supplierId <= 0) {

                    response.sendRedirect("products?error=invalid");
                    return;
                }

                Product p = new Product();

                p.setName(name.trim());
                p.setCategory(category.trim());
                p.setPrice(price);
                p.setQuantity(quantity);
                p.setSupplierId(supplierId);

                boolean success;

                if ("add".equals(action)) {

                    success = dao.addProduct(p);

                } else {

                    int id = Integer.parseInt(
                            request.getParameter("id"));

                    p.setId(id);

                    success = dao.updateProduct(p);
                }

                if (success) {
                    response.sendRedirect("products?success=1");
                } else {
                    response.sendRedirect("products?error=failed");
                }

            } else if ("delete".equals(action)) {

                int id = Integer.parseInt(
                        request.getParameter("id"));

                boolean success = dao.deleteProduct(id);

                if (success) {
                    response.sendRedirect("products?success=1");
                } else {
                    response.sendRedirect("products?error=failed");
                }

            } else {

                response.sendRedirect("products");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect("products?error=invalid");

        } catch (Exception e) {

            throw new ServletException(e);
        }
    }
}
