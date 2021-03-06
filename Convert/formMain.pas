unit formMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, DB, DBTables, ExtCtrls, Menus;

type
  TfrmMain = class(TForm)
    Memo1: TMemo;
    Table1: TTable;
    DataSource1: TDataSource;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Convert1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Splitter1: TSplitter;
    Panel1: TPanel;
    DirectoryListBox1: TDirectoryListBox;
    Label1: TLabel;
    FileListBox1: TFileListBox;
    Splitter2: TSplitter;
    SaveDialog: TSaveDialog;
    procedure Convert1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Convert1Click(Sender: TObject);
var
        i, j:   integer;
        pkey:   boolean;
        temp:   string;
begin
        memo1.Clear;
        for i := 0 to FileListBox1.Items.Count-1 do begin
               // memo1.text := memo1.text + FileListBox1.Items.Strings[i]+#13#10;
               try
                table1.active := false;
                table1.TableName:=FileListBox1.Items.Strings[i];
                table1.active := true;

                temp := table1.tablename;
                temp[length(temp)]:= ' ';
                temp[length(temp)-1]:= ' ';
                temp[length(temp)-2]:= ' ';
                memo1.text := memo1.text + 'DROP TABLE IF EXISTS ' + temp  + '; '#13#10;
                memo1.text := memo1.text + 'CREATE TABLE ' + temp  + '  ('#13#10;

                //memo1.text := memo1.text + IntToStr(table1.Fields.Count) + '  '#13#10;
//                memo1.text := memo1.text + IntToStr(table1.KeyFieldCount);
                for j := 0 to table1.Fields.Count-1 do begin
                        memo1.text := memo1.text + ' ';
                        memo1.text := memo1.text + table1.Fields.Fields[j].FieldName;
                        case table1.Fields.Fields[j].DataType of
                                ftString: begin
                                        memo1.text := memo1.text + '  VARCHAR(' +
                                        IntToStr(table1.Fields.Fields[j].DataSize-1) + ') ';
                                end;
                                ftGraphic: begin
                                    memo1.text := memo1.text + ' BLOB  ';
                                end;
                                ftInteger: begin
                                        memo1.text := memo1.text + ' INTEGER  '
                                end;
                                ftDateTime: begin
                                        memo1.text := memo1.text + ' DATETIME  '
                                end;
                                ftDate: begin
                                        memo1.text := memo1.text + ' DATE  '
                                end;
                                ftTime: begin
                                        memo1.text := memo1.text + ' TIME '
                                end;
                                ftBoolean: begin
                                        memo1.text := memo1.text + ' BOOL '
                                end;
                                ftFloat: begin
                                        memo1.text := memo1.text + ' FLOAT  '
                                end;
                                ftCurrency: begin
                                        memo1.text := memo1.text + ' DECIMAL(10,2)   '
                                end;
                                ftMemo: begin
                                        memo1.text := memo1.text + ' TINYTEXT  '
                                end;
                                ftSmallInt: begin
                                        memo1.text := memo1.text + ' SMALLINT  '
                                end;
                                ftAutoInc: begin
                                        memo1.text := memo1.text + ' INTEGER UNSIGNED AUTO_INCREMENT  '
                                end;
                                ftBytes: begin
                                        memo1.text := memo1.text + ' VARCHAR default NULL '
                                end;
                                else begin
                                        memo1.text := memo1.text + ' type_desconhecido '
                                end;
                        end;
                        if ((table1.Fields.Fields[j].IsIndexField) or (table1.Fields.Fields[j].required)) then
                                memo1.text := memo1.text + ' NOT NULL ';
                        if (j<>table1.Fields.Count-1) then
                                memo1.text := memo1.text + ', ';
                        memo1.text := memo1.text + '  '#13#10;
                end;
                pkey := false;
                for j := 0 to table1.Fields.Count-1 do begin
                        if (table1.Fields.Fields[j].IsIndexField) then begin
                                if (not pkey) then
                                        memo1.text := memo1.text + ', PRIMARY KEY ('
                                else
                                        memo1.text := memo1.text + ', ';
                                memo1.text := memo1.text + table1.Fields.Fields[j].fieldname;

                                pkey := true;
                        end;
                end;
                if (pkey) then
                        memo1.text := memo1.text + ' ) '#13#10;

                memo1.text := memo1.Text + ');'#13#10#13#10;
               except

               end;
        end;
end;
procedure TfrmMain.Save1Click(Sender: TObject);
begin
        if not SaveDialog.Execute then exit;
        memo1.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
        close;
end;

end.

