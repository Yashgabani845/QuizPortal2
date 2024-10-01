using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
using System.Text;
using System.Web.UI.WebControls;
using System.IO;

namespace QuizPortal
{
    public partial class admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] != null && Session["Role"] == "Admin")
            {
                wlcmsg.Text = "Welcome Admin : " + Session["Username"];
                if (!IsPostBack)
                {
                    LoadQuizzes();
                    PopulateQuizDropdown();
                }
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }

        private void LoadQuizzes()
        {
            string connString = ConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT Id, quizname FROM Quizzes", conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(reader);
                    QuizGrid.DataSource = dt;
                    QuizGrid.DataBind();
                }
            }
        }

        private void PopulateQuizDropdown()
        {
            string connString = ConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT Id, quizname FROM Quizzes", conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlQuizzes.DataSource = reader;
                    ddlQuizzes.DataTextField = "quizname";
                    ddlQuizzes.DataValueField = "Id";
                    ddlQuizzes.DataBind();
                }
            }
        }

        [WebMethod]
        public static string GetQuizQuestions(int quizId)
        {
            StringBuilder sb = new StringBuilder();
            string connString = ConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT question, option1, option2, option3, option4, answer FROM Questions WHERE quiz_id = @quizId", conn))
                {
                    cmd.Parameters.AddWithValue("@quizId", quizId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        sb.Append("<div class='question'>");
                        sb.Append($"<h5>{reader["question"]}</h5>");
                        sb.Append("<ul>");
                        sb.Append($"<li>1. {reader["option1"]}</li>");
                        sb.Append($"<li>2. {reader["option2"]}</li>");
                        sb.Append($"<li>3. {reader["option3"]}</li>");
                        sb.Append($"<li>4. {reader["option4"]}</li>");
                        sb.Append("</ul>");
                        sb.Append($"<p><strong>Correct Answer:</strong> {reader["answer"]}</p>");
                        sb.Append("</div>");
                    }
                }
            }
            return sb.ToString();
        }

        protected void btnCreateQuiz_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            string photoPath = null;
            string fileName = Path.GetFileName(filePhoto.FileName);

            if (filePhoto.HasFile)
            {
                photoPath = "/images/" + fileName;
                string serverPath = Server.MapPath("~/images/") + fileName;
                filePhoto.SaveAs(serverPath);
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "INSERT INTO Quizzes (quizname, description, photo) VALUES (@quizname, @description, @photo)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@quizname", txtQuizName.Text);
                    cmd.Parameters.AddWithValue("@description", txtDescription.Text);
                    cmd.Parameters.AddWithValue("@photo", fileName);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Refresh the quiz list and dropdown
            LoadQuizzes();
            PopulateQuizDropdown();
            ClearQuizForm();
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "INSERT INTO Questions (quiz_id, question, option1, option2, option3, option4, answer) VALUES (@quiz_id, @question, @option1, @option2, @option3, @option4, @answer)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@quiz_id", ddlQuizzes.SelectedValue);
                    cmd.Parameters.AddWithValue("@question", txtQuestion.Text);
                    cmd.Parameters.AddWithValue("@option1", txtOption1.Text);
                    cmd.Parameters.AddWithValue("@option2", txtOption2.Text);
                    cmd.Parameters.AddWithValue("@option3", txtOption3.Text);
                    cmd.Parameters.AddWithValue("@option4", txtOption4.Text);
                    cmd.Parameters.AddWithValue("@answer", txtAnswer.Text);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ClearQuestionForm();
        }

        private void ClearQuizForm()
        {
            txtQuizName.Text = string.Empty;
            txtDescription.Text = string.Empty;
        }

        private void ClearQuestionForm()
        {
            txtQuestion.Text = string.Empty;
            txtOption1.Text = string.Empty;
            txtOption2.Text = string.Empty;
            txtOption3.Text = string.Empty;
            txtOption4.Text = string.Empty;
            txtAnswer.Text = string.Empty;
        }
    }
}