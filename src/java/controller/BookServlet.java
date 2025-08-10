/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AuthorDAO;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.BookDAO;
import model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import model.Author;

/**
 *
 * @author hasit
 */
@WebServlet("/book")
public class BookServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final AuthorDAO authorDAO = new AuthorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Load all books and authors
        List<Book> bookList = bookDAO.getAllBooks();
        List<Author> authorList = authorDAO.getAllAuthors();

        request.setAttribute("bookList", bookList);
        request.setAttribute("authorList", authorList);

        // Forward to JSP
        request.getRequestDispatcher("book.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); // Handle UTF-8 input
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int bookId = Integer.parseInt(request.getParameter("book_id"));
            bookDAO.deleteBook(bookId);
        } else {
            // Common input fields
            String bookName = request.getParameter("book_name");
            String isbnNo = request.getParameter("isbn_no");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock_quantity"));
            int authorId = Integer.parseInt(request.getParameter("author_id"));

            Book book = new Book();
            book.setBookName(bookName);
            book.setIsbnNo(isbnNo);
            book.setPrice(price);
            book.setStockQuantity(stock);
            book.setAuthorId(authorId);

            if ("save".equals(action)) {
                bookDAO.saveBook(book);
            } else if ("update".equals(action)) {
                int bookId = Integer.parseInt(request.getParameter("book_id"));
                book.setBookId(bookId);
                bookDAO.updateBook(book);
            }
        }

        // Reload lists and forward
        doGet(request, response);
    }
}