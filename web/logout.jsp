<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session
    session.invalidate();

    // Optional: Redirect with message parameter
    response.sendRedirect("index.html?message=logout");
%>
