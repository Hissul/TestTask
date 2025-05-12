<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebFormsProject._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Список книг</h2>

    <asp:HyperLink ID="hlAddBook" runat="server" NavigateUrl="BookForm.aspx" CssClass="btn btn-primary">
        + Добавить книгу
    </asp:HyperLink>

    <br /><br />

    <asp:GridView ID="gvBooks" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" 
    OnRowCommand="gvBooks_RowCommand">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Название" />
            <asp:BoundField DataField="Author" HeaderText="Автор" />
            <asp:BoundField DataField="YearPublished" HeaderText="Год издания" />
            <asp:BoundField DataField="Genre" HeaderText="Жанр" />
            <asp:HyperLinkField DataNavigateUrlFields="Id" DataNavigateUrlFormatString="BookDetails.aspx?id={0}" Text="Просмотр" />
            <asp:HyperLinkField DataNavigateUrlFields="Id" DataNavigateUrlFormatString="BookForm.aspx?id={0}" Text="Редактировать" />
            <asp:ButtonField CommandName="DeleteBook" Text="Удалить" ButtonType="Button" />

           <asp:TemplateField>
                <ItemTemplate>
                    <asp:Button ID="btnDelete" runat="server" Text="Удалить" 
                        CommandName="DeleteBook" CommandArgument='<%# Eval("Id") %>' 
                        CssClass="btn btn-danger" />
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
    </asp:GridView>
</asp:Content>