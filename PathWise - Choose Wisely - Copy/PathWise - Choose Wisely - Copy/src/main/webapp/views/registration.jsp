<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Glassmorphism background */
        body {
            position: relative;
            background: linear-gradient(135deg, #87CEEB, #3CB371, #20B2AA);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
            overflow: hidden;
        }

        /* Animated background */
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Glass elements in background */
        .glass-decoration {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            z-index: 0;
        }

        .decoration-1 {
            width: 300px;
            height: 300px;
            top: 10%;
            left: 20%;
        }

        .decoration-2 {
            width: 200px;
            height: 200px;
            bottom: 15%;
            right: 15%;
        }

        .decoration-3 {
            width: 150px;
            height: 150px;
            top: 60%;
            left: 10%;
        }

        .decoration-4 {
            width: 250px;
            height: 250px;
            top: 5%;
            right: 25%;
        }

        /* Solid form container */
        .container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 500px;
            padding: 40px;
            position: relative;
            z-index: 10;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #2e7d60;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .header p {
            color: #666;
            font-size: 16px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            background: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            color: #333;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            position: relative;
            z-index: 1;
        }

        /* Hover elevation effect */
        .form-control:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-color: #3CB371;
        }

        .form-control:focus {
            transform: translateY(-3px);
            border-color: #3CB371;
            box-shadow: 0 5px 15px rgba(60, 179, 113, 0.2);
            outline: none;
        }

        .form-control::placeholder {
            color: #aaa;
        }

        .error {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        .button {
            background: linear-gradient(135deg, #3CB371, #20B2AA);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px 20px;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 1;
        }

        .button:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .button:active {
            transform: translateY(0);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .form-group.error-state .form-control {
            border-color: #e74c3c;
            background-color: #fff8f8;
        }

        .form-group.error-state .error {
            display: block;
        }

        .success-message {
            color: #2ecc71;
            text-align: center;
            margin-top: 20px;
            font-weight: 600;
            display: none;
            font-size: 18px;
        }

        /* Additional animation for focus transition */
        @keyframes focusField {
            0% { transform: translateY(0); box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05); }
            100% { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(60, 179, 113, 0.2); }
        }
        
        .error-message {
            color: #e74c3c;
            background-color: #fde8e7;
            border-radius: 4px;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
            display: block;
        }
    </style>
</head>
<body>
    <!-- Glassmorphism background decorations -->
    <div class="glass-decoration decoration-1"></div>
    <div class="glass-decoration decoration-2"></div>
    <div class="glass-decoration decoration-3"></div>
    <div class="glass-decoration decoration-4"></div>

    <!-- Solid form container -->
    <div class="container">
        <div class="header">
            <h1>Create your account</h1>
            <p>Start your journey with PathWise</p>
        </div>
        
        <form action="${pageContext.request.contextPath}/registration" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            <c:if test="${not empty usernameError}">
                <div class="error-message">${usernameError}</div>
            </c:if>
            <c:if test="${not empty emailError}">
                <div class="error-message">${emailError}</div>
            </c:if>
            <c:if test="${not empty passwordError}">
                <div class="error-message">${passwordError}</div>
            </c:if>
            
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Enter your full name" required>
                <div class="error">Please enter your full name</div>
            </div>
            
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Choose a username" required>
                <div class="error">Username must be between 3-20 characters</div>
            </div>
            
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
                <div class="error">Please enter a valid email address</div>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Create a password" required>
                <div class="error">Password must be at least 8 characters</div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm your password" required>
                <div class="error">Passwords do not match</div>
            </div>
            
            <button type="submit" class="button">Create Account</button>
            
            <div class="login-link">
                Already have an account? <a href="${pageContext.request.contextPath}/login">Log in</a>
            </div>
        </form>
        
        <div class="success-message">Account created successfully! Redirecting to login...</div>
    </div>

    <script>
        // Registration form validation can be added here
    </script>
</body>
</html>