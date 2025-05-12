using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebFormsProject {

    public partial class BookDetails : System.Web.UI.Page {


        protected void Page_Load (object sender, EventArgs e) {
            if (!IsPostBack && Request.QueryString["id"] != null) {
                int id;
                if (int.TryParse (Request.QueryString["id"], out id)) {
                    var repo = new BookRepository ();
                    var book = repo.GetBookById (id);
                    if (book != null) {
                        lblTitle.Text = book.Title;
                        lblAuthor.Text = book.Author;
                        lblYear.Text = book.YearPublished.ToString ();
                        lblGenre.Text = book.Genre;
                        litTableOfContents.Text = book.TableOfContents;
                    }
                    else {
                        lblError.Text = "Книга не найдена.";
                    }
                }
                else {
                    lblError.Text = "Некорректный ID.";
                }
            }
        }

    }
}