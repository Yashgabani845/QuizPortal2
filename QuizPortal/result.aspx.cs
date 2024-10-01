using System;
using System.Configuration;
using System.Data.SqlClient;

namespace QuizPortal
{
    public partial class result : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string score = Session["score"]?.ToString();
                string username = Session["Username"]?.ToString();
                string quizId = Session["quizId"]?.ToString();
                string total = "5";

                if (!string.IsNullOrEmpty(score) && !string.IsNullOrEmpty(username) && !string.IsNullOrEmpty(quizId))
                {
                    ScoreLabel.Text = $"You scored {score} out of {total}.";
                    int userId = GetUserIdByUsername(username);
                    if (userId > 0)
                    {
                        InsertScore(int.Parse(score), userId, int.Parse(quizId));
                    }
                    else
                    {
                        ScoreLabel.Text += " Unable to find the user.";
                    }
                }
                else
                {
                    ScoreLabel.Text = "There was an issue displaying your score.";
                }
            }
        }
        private int GetUserIdByUsername(string username)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            string query = "SELECT Id FROM Users WHERE username = @Username";
            int userId = 0;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Username", username);
                        object result = command.ExecuteScalar();
                        if (result != null)
                        {
                            userId = Convert.ToInt32(result);
                        }
                    }
                }
                catch (Exception ex)
                {
                    ScoreLabel.Text += $" Error retrieving user ID: {ex.Message}";
                }
            }

            return userId;
        }
        private void InsertScore(int score, int userId, int quizId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            string query = "INSERT INTO Scores (score, user_id, quiz_id) VALUES (@score, @userId, @quizId)";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@score", score);
                        command.Parameters.AddWithValue("@userId", userId);
                        command.Parameters.AddWithValue("@quizId", quizId);

                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ScoreLabel.Text += " Your score has been saved!";
                        }
                        else
                        {
                            ScoreLabel.Text += " There was an issue saving your score.";
                        }
                    }
                }
                catch (Exception ex)
                {
                    ScoreLabel.Text += $" Error: {ex.Message}";
                }
            }
        }
        protected void BackButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("home.aspx");
        }
    }
}
