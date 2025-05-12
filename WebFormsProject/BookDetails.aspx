<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookDetails.aspx.cs" Inherits="WebFormsProject.BookDetails"  ValidateRequest="false" %>



<!DOCTYPE html>
<html>

<body>
    <form id="form1" runat="server">
        <div>
           <asp:Label ID="lblError" runat="server" ForeColor="Red" />
           <h2><asp:Label ID="lblTitle" runat="server" /></h2>
           <p><b>Автор:</b> <asp:Label ID="lblAuthor" runat="server" /></p>
           <p><b>Год публикации:</b> <asp:Label ID="lblYear" runat="server" /></p>
           <p><b>Жанр:</b> <asp:Label ID="lblGenre" runat="server" /></p>
           <hr />
           <h3>Оглавление:</h3>
            <asp:Literal ID="litTableOfContents" runat="server" Mode="PassThrough" />
        </div>
    </form>
</body>
</html>
