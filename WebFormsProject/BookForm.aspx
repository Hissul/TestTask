<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookForm.aspx.cs" Inherits="WebFormsProject.BookForm" ValidateRequest="false" %>

<%--<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BookForm.aspx.cs" Inherits="BookForm" %>--%>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Форма книги</title>
    <!-- Подключаем CKEditor через CDN -->
    <script src="https://cdn.ckeditor.com/ckeditor5/35.2.0/classic/ckeditor.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <label>Название:</label>
            <asp:TextBox ID="txtTitle" runat="server" />
        </div>
        <div>
            <label>Автор:</label>
            <asp:TextBox ID="txtAuthor" runat="server" />
        </div>
        <div>
            <label>Год издания:</label>
            <asp:TextBox ID="txtYear" runat="server" />
        </div>
        <div>
            <label>Жанр:</label>
            <asp:TextBox ID="txtGenre" runat="server" />
        </div>
        <div>
            <label>Оглавление:</label>
            <asp:TextBox ID="txtTableOfContents" runat="server" TextMode="MultiLine" Rows="10" />
            <script type="text/javascript">
                // Инициализация CKEditor после загрузки скрипта
                ClassicEditor.create(document.querySelector('#<%= txtTableOfContents.ClientID %>'))
                    .catch(error => {
                        console.error(error);
                    });
            </script>
        </div>
        <asp:Button ID="btnSave" runat="server" Text="Сохранить" OnClick="btnSave_Click" />
    </form>
</body>
</html>