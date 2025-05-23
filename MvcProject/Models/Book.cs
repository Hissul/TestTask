﻿namespace MvcProject.Models;

public class Book {
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Author { get; set; } = string.Empty;
    public int YearPublished { get; set; }
    public string Genre { get; set; } = string.Empty;    
    public string TableOfContents { get; set; } = string.Empty; 
}
