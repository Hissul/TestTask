USE [master]
GO
/****** Object:  Database [HomeLibrary]    Script Date: 12.05.2025 12:06:18 ******/
CREATE DATABASE [HomeLibrary]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HomeLibrary', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\HomeLibrary.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HomeLibrary_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\HomeLibrary_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [HomeLibrary] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HomeLibrary].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HomeLibrary] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HomeLibrary] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HomeLibrary] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HomeLibrary] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HomeLibrary] SET ARITHABORT OFF 
GO
ALTER DATABASE [HomeLibrary] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [HomeLibrary] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HomeLibrary] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HomeLibrary] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HomeLibrary] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HomeLibrary] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HomeLibrary] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HomeLibrary] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HomeLibrary] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HomeLibrary] SET  ENABLE_BROKER 
GO
ALTER DATABASE [HomeLibrary] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HomeLibrary] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HomeLibrary] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HomeLibrary] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HomeLibrary] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HomeLibrary] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HomeLibrary] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HomeLibrary] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [HomeLibrary] SET  MULTI_USER 
GO
ALTER DATABASE [HomeLibrary] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HomeLibrary] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HomeLibrary] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HomeLibrary] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HomeLibrary] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [HomeLibrary] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [HomeLibrary] SET QUERY_STORE = ON
GO
ALTER DATABASE [HomeLibrary] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [HomeLibrary]
GO
/****** Object:  Table [dbo].[Books]    Script Date: 12.05.2025 12:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Books](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](255) NULL,
	[Author] [nvarchar](255) NULL,
	[YearPublished] [int] NULL,
	[Genre] [nvarchar](100) NULL,
	[TableOfContents] [xml] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[DeleteBook]    Script Date: 12.05.2025 12:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteBook]
	@Id int
as
	begin
		delete from Books where Id = @Id;
	end
GO
/****** Object:  StoredProcedure [dbo].[GetAllBooks]    Script Date: 12.05.2025 12:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetAllBooks]
as
	begin
		Select * from Books;
	end
GO
/****** Object:  StoredProcedure [dbo].[GetBookById]    Script Date: 12.05.2025 12:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetBookById]
	@Id Int
as
	begin
		select * from Books where Id = @Id;
	end
GO
/****** Object:  StoredProcedure [dbo].[GetChaptersFromXml]    Script Date: 12.05.2025 12:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetChaptersFromXml]
	@Id int
as
 begin
	select x.value('.', 'nvarchar(max)') as Chapter
	from Books
	cross apply TableOfContents.nodes('/root/h2') as T(x)
	where id = @Id
	end
GO
/****** Object:  StoredProcedure [dbo].[GetParagraphsFromXml]    Script Date: 12.05.2025 12:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetParagraphsFromXml]
	@Id int
as
	begin
		select x.value('.', 'nvarchar(max)') as Paragraph
		from Books
		cross apply TableOfContents.nodes('root/p') as T(x)
		where Id = @Id
	end
GO
/****** Object:  StoredProcedure [dbo].[InsertBook]    Script Date: 12.05.2025 12:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertBook]
    @Title NVARCHAR(255),
    @Author NVARCHAR(255),
    @YearPublished INT,
    @Genre NVARCHAR(100),    
    @TableOfContents XML
AS
BEGIN
    INSERT INTO Books (Title, Author, YearPublished, Genre, TableOfContents)
    VALUES (@Title, @Author, @YearPublished, @Genre, @TableOfContents);
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateBook]    Script Date: 12.05.2025 12:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateBook]
	@Id int,
	@Title NVARCHAR(255),
    @Author NVARCHAR(255),
    @YearPublished INT,
    @Genre NVARCHAR(100),    
    @TableOfContents XML
as 
	begin
		update Books 
		Set Title = @Title,
			Author = @Author,
			YearPublished = @YearPublished,
			Genre = @Genre,
			TableOfContents = @TableOfContents
		where Id = @Id;
	end
GO
USE [master]
GO
ALTER DATABASE [HomeLibrary] SET  READ_WRITE 
GO
