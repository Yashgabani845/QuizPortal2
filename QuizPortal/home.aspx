<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="home.aspx.cs" Inherits="QuizPortal.home" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Home</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
        .card:hover {
            transform: scale(1.05);
            box-shadow: 0px 0px 15px rgba(0,0,0,0.3);
        }
        .carousel-inner img {
            width: 85%;
            max-width: 85%;
            height: auto;
            margin: 0 auto;
        }
        .carousel-control-prev, .carousel-control-next {
            width: 5%;
        }
        .carousel-control-prev-icon, .carousel-control-next-icon {
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 50%;
            padding: 10px;
        }
        .modal-dialog {
            max-width: 800px;
            margin: 30px auto;
        }
        .modal-content {
            padding: 20px;
        }
        .modal-body {
            padding: 20px;
        }
        .modal-footer {
            padding: 10px;
        }

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

    </style>
</head>
<body>
    <form id="home_form" runat="server">
        <asp:HiddenField ID="hfQuizName" runat="server" />

        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-light">
            <a class="navbar-brand" href="#">Logo</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item active">
                        <a class="nav-link" href="home.aspx">
                            <i class="fas fa-home"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
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


        <div id="quizCarousel" class="carousel slide" data-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="feed.jpg" class="d-block mx-auto" alt="Quiz 1">
                </div>
                <div class="carousel-item">
                    <img src="feed.jpg" class="d-block mx-auto" alt="Quiz 2">
                </div>
                <div class="carousel-item">
                    <img src="feed.jpg" class="d-block mx-auto" alt="Quiz 3">
                </div>
            </div>
            <a class="carousel-control-prev" href="#quizCarousel" role="button" data-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
            </a>
            <a class="carousel-control-next" href="#quizCarousel" role="button" data-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
            </a>
        </div>

        <!-- Quiz Cards -->
        <div class="container mt-4">
            <div class="row">
                <asp:Repeater ID="QuizRepeater" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 mb-4">
                            <div class="card" data-toggle="modal" data-target="#quizModal" onclick="setModalContent('<%# Eval("quizname") %>', '<%# Eval("description") %>', '<%# Eval("quizname") %>')">
                                <img class="card-img-top" src='<%# ResolveUrl("~/images/" + Eval("photo")) %>' alt="Quiz Image">
                                <div class="card-body">
                                    <h5 class="card-title"><%# Eval("quizname") %></h5>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="quizModal" tabindex="-1" role="dialog" aria-labelledby="quizModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="quizModalLabel"></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p id="quizDescription"></p>
                        <p>No. of questions: 5</p>
                    </div>
                    <div class="modal-footer">
                        <asp:LinkButton ID="startQuizButton" runat="server" CssClass="btn btn-primary" Text="Start" OnClick="StartQuiz_btnClick" />
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        function expandCard(title, description) {
            document.getElementById('expandedCard').classList.remove('d-none');
            document.getElementById('expandedTitle').innerText = title;
            document.getElementById('expandedDescription').innerText = description;
        }

        function closeCard() {
            document.getElementById('expandedCard').classList.add('d-none');
        }

        function setModalContent(title, description, quizName) {
            document.getElementById('quizModalLabel').innerText = title;
            document.getElementById('quizDescription').innerText = description;
            document.getElementById('<%= hfQuizName.ClientID %>').value = quizName;
        }
    </script>
</body>
</html>