using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.Data.SqlClient;
using MvcProject.Models;
using System.Data;
using static System.Reflection.Metadata.BlobBuilder;

namespace MvcProject.Controllers;
public class BookController : Controller {

    private readonly string _connectionString;


    public BookController (IConfiguration configuration) {
        _connectionString = configuration.GetConnectionString ("LibraryDb")!;
    }


    public async Task<IActionResult> Index () {

        List<Book> books = new ();

        await using SqlConnection conn = new SqlConnection (_connectionString);
        await using SqlCommand cmd = new SqlCommand ("GetAllBooks", conn) { 
            CommandType = CommandType.StoredProcedure
        };

        await conn.OpenAsync ();

        await using SqlDataReader reader = await cmd.ExecuteReaderAsync ();

        while (await reader.ReadAsync ()) {

            books.Add (new Book { 
                Id = reader.GetInt32 (0),
                Title = reader.GetString (1),
                Author = reader.GetString (2),
                YearPublished = reader.GetInt32 (3),
                Genre = reader.GetString (4),
                TableOfContents = reader.IsDBNull (5) ? "" : reader.GetString (5)
            });
        }

        return View (books);
    }


    public IActionResult Create () => View ("./Views/Book/Create.cshtml");


    [HttpPost]
    public async Task<IActionResult> Create (Book book) {

        await using SqlConnection conn = new SqlConnection (_connectionString);
        await using var cmd = new SqlCommand ("InsertBook", conn) {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue ("@Title", book.Title);
        cmd.Parameters.AddWithValue ("@Author", book.Author);
        cmd.Parameters.AddWithValue ("@YearPublished", book.YearPublished);
        cmd.Parameters.AddWithValue ("@Genre", book.Genre);

        string toc = $"<root>{book.TableOfContents}</root>";

        cmd.Parameters.Add ("@TableOfContents", SqlDbType.Xml).Value =
        string.IsNullOrWhiteSpace (book.TableOfContents) ? DBNull.Value : book.TableOfContents;

        conn.Open ();
        cmd.ExecuteNonQuery ();

        return RedirectToAction (nameof(Index)); 
    }


    public async Task<IActionResult> Edit (int id) {

        Book? book = null;

        await using SqlConnection conn = new SqlConnection (_connectionString);
        await using SqlCommand cmd = new SqlCommand ("GetBookById", conn) {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue("@Id", id);

        await conn.OpenAsync ();

        await using var reader = await cmd.ExecuteReaderAsync ();

        if(await reader.ReadAsync ()) {
            book = new Book {
                Id = reader.GetInt32 (0),
                Title = reader.GetString (1),
                Author = reader.GetString (2),
                YearPublished = reader.GetInt32(3),
                Genre = reader.GetString (4),
                TableOfContents = reader.IsDBNull (5) ? "" : reader.GetString (5)
            };
        }

        if(book == null) return NotFound ();

        return View (book);
    }


    [HttpPost]
    public async Task<IActionResult> Edit (Book book) {

        await using SqlConnection conn = new SqlConnection (_connectionString);
        await using SqlCommand cmd = new SqlCommand ("UpdateBook", conn) { 
            CommandType = CommandType.StoredProcedure 
        };

        cmd.Parameters.AddWithValue ("@Id", book.Id);
        cmd.Parameters.AddWithValue ("@Title", book.Title);
        cmd.Parameters.AddWithValue ("@Author", book.Author);
        cmd.Parameters.AddWithValue ("@YearPublished", book.YearPublished);
        cmd.Parameters.AddWithValue ("@Genre", book.Genre);
        cmd.Parameters.AddWithValue ("@TableOfContents", book.TableOfContents);


        await conn.OpenAsync ();
        await cmd.ExecuteNonQueryAsync();

        return RedirectToAction (nameof (Index));
    }


    public async Task<IActionResult> Delete (int id) {

        await using SqlConnection conn = new SqlConnection (_connectionString);
        await using SqlCommand cmd = new SqlCommand ("DeleteBook", conn) {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue ("@Id", id);

        await conn.OpenAsync ();
        await cmd.ExecuteNonQueryAsync ();

        return RedirectToAction (nameof (Index));
    }


    public async Task<IActionResult> Details (int id) {

        Book? book = null;

        await using SqlConnection conn = new SqlConnection (_connectionString);
        await using SqlCommand cmd = new SqlCommand ("GetBookById", conn) {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.AddWithValue ("@Id", id);

        await conn.OpenAsync ();

        await using var reader = await cmd.ExecuteReaderAsync ();

        if(await reader.ReadAsync ()) {
            book = new Book {
                Id = reader.GetInt32 ("id"),
                Title = reader.GetString ("title"),
                Author = reader.GetString (2),
                YearPublished = reader.GetInt32 (3),
                Genre = reader.GetString (4),
                TableOfContents = reader.IsDBNull (5) ? "" : reader.GetString (5)
            };
        }

        if (book == null) return NotFound ();
        return View (book);
    }


}
