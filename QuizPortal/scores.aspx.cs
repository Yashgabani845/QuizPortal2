using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizPortal
{
    public partial class scores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] != null)
            {
                string username = Session["Username"].ToString();

                int userId = GetUserIdByUsername(username);

                if (userId != 0)
                {
                    DataTable scoresTable = GetQuizScoresByUserId(userId);

                    if (scoresTable.Rows.Count > 0)
                    {
                        QuizRepeater.DataSource = scoresTable;
                        QuizRepeater.DataBind();

                        quizTable.Visible = true;
                        noQuizPanel.Visible = false;
                    }
                    else
                    {
                        quizTable.Visible = false;
                        noQuizPanel.Visible = true;
                    }
                }
            }
            else
            {
                Response.Redirect("login.aspx");
            }
        }

        private int GetUserIdByUsername(string username)
        {
            int userID = 0;
            string connString = ConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT Id FROM Users WHERE username = @Username";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    conn.Open();
                    userID = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            return userID;
        }

        private DataTable GetQuizScoresByUserId(int userID)
        {
            DataTable dt = new DataTable();
            string connString = ConfigurationManager.ConnectionStrings["conQuizPortal"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT q.quizname, q.photo, s.score, s.date 
                                FROM Scores s
                                INNER JOIN Quizzes q ON s.quiz_id = q.Id
                                WHERE s.user_id = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }
            return dt;
        }
    }
}