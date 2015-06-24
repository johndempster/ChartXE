unit NewDir;
// -----------------------------
// Change data storage directory
// -----------------------------
// 8/2/01

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Outline, DirOutln, global, FileCtrl ;

type
  TNewDirFrm = class(TForm)
    bOK: TButton;
    GroupBox1: TGroupBox;
    DriveComboBox: TDriveComboBox;
    DirectoryOutline: TDirectoryOutline;
    bCancel: TButton;
    procedure bOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DriveComboBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewDirFrm: TNewDirFrm;

implementation

{$R *.DFM}

procedure TNewDirFrm.bOKClick(Sender: TObject);
begin
     Settings.DataDirectory := DirectoryOutline.Directory ;
     end;

procedure TNewDirFrm.FormShow(Sender: TObject);
begin
     DriveComboBox.Drive := ExtractFileDrive(Settings.DataDirectory)[1] ;
     DirectoryOutline.Drive := DriveComboBox.Drive ;
     DirectoryOutline.Directory := ExtractFileDir(Settings.DataDirectory) ;
     end;

procedure TNewDirFrm.DriveComboBoxChange(Sender: TObject);
begin
     if (UpperCase(DriveComboBox.Drive) = 'A')
        or (UpperCase(DriveComboBox.Drive) = 'B')
        or (UpperCase(DriveComboBox.Drive) = 'U')
        or (UpperCase(DriveComboBox.Drive) = 'H') then begin
        MessageDlg('Saving to Floppy or Server disks not allowed!',mtWarning, [mbOK], 0 ) ;
         DriveComboBox.Drive := DirectoryOutline.Drive ;
        end
     else DirectoryOutline.Drive := DriveComboBox.Drive ;
     end ;


end.
