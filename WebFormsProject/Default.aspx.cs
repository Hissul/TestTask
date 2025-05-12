using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebFormsProject {
    
    public partial class _Default : Page {

        protected void Page_Load (object sender, EventArgs e) {
            if (!IsPostBack) {
                LoadBooks ();
            }
        }

        private void LoadBooks () {
            var repo = new BookRepository ();
            gvBooks.DataSource = repo.GetAllBooks ();
            gvBooks.DataBind ();
        }

        protected void gvBooks_RowCommand (object sender, GridViewCommandEventArgs e) {
            if (e.CommandName == "DeleteBook") {
                int bookId = Convert.ToInt32 (e.CommandArgument);
                var repo = new BookRepository ();
                repo.DeleteBook (bookId);
                Response.Redirect ("Default.aspx"); // обновляем страницу после удаления
            }
        }


    }
}