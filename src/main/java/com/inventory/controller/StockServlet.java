
package com.inventory.controller;

import java.io.IOException;

import com.inventory.dao.ProductDAO;
import com.inventory.dao.StockDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/stock")
public class StockServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StockDAO stockDAO = new StockDAO();
    private ProductDAO productDAO = new ProductDAO();

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

        try {
            if ("history".equals(action)) {
                request.setAttribute(
                    "history", stockDAO.getAllHistory()
                );
                request.getRequestDispatcher(
                    "stock_history.jsp"
                ).forward(request, response);

            } else {
                request.setAttribute(
                    "products", productDAO.getAllProducts()
                );
                request.getRequestDispatcher(
                    "stock.jsp"
                ).forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(
                request.getParameter("productId")
            );

            int quantity = Integer.parseInt(
                request.getParameter("quantity")
            );

            String type = request.getParameter("type");

            if (productId <= 0 || quantity <= 0 ||
                (!"IN".equals(type) && !"OUT".equals(type))) {
                response.sendRedirect("stock?error=invalid");
                return;
            }

            String result = stockDAO.updateStock(
                productId, quantity, type
            );

            switch (result) {
                case "SUCCESS":
                    response.sendRedirect("stock?success=1");
                    break;

                case "INSUFFICIENT":
                    response.sendRedirect(
                        "stock?error=insufficient"
                    );
                    break;

                case "NOT_FOUND":
                    response.sendRedirect("stock?error=notfound");
                    break;

                default:
                    response.sendRedirect("stock?error=failed");
                    break;
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("stock?error=invalid");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
