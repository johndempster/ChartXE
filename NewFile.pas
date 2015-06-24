unit NewFile;
{ ============================================
  NewFileFrm - Create a new CHART data file
  20/9/00
  ============================================ }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl;

type
  TNewFileFrm = class(TForm)
    bOK: TButton;
    GroupBox1: TGroupBox;
    DriveComboBox: TDriveComboBox;
    DirectoryListBox: TDirectoryListBox;
    GroupBox2: TGroupBox;
    edPrefix: TEdit;
    Label1: TLabel;
    ckIncludeDate: TCheckBox;
    EdFileName: TEdit;
    bCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure DriveComboBoxChange(Sender: TObject);
    procedure edPrefixChange(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure ckIncludeDateClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateFileIndex  ;
    procedure UpdateFileName ;
  public
    { Public declarations }
  end;

var
  NewFileFrm: TNewFileFrm;

implementation

uses global ;

var
   FileIndex : string ;
   DateString : string ;
   DriveLetter : Char ;

{$R *.DFM}

procedure TNewFileFrm.FormShow(Sender: TObject);
{ ---------------------------------------
  Initialise lists when form is displayed
  --------------------------------------- }
var
   s : string ;
begin
     { Get currently selected data storage disc drive }
     s := ExtractFileDrive(Settings.DataDirectory) ;

     { Check if a drive letter exists }
     if s = '' then begin
        MessageDlg('ERROR! No data directory. Changing to C:\',
                    mtWarning, [mbOK], 0 ) ;
        s := 'c:\' ;
        end ;

     { Prevent use of floppy drives }
     DriveLetter := char(s[1]) ;
     if (UpperCase(DriveLetter) = 'A') or (UpperCase(DriveLetter) = 'B') then begin
        MessageDlg('Saving to Floppy disc not allowed! Changing to C:\',
                    mtWarning, [mbOK], 0 ) ;
        DriveLetter := 'c' ;
        Settings.DataDirectory := 'c:\' ;
        end ;

     { Update drive and directory list boxes }
     DriveComboBox.Drive := DriveLetter ;
     DirectoryListBox.Drive := DriveComboBox.Drive ;
     DirectoryListBox.Directory := ExtractFileDir(Settings.DataDirectory) ;

     { User entered prefix to data file names }
     edPrefix.Text := Settings.DataFilePrefix ;
     ckIncludeDate.Checked := Settings.DataFileIncludeDate ;

     { Construct new data file name }
     UpdateFileIndex ;
     UpdateFileName ;

     end;

procedure TNewFileFrm.bOKClick(Sender: TObject);
{ -------------------------------------
  Create new (empty) data file and exit
  ------------------------------------- }
begin
     Settings.DataDirectory := DirectoryListBox.Directory + '\' ;

     fH.FileName := Settings.DataDirectory + edFileName.text ;
     fH.FileHandle := FileCreate(fH.FileName) ;
     if fH.FileHandle < 0 then begin
        MessageDlg('Unable to open new data file!',mtWarning, [mbOK], 0 ) ;
        end ;

    { User entered prefix to data file names }
     Settings.DataFilePrefix := edPrefix.Text ;
     Settings.DataFileIncludeDate := ckIncludeDate.Checked ;

     end;

procedure TNewFileFrm.DriveComboBoxChange(Sender: TObject);
begin
     if (UpperCase(DriveComboBox.Drive) = 'A')
        or (UpperCase(DriveComboBox.Drive) = 'B') then begin
        MessageDlg('Saving to Floppy disc not allowed!',mtWarning, [mbOK], 0 ) ;
        DriveComboBox.Drive := DriveLetter ;
        end ;

     DriveLetter := DriveComboBox.Drive ;
     DirectoryListBox.Drive := DriveLetter ;
     UpdateFileIndex ;
     UpdateFileName ;

     end;


procedure TNewFileFrm.UpdateFileIndex ;
{ -----------------------------------------------------------------------------
  Find next free index number <NNN> for file name of form <FilePrefix>-<NNN><.CHT>
  ----------------------------------------------------------------------------- }
Const
     MaxCounter = 999 ;
var
   Counter,i : Integer ;
   Done : Boolean ;
   FileName,NumString : string ;
begin

     if ckIncludeDate.Checked then DateString := FormatDateTime('-dd-mm-yy',Date())
                              else DateString := '' ;

     Counter := 1 ;
     Done := False ;
     while not Done do begin
           NumString := format('-%3d',[Counter]) ;
           for i := 1 to Length(NumString) do
               if NumString[i] = ' ' then NumString[i] := '0' ;
           FileName := DirectoryListBox.Directory + '\'
                       + edPrefix.text + DateString + NumString + '.cht' ;
           if FileExists(FileName) then Inc(Counter)
                                   else Done := True ;
           if Counter >= MaxCounter then Done := True ;
           end ;
     FileIndex := NumString ;
     end ;


procedure TNewFileFrm.edPrefixChange(Sender: TObject);
{ ------------------------------------
  Update file name when prefix changes
  ------------------------------------ }
begin
     UpdateFileIndex ;
     UpdateFileName ;
     end;


procedure TNewFileFrm.bCancelClick(Sender: TObject);
{ -----------------------
  Cancel creation of file
  ----------------------- }
begin
     fH.FileHandle := -1 ;
     end;


procedure TNewFileFrm.UpdateFileName ;
{ -------------------------------------------------
  Construct new data file name from component parts
  ------------------------------------------------- }
begin
     edFileName.text := edPrefix.text + DateString + FileIndex + '.cht' ;
     end ;


procedure TNewFileFrm.ckIncludeDateClick(Sender: TObject);
{ ---------------------------------------------
  Enable/Disable inclusion of date in file name
  --------------------------------------------- }
begin

     UpdateFileIndex ;
     UpdateFileName ;
     end;

end.
