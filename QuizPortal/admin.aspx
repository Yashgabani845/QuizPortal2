<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="QuizPortal.admin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: 'Roboto', Arial, sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 20px;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #ffffff;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        h2 {
            margin-top: 20px;
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
            font-size: 24px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        #QuizGrid {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
            border-radius: 8px;
            overflow: hidden;
        }

        #QuizGrid th, #QuizGrid td {
            padding: 12px 15px;
            text-align: left;
        }

        #QuizGrid th {
            background-color: #3498db;
            color: white;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 0.5px;
        }

        #QuizGrid tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        #QuizGrid tr:hover {
            background-color: #e8f4fd;
            transition: background-color 0.3s ease;
        }

        .quiz-item {
            cursor: pointer;
            padding: 6px 10px;
            border: none;
            border-radius: 4px;
            background-color: #3498db;
            color: white;
            transition: all 0.3s ease;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .quiz-item:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 30px;
            border: none;
            width: 70%;
            max-width: 600px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        .close:hover,
        .close:focus {
            color: #2c3e50;
            text-decoration: none;
            cursor: pointer;
        }

        .question {
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
            padding: 20px;
            border-radius: 8px;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }

        .question:hover {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        #wlcmsg {
            font-size: 28px;
            color: #2c3e50;
            margin-bottom: 30px;
            display: block;
            text-align: center;
            font-weight: 300;
            animation: welcomeFadeIn 1s ease;
        }

        @keyframes welcomeFadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        .section {
            margin-bottom: 40px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            $('.quiz-item').click(function () {
                var quizId = $(this).data('id');
                $('#quizModal .modal-body').empty();
                $.ajax({
                    type: 'POST',
                    url: 'admin.aspx/GetQuizQuestions',
                    data: JSON.stringify({ quizId: quizId }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (response) {
                        if (response.d) {
                            $('#quizModal .modal-body').html(response.d);
                            $('#quizModal').fadeIn(300);
                        } else {
                            $('#quizModal .modal-body').html("<p>No questions found for this quiz.</p>");
                            $('#quizModal').fadeIn(300);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("AJAX Error: ", status, error);
                        $('#quizModal .modal-body').html("<p>Error retrieving questions. Please try again later.</p>");
                        $('#quizModal').fadeIn(300);
                    }
                });
            });

            $('.close').click(function () {
                $('#quizModal').fadeOut(300);
            });

            $(window).click(function (event) {
                if ($(event.target).is('#quizModal')) {
                    $('#quizModal').fadeOut(300);
                }
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <asp:Label ID="wlcmsg" runat="server" />
            
            <div class="section">
                <h2>Quizzes</h2>
                <asp:GridView ID="QuizGrid" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" />
                        <asp:BoundField DataField="quizname" HeaderText="Quiz Name" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="quiz-item" data-id='<%# Eval("Id") %>'>
                                    View
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

          <div class="section">
    <h2>Create New Quiz</h2>
    <div class="form-group">
        <label for="txtQuizName">Quiz Name:</label>
        <asp:TextBox ID="txtQuizName" runat="server" CssClass="form-control" />
    </div>
    <div class="form-group">
        <label for="txtDescription">Description:</label>
        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" />
    </div>
    <div class="form-group">
        <label for="filePhoto">Photo (optional):</label>
        <asp:FileUpload ID="filePhoto" runat="server" CssClass="form-control" />
    </div>
    <asp:Button ID="btnCreateQuiz" runat="server" Text="Create Quiz" OnClick="btnCreateQuiz_Click" CssClass="btn btn-primary" />
</div>

            <div class="section">
                <h2>Add Question to Quiz</h2>
                <div class="form-group">
                    <label for="ddlQuizzes">Select Quiz:</label>
                    <asp:DropDownList ID="ddlQuizzes" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label for="txtQuestion">Question:</label>
                    <asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label for="txtOption1">Option 1:</label>
                    <asp:TextBox ID="txtOption1" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label for="txtOption2">Option 2:</label>
                    <asp:TextBox ID="txtOption2" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label for="txtOption3">Option 3:</label>
                    <asp:TextBox ID="txtOption3" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label for="txtOption4">Option 4:</label>
                    <asp:TextBox ID="txtOption4" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label for="txtAnswer">Correct Answer:</label>
                    <asp:TextBox ID="txtAnswer" runat="server" CssClass="form-control" />
                </div>
                <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" OnClick="btnAddQuestion_Click" CssClass="btn btn-primary" />
            </div>

            <div class="modal" id="quizModal">
                <div class="modal-content">
                    <span class="close">&times;</span>
                    <h3>Quiz Questions</h3>
                    <div class="modal-body">
                        
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>