using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizPortal
{
    public partial class quiz : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string username = Session["Username"].ToString();
            if (Session["Username"] == null)
            {
                Response.Redirect("login.aspx"); 
                return;
            }

            if (!DoesUserProfileExist(username))
            {
                Response.Redirect("profile.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string quizname = Request.QueryString["quizname"];
                QuizTitle.Text = quizname;
                if (string.IsNullOrEmpty(quizname))
                {
                    Response.Write("Quiz name is missing in the URL");
                    return;
                }

                try
                {
                    LoadQuestions(quizname);
                }
                catch (Exception ex)
                {
                    Response.Write("Error loading questions: " + ex.Message);
                }
            }
        }

        private bool DoesUserProfileExist(string username)
        {
            using (SqlConnection connection = new SqlConnection(WebConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString))
            {
                connection.Open();

                SqlCommand command = new SqlCommand(
                    @"SELECT COUNT(*) FROM Profile p
                      INNER JOIN Users u ON u.Id = p.user_id
                      WHERE u.username = @Username", connection);
                command.Parameters.AddWithValue("@Username", username);

                int profileCount = (int)command.ExecuteScalar();
                return profileCount > 0; 
            }
        }

        protected void LoadQuestions(string quizname)
        {
            string quizidString = GetQuizIdFromTitle(quizname);
            int quizid = int.Parse(quizidString);

            using (SqlConnection connection = new SqlConnection(WebConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString))
            {
                connection.Open();

                SqlCommand command = new SqlCommand("SELECT Id, question, option1, option2, option3, option4, answer FROM Questions WHERE quiz_id = @QuizId", connection);
                command.Parameters.AddWithValue("@QuizId", quizid);

                SqlDataReader reader = command.ExecuteReader();

                if (!reader.HasRows)
                {
                    SubmitButton.Visible = false;
                    NoQuestionsPanel.Visible = true;
                    NoQuestionsMessage.Text = "No questions are uploaded for this quiz. Will be updated soon !";
                    return;
                }

                SubmitButton.Visible = true;
                NoQuestionsPanel.Visible = false;

                QuestionRepeater.DataSource = reader;
                QuestionRepeater.DataBind();
            }
        }


        protected string GetQuizIdFromTitle(string title)
        {
            using (SqlConnection connection = new SqlConnection(WebConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString))
            {
                connection.Open();

                SqlCommand command = new SqlCommand("SELECT Id FROM Quizzes WHERE quizname = @Quiztitle", connection);
                command.Parameters.AddWithValue("@Quiztitle", title);

                object result = command.ExecuteScalar();

                if (result != null)
                {
                    // Response.Write("Quiz ID found: " + result.ToString()); // For testing
                    return result.ToString();
                }
                else
                {
                    Response.Write("No quiz found with the title: " + title);
                    throw new Exception("No title match");
                }
            }
        }
        protected void QuestionRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                IDataRecord dataItem = (IDataRecord)e.Item.DataItem;

                Label questionLabel = (Label)e.Item.FindControl("QuestionLabel");
                RadioButtonList optionList = (RadioButtonList)e.Item.FindControl("OptionList");
                HiddenField correctAnswerField = (HiddenField)e.Item.FindControl("CorrectAnswer");

                questionLabel.Text = dataItem["question"].ToString();

                optionList.Items.Add(new ListItem(dataItem["option1"].ToString(), dataItem["option1"].ToString()));
                optionList.Items.Add(new ListItem(dataItem["option2"].ToString(), dataItem["option2"].ToString()));
                optionList.Items.Add(new ListItem(dataItem["option3"].ToString(), dataItem["option3"].ToString()));
                optionList.Items.Add(new ListItem(dataItem["option4"].ToString(), dataItem["option4"].ToString()));

                correctAnswerField.Value = dataItem["answer"].ToString();
            }
        }

        private List<string> GetOptionsForQuestion(string questionId)
        {
            List<string> options = new List<string>();

            using (SqlConnection connection = new SqlConnection(WebConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT option_text FROM Options WHERE question_id = @QuestionId", connection);
                command.Parameters.AddWithValue("@QuestionId", questionId);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        options.Add(reader["option_text"].ToString());
                    }
                }
            }

            return options;
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            int totalQuestions = QuestionRepeater.Items.Count;
            int correctAnswers = 0;

            foreach (RepeaterItem item in QuestionRepeater.Items)
            {
                RadioButtonList optionList = (RadioButtonList)item.FindControl("OptionList");
                HiddenField correctAnswerField = (HiddenField)item.FindControl("CorrectAnswer");

                string selectedValue = optionList.SelectedValue;
                string correctAnswer = correctAnswerField.Value;

                if (!string.IsNullOrEmpty(selectedValue) && selectedValue == correctAnswer)
                {
                    correctAnswers++;
                }
            }
            Session["quizId"] = GetQuizIdFromTitle(Request.QueryString["quizname"]);
            Session["score"] = correctAnswers;
            Response.Redirect($"result.aspx");
        }

    }
}