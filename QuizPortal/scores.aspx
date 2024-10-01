<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="scores.aspx.cs" Inherits="QuizPortal.scores" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Scores</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
        /* Navbar styling */
        .navbar {
            background-color: black;
        }

        .navbar-nav .nav-link, 
        .navbar-brand {
            color: white !important;
            padding: 10px 15px;
            font-size: 18px;
        }

        .navbar-nav .nav-item.active .nav-link {
            border: 2px solid white;
            box-shadow: 0px 0px 10px rgba(255, 255, 255, 0.5);
            border-radius: 5px;
        }

        .navbar-nav .nav-link i {
            margin-right: 8px;
        }

        .navbar-toggler-icon {
            background-color: white;
        }

        .navbar-light .navbar-nav .nav-link:hover {
            color: lightgray !important;
        }

        .nav-item.active .nav-link:hover {
            color: white !important;
        }

        .no-quiz {
            background-color: lightcoral;
            border: 2px solid darkred;
            color: darkred;
            padding: 20px;
            text-align: center;
            border-radius: 5px;
        }

        .start-quiz-btn {
            margin-top: 20px;
            text-align: center;
        }

        .table-title {
            text-align: center;
            font-weight: bold;
            font-size: 24px;
            margin-bottom: 20px;
        }

        table {
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navbar Section -->
        <nav class="navbar navbar-expand-lg navbar-light">
            <a class="navbar-brand" href="home.aspx">QuizPortal</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="home.aspx">
                            <i class="fas fa-home"></i> Home
                        </a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="scores.aspx">
                            <i class="fas fa-trophy"></i> Scores
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="profile.aspx">
                            <i class="fas fa-user"></i> Profile
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Scores Section -->
        <div class="container mt-4">
            <h2 class="table-title">Your Quiz Scores</h2>

            <div id="noQuizPanel" class="no-quiz" runat="server" visible="false">
                <h4>You have not given any quizzes yet.</h4>
                <div class="start-quiz-btn">
                    <asp:LinkButton ID="StartQuizButton" runat="server" CssClass="btn btn-primary" Text="Start Quiz Now" PostBackUrl="~/home.aspx" />
                </div>
            </div>

            <!-- Display this table if quizzes are available -->
            <div id="quizTable" runat="server" visible="false">
                <table class="table table-bordered table-striped">
                    <thead class="thead-dark">
                        <tr>
                            <th scope="col">#</th>
                            <th scope="col">Date</th>
                            <th scope="col">Quiz Image</th>
                            <th scope="col">Quiz Name</th>
                            <th scope="col">Score</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="QuizRepeater" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Container.ItemIndex + 1 %></td>
                                     <td><%# Eval("date", "{0:yyyy-MM-dd}") %></td>
                                    <td><img src='<%# ResolveUrl("~/images/" + Eval("photo")) %>' alt="Quiz Image" class="img-thumbnail" style="width: 100px; height: auto;" /></td>
                                    <td><%# Eval("quizname") %></td>
                                    <td><%# Eval("score") %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
