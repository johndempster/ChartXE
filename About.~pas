unit About;
{ ====================================================
  About CHART Information box (c) J. Dempster 1996-2005
  ====================================================}

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, shared;

type
  TAboutDlg = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Copyright: TLabel;
    Panel2: TPanel;
    ShowLabInterfaceInfo: TEdit;
    bOK: TButton;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutDlg: TAboutDlg;

implementation

uses main  ;

{$R *.DFM}

procedure TAboutDlg.FormActivate(Sender: TObject);
begin
     if Mainfrm.SESLabIO.LabInterfaceAvailable then begin
        ShowLabInterfaceInfo.text := Mainfrm.SESLabIO.LabInterfaceName + ' '
                                     + Mainfrm.SESLabIO.LabInterfaceModel ;
        end
     else ShowLabInterfaceInfo.text := 'Interface not available' ;
     ProductName.Caption := Mainfrm.ProgName ;
     end;

end.

