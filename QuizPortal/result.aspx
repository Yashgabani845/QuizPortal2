<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="result.aspx.cs" Inherits="QuizPortal.result" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quiz Result</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f7f7f7;
        }
        .result-container {
            text-align: center;
            padding: 50px;
            background-color: #ffffff;
            border: 2px solid #e0e0e0;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            width: 50%;
            margin: 100px auto;
        }
        .result-header {
            font-size: 24px;
            font-weight: bold;
            color: #4CAF50;
            margin-bottom: 30px;
        }
        .score {
            font-size: 22px;
            color: #333;
        }
        .back-button {
            margin-top: 30px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .back-button:hover {
            background-color: #3e8e41;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="result-container">
            <div class="result-header">Quiz Result</div>
            <div class="score">
                <asp:Label ID="ScoreLabel" runat="server" Text=""></asp:Label>
            </div>
            <asp:Button ID="BackButton" runat="server" Text="Back to Home" CssClass="back-button" OnClick="BackButton_Click" />
        </div>
    </form>
</body>
</html>
