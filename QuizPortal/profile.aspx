<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="profile.aspx.cs" Inherits="QuizPortal.profile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Profile</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
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

        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
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
                    <li class="nav-item">
                        <a class="nav-link" href="scores.aspx">
                            <i class="fas fa-trophy"></i> Scores
                        </a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="profile.aspx">
                            <i class="fas fa-user"></i> Profile
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <div class="container mt-4">
            <h2><i class="fas fa-user"></i> Profile </h2>
            <div id="alertMessage" runat="server" class="alert alert-warning alert-dismissible fade show" style="display: none;" role="alert">
                <span id="alertContent" runat="server"></span>
            </div>

            <asp:Button ID="btnMakeProfile" runat="server" Text="Make Profile" CssClass="btn btn-primary" OnClick="btnMakeProfile_Click" Visible="false" />

            <div class="row" id="profileInfo" runat="server">
                <div class="col-md-8">
                    <p><b>Username:</b> <asp:Label ID="lblUsername" runat="server"></asp:Label></p>
                    <p><b>Name:</b> <asp:Label ID="lblName" runat="server"></asp:Label></p>
                    <p><b>Mobile No:</b> <asp:Label ID="lblMobileNo" runat="server"></asp:Label></p>
                    <p><b>Date of Birth:</b> <asp:Label ID="lblDOB" runat="server"></asp:Label></p>

                    <div class="mt-4">
                        <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-warning" OnClick="btnUpdateProfile" />
                        <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="btn btn-primary" OnClick="btnUpdatePassword_Click" />
                        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for creating profile -->
        <div class="modal fade" id="profileModal" tabindex="-1" aria-labelledby="profileModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="profileModalLabel">Complete Your Profile</h5>
              </div>
              <div class="modal-body">
                <asp:Label ID="modalNameLabel" runat="server" Text="Username" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtModalName" runat="server" CssClass="form-control" ReadOnly="True"></asp:TextBox>
        
                <asp:Label ID="modalMobileLabel" runat="server" Text="Mobile No" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtModalMobileNo" runat="server" CssClass="form-control"></asp:TextBox>
        
                <asp:Label ID="modalDOBLabel" runat="server" Text="Date of Birth" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtModalDOB" runat="server" CssClass="form-control" placeholder="yyyy-mm-dd"></asp:TextBox>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <asp:Button ID="btnSubmitProfile" runat="server" CssClass="btn btn-primary" Text="Submit" OnClick="btnSubmitProfile_Click" />
              </div>
            </div>
          </div>
        </div>

        <!-- Modal for Change Password -->
        <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="changePasswordModalLabel">Change Password</h5>
              </div>
              <div class="modal-body">
                <asp:Label ID="modalUserNameLabel" runat="server" Text="Username" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtModalUserName" runat="server" CssClass="form-control" ReadOnly="True"></asp:TextBox>

                <asp:Label ID="modalOldPassword" runat="server" Text="Old Password" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtOldPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>

                <asp:Label ID="modalNewPassword" runat="server" Text="New Password" CssClass="form-label"></asp:Label>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <asp:Button ID="btnSubmitPassword" runat="server" CssClass="btn btn-primary" Text="Submit" OnClick="btnSubmitPassword_Click" />
              </div>
            </div>
          </div>
        </div>

    </form>

</body>
</html>
