using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizPortal
{
    public partial class home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuizzes();
            }
        }
        private void LoadQuizzes()
        {
            string connectionString = WebConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Id, quizname, description, photo FROM Quizzes";
                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataReader reader = cmd.ExecuteReader();

                QuizRepeater.DataSource = reader;
                QuizRepeater.DataBind();
            }
        }

        protected void StartQuiz_btnClick(object sender, EventArgs e)
        {
            string quizName = hfQuizName.Value;

            try
            {
                Response.Redirect($"quiz.aspx?quizname={quizName}");
            }
            catch (Exception ex)
            {
                Response.Write("Error: " + ex.Message);
            }
        }
    }
}