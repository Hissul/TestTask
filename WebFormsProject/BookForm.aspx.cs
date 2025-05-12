using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebFormsProject {
    public partial class BookForm : System.Web.UI.Page {

        protected void Page_Load (object sender, EventArgs e) {
            if (!IsPostBack && Request.QueryString["id"] != null) {
                int id = int.Parse (Request.QueryString["id"]);
                var repo = new BookRepository ();
                var book = repo.GetBookById (id);
                if (book != null) {
                    txtTitle.Text = book.Title;
                    txtAuthor.Text = book.Author;
                    txtYear.Text = book.YearPublished.ToString ();
                    txtGenre.Text = book.Genre;                   
                    txtTableOfContents.Text = book.TableOfContents;
                }
            }
        }

        protected void btnSave_Click (object sender, EventArgs e) {
            var book = new Book {
                Title = txtTitle.Text,
                Author = txtAuthor.Text,
                YearPublished = int.Parse (txtYear.Text),
                Genre = txtGenre.Text,               
                TableOfContents = txtTableOfContents.Text
            };

            var repo = new BookRepository ();
            if (Request.QueryString["id"] != null) {
                book.Id = int.Parse (Request.QueryString["id"]);
                repo.UpdateBook(book); 
            }
            else {
                repo.InsertBook (book);
            }

            Response.Redirect ("Default.aspx");
        }

    }
}