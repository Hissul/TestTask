using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace WebFormsProject {
    public class BookRepository {

        private readonly string _connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        public List<Book> GetAllBooks () {
           
            List<Book> books = new List<Book> ();

            using (SqlConnection conn = new SqlConnection (_connStr))
            using (SqlCommand cmd = new SqlCommand ("GetAllBooks", conn) { CommandType = CommandType.StoredProcedure }) {

                conn.Open ();

                using (SqlDataReader reader = cmd.ExecuteReader ())

                while (reader.Read ()) {
                    books.Add (new Book {
                        Id = reader.GetInt32 (0),
                        Title = reader.GetString (1),
                        Author = reader.GetString (2),
                        YearPublished = reader.GetInt32 (3),
                        Genre = reader.GetString (4),
                        TableOfContents = reader.IsDBNull (5) ? "" : reader.GetString (5)
                    });
                }
            }
            return books;
        }

        public Book GetBookById (int id) {
            Book book = null;
            using (var conn = new SqlConnection (_connStr))
            using (var cmd = new SqlCommand ("GetBookById", conn) { CommandType = CommandType.StoredProcedure }) {
                cmd.Parameters.AddWithValue ("@Id", id);
                conn.Open ();
                using (var reader = cmd.ExecuteReader ())
                if (reader.Read ()) {
                    book = new Book {
                        Id = reader.GetInt32 (0),
                        Title = reader.GetString (1),
                        Author = reader.GetString (2),
                        YearPublished = reader.GetInt32 (3),
                        Genre = reader.GetString (4),                        
                        TableOfContents = reader.IsDBNull (5) ? "" : reader.GetString (5)
                    };
                }
            }
            return book;
        }

        public void InsertBook (Book book) {
            using (var conn = new SqlConnection (_connStr))
            using (var cmd = new SqlCommand ("InsertBook", conn) { CommandType = CommandType.StoredProcedure }) {
                cmd.Parameters.AddWithValue ("@Title", book.Title);
                cmd.Parameters.AddWithValue ("@Author", book.Author);
                cmd.Parameters.AddWithValue ("@YearPublished", book.YearPublished);
                cmd.Parameters.AddWithValue ("@Genre", book.Genre);

                object tocXml;
                if (string.IsNullOrWhiteSpace (book.TableOfContents)) {
                    tocXml = DBNull.Value;
                }
                else {
                    string safeHtml = System.Security.SecurityElement.Escape (book.TableOfContents);
                    tocXml = $"<root>{safeHtml}</root>";
                }

                cmd.Parameters.Add ("@TableOfContents", SqlDbType.Xml).Value = tocXml;

                conn.Open ();
                cmd.ExecuteNonQuery ();
            }
        }


        public void UpdateBook (Book book) {
            using (var conn = new SqlConnection (_connStr))
            using (var cmd = new SqlCommand ("UpdateBook", conn) { CommandType = CommandType.StoredProcedure }) {
                cmd.Parameters.AddWithValue ("@Id", book.Id);
                cmd.Parameters.AddWithValue ("@Title", book.Title);
                cmd.Parameters.AddWithValue ("@Author", book.Author);
                cmd.Parameters.AddWithValue ("@YearPublished", book.YearPublished);
                cmd.Parameters.AddWithValue ("@Genre", book.Genre);

                object tocXml;
                if (string.IsNullOrWhiteSpace (book.TableOfContents)) {
                    tocXml = DBNull.Value;
                }
                else {
                    string safeHtml = System.Security.SecurityElement.Escape (book.TableOfContents);
                    tocXml = $"<root>{safeHtml}</root>";
                }

                cmd.Parameters.Add ("@TableOfContents", SqlDbType.Xml).Value = tocXml;

                conn.Open ();
                cmd.ExecuteNonQuery ();
            }
        }


        public void DeleteBook (int id) {
            using (var conn = new SqlConnection (_connStr))
            using (var cmd = new SqlCommand ("DeleteBook", conn) { CommandType = CommandType.StoredProcedure }) {
                cmd.Parameters.AddWithValue ("@Id", id);
                conn.Open ();
                cmd.ExecuteNonQuery ();
            }
        }


    }
}