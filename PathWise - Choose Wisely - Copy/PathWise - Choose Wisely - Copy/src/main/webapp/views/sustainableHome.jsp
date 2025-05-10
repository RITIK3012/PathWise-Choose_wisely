<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pathwise - Choose Wisely. Commute Smartly.</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
        }
        .hero-section {
            background: linear-gradient(135deg, #8BC34A 0%, #009688 100%);
            color: white;
            padding: 4rem 0;
            border-radius: 0 0 20px 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .form-card {
            background-color: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.1);
        }
        .btn-eco {
            background: linear-gradient(135deg, #8BC34A 0%, #009688 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            transition: all 0.3s ease;
            margin-top: 20px;
        }
        .btn-eco:hover {
            background: linear-gradient(135deg, #7CB342 0%, #00897B 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .eco-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            background: -webkit-linear-gradient(135deg, #8BC34A 0%, #009688 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .preference-select {
            padding: 10px;
            border-radius: 10px;
            border: 1px solid #ced4da;
            width: 100%;
        }
        .footer {
            background-color: #343a40;
            color: white;
            padding: 2rem 0;
            margin-top: 4rem;
        }
        .input-with-icon {
            position: relative;
        }
        .input-with-icon i {
            position: absolute;
            left: 10px;
            top: 14px;
            color: #6c757d;
        }
        .input-with-icon input {
            padding-left: 35px;
        }
        @media (max-width: 767px) {
            .hero-section {
                padding: 2rem 0;
            }
            .eco-benefits {
                margin-top: 2rem;
            }
        }
    </style>
</head>
<body>

<div class="hero-section text-center">
    <div class="container">
        <div class="row">
            <div class="col-12 d-flex justify-content-end mb-3">
                <sec:authorize access="isAuthenticated()">
                    <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-outline-light me-2">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                    <form action="${pageContext.request.contextPath}/logout" method="post" class="d-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn btn-light">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </button>
                    </form>
                </sec:authorize>
                <sec:authorize access="!isAuthenticated()">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-light me-2">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light">
                        <i class="fas fa-user-plus"></i> Register
                    </a>
                </sec:authorize>
            </div>
        </div>
        <h1 class="display-4 fw-bold">Pathwise - Choose Wisely. Commute Smartly.</h1>
        <p class="fs-4">Smart, Sustainable Mobility Planning with AI</p>
        <p class="lead">Find the greenest, fastest, or most economical route for your journey</p>
    </div>
</div>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="form-card">
                <h2 class="text-center mb-4">Plan Your Sustainable Journey</h2>

                <form action="/sustainable/plan" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <sec:authorize access="isAuthenticated()">
                        <input type="hidden" name="name" value="<sec:authentication property='principal.username' />" />
                    </sec:authorize>
                    <sec:authorize access="!isAuthenticated()">
                        <div class="mb-3 input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" class="form-control" id="name" name="name" placeholder="Your Name" required>
                        </div>
                    </sec:authorize>

                    <div class="mb-3 input-with-icon">
                        <i class="fas fa-map-marker-alt"></i>
                        <input type="text" class="form-control" id="origin" name="origin" placeholder="Starting Point" required>
                    </div>

                    <div class="mb-3 input-with-icon">
                        <i class="fas fa-flag-checkered"></i>
                        <input type="text" class="form-control" id="destination" name="destination" placeholder="Destination" required>
                    </div>

                    <div class="mb-4">
                        <label for="preference" class="form-label">Your Priority:</label>
                        <select class="preference-select" id="preference" name="preference" required>
                            <option value="FASTEST">Fastest Route</option>
                            <option value="CHEAPEST">Cheapest Route</option>
                            <option value="GREENEST">Eco-friendly (Lowest CO₂)</option>
                            <option value="BALANCED">Balanced (Time/Cost/Eco)</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label for="travelType" class="form-label">Travelling Type:</label>
                        <select class="preference-select" id="travelType" name="travelType" required>
                            <option value="PRIVATE">Private Vehicle</option>
                            <option value="PUBLIC">Public Vehicle</option>
                        </select>
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-eco btn-lg">
                            <i class="fas fa-search me-2"></i> Find My Routes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="row eco-benefits mt-5">
        <h3 class="text-center mb-4">Why Use EcoJourney?</h3>

        <div class="col-md-4 mb-4">
            <div class="card h-100 text-center p-4">
                <div class="card-body">
                    <i class="fas fa-leaf eco-icon"></i>
                    <h4>Eco-Friendly Options</h4>
                    <p>See the CO₂ emissions for each travel option and choose the most sustainable route for your journey.</p>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4">
            <div class="card h-100 text-center p-4">
                <div class="card-body">
                    <i class="fas fa-robot eco-icon"></i>
                    <h4>AI-Powered Analysis</h4>
                    <p>Our AI analyzes all travel options and recommends the best one based on your personal priorities.</p>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4">
            <div class="card h-100 text-center p-4">
                <div class="card-body">
                    <i class="fas fa-balance-scale eco-icon"></i>
                    <h4>Compare All Options</h4>
                    <p>See a detailed comparison of walking, cycling, public transport, and driving options at a glance.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer text-center">
    <div class="container">
        <p>© 2025 Pathwise - Choose Wisely. Commute Smartly.</p>
        <p>Built with <i class="fas fa-heart"></i> for a greener future</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>