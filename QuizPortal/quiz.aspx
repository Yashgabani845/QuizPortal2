<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="quiz.aspx.cs" Inherits="QuizPortal.quiz" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quiz</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            margin: 0;
            padding: 0;
        }

        form {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #ffffff;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        .quiz-title {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 30px;
            color: #333;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
            background-color: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }

        .question {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #fafafa;
            border-radius: 6px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .question-label {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            display: block;
            color: #444;
        }

        .option {
            margin-bottom: 20px;
        }

        .option input[type="radio"] {
            margin-right: 10px;
        }

        .button {
            display: inline-block;
            background-color: #007bff;
            color: #ffffff;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-right: 10px;
        }

        .button:hover {
            background-color: #0056b3;
        }

        .button:active {
            background-color: #004085;
            transform: scale(0.98);
        }

        .button:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }

        .navigation-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .progress-bar {
            width: 100%;
            height: 10px;
            background-color: #e0e0e0;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .progress {
            height: 100%;
            background-color: #007bff;
            border-radius: 5px;
            transition: width 0.3s ease;
        }

        @media (max-width: 768px) {
            form {
                margin: 20px;
                padding: 15px;
            }

            .quiz-title {
                font-size: 20px;
            }

            .question-label {
                font-size: 16px;
            }

            .button {
                font-size: 14px;
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="quiz-title">
            <asp:Label ID="QuizTitle" runat="server" />
        </div>
        
        <asp:Panel ID="NoQuestionsPanel" runat="server" CssClass="alert" Visible="false">
            <asp:Label ID="NoQuestionsMessage" runat="server" Text="No questions found for this quiz." />
        </asp:Panel>

        <div class="progress-bar">
            <div id="progressBar" class="progress" style="width: 0%;" runat="server"></div>
        </div>

        <asp:Repeater ID="QuestionRepeater" runat="server" OnItemDataBound="QuestionRepeater_ItemDataBound">
            <ItemTemplate>
                <div class="question" style="display: none;">
                    <asp:Label ID="QuestionLabel" runat="server" CssClass="question-label" />
                    <asp:RadioButtonList ID="OptionList" runat="server" RepeatDirection="Vertical" CssClass="option">
                    </asp:RadioButtonList>
                    <asp:HiddenField ID="CorrectAnswer" runat="server" />
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <div class="navigation-buttons">
            <asp:Button ID="PreviousButton" runat="server" Text="Previous" CssClass="button" OnClientClick="previousQuestion(); return false;" />
            <asp:Button ID="NextButton" runat="server" Text="Next" CssClass="button" OnClientClick="nextQuestion(); return false;" />
            <asp:Button ID="SubmitButton" runat="server" Text="Submit" CssClass="button" OnClick="SubmitButton_Click" style="display: none;" />
        </div>
    </form>

    <script type="text/javascript">
        var currentQuestionIndex = 0;
        var totalQuestions = 0;

        function initializeQuiz() {
            var questions = document.querySelectorAll('.question');
            totalQuestions = questions.length;
            if (totalQuestions > 0) {
                questions[0].style.display = 'block';
                updateButtons();
                updateProgressBar();
            }
        }

        function previousQuestion() {
            if (currentQuestionIndex > 0) {
                document.querySelectorAll('.question')[currentQuestionIndex].style.display = 'none';
                currentQuestionIndex--;
                document.querySelectorAll('.question')[currentQuestionIndex].style.display = 'block';
                updateButtons();
                updateProgressBar();
            }
        }

        function nextQuestion() {
            if (currentQuestionIndex < totalQuestions - 1) {
                document.querySelectorAll('.question')[currentQuestionIndex].style.display = 'none';
                currentQuestionIndex++;
                document.querySelectorAll('.question')[currentQuestionIndex].style.display = 'block';
                updateButtons();
                updateProgressBar();
            }
        }

        function updateButtons() {
            var previousButton = document.getElementById('<%= PreviousButton.ClientID %>');
            var nextButton = document.getElementById('<%= NextButton.ClientID %>');
            var submitButton = document.getElementById('<%= SubmitButton.ClientID %>');

            previousButton.disabled = currentQuestionIndex === 0;

            if (currentQuestionIndex === totalQuestions - 1) {
                nextButton.style.display = 'none';
                submitButton.style.display = 'inline-block';
            } else {
                nextButton.style.display = 'inline-block';
                submitButton.style.display = 'none';
            }
        }

        function updateProgressBar() {
            var progressPercentage = ((currentQuestionIndex + 1) / totalQuestions) * 100;
            document.getElementById('progressBar').style.width = progressPercentage + '%';
        }

        window.onload = initializeQuiz;
    </script>
</body>
</html>