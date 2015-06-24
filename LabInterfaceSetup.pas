unit LabInterfaceSetup;
// -------------------------------------
// Laboratory Interface Setup Dialog Box
// -------------------------------------
// 15.06.11 New form for laboratory interface setup only
//          (previously handled in setupdlg form)
// 20.09.11 A/D voltage range index now acquired from and written back to Settings.ADCVoltageRangeIndex
//          (Fixes bug in V4.3.4 where range was reset to +/-10V when seal test opened)
// 30.09.11 A/D voltage range setting is now preserved when device # is changed
// 14.10.11 Device list now only contains list of available devices
// 17.01.11 Hourglass now indicates when interface is being changed
//          Interface information box now updated when A/D input mode changed

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, global, math, seslabio ;

type
  TLabInterfaceSetupFrm = class(TForm)
    cbLabInterface: TComboBox;
    NIPanel: TPanel;
    Label3: TLabel;
    Label13: TLabel;
    cbADCInputMode: TComboBox;
    cbDeviceNumber: TComboBox;
    Panel1: TPanel;
    edModel: TEdit;
    bOK: TButton;
    bCancel: TButton;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure cbLabInterfaceChange(Sender: TObject);
    procedure cbDeviceNumberChange(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure cbADCInputModeChange(Sender: TObject);
  private
    { Private declarations }
    procedure FillOptionsLists ;
  public
    { Public declarations }
  end;

var
  LabInterfaceSetupFrm: TLabInterfaceSetupFrm;

implementation

uses Main;//, AmpModule;

{$R *.dfm}

procedure TLabInterfaceSetupFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
begin
     ClientWidth := cbLabInterface.Left + cbLabInterface.Width + 5 ;
     ClientHeight := bOK.Top + bOK.Height + 5 ;
     
     { Stop laboratory interface activity }
     if MainFrm.SESLabIO.ADCActive then MainFrm.SESLabIO.ADCStop ;
     if MainFrm.SESLabIO.DACActive then MainFrm.SESLabIO.DACStop ;

     //MainFrm.SESLabIO.LabInterfaceType := MainFrm.LabInterfaceType ;
     //MainFrm.SESLabIO.DeviceNumber := MainFrm.DeviceNum ;
     //MainFrm.SESLabIO.ADCInputMode := MainFrm.ADCInputMode ;

     FillOptionsLists ;

     end;

procedure TLabInterfaceSetupFrm.bOKClick(Sender: TObject);
begin

    Screen.Cursor := crHourGlass ;

    // A/D channel input mode
//    MainFrm.LabInterfaceType := MainFrm.SESLabIO.LabInterfaceType ;
//    MainFrm.DeviceNum := MainFrm.SESLabIO.DeviceNumber ;
//    MainFrm.ADCInputMode := MainFrm.SESLabIO.ADCInputMode ;

    Close ;

    end;


procedure TLabInterfaceSetupFrm.FillOptionsLists ;
// -----------------------------------
// Re-open lab. interface after change
// -----------------------------------
var
   i,iKeep : Integer ;
begin

     // Interface types
     MainFrm.SESLABIO.GetLabInterfaceTypes( cbLabInterface.Items ) ;
     cbLabInterface.ItemIndex := cbLabInterface.Items.IndexofObject(TObject(MainFrm.LabInterfaceType)) ;

     // A/D channel input mode
     MainFrm.SESLABIO.GetADCInputModes( cbADCInputMode.Items ) ;
     cbADCInputMode.ItemIndex := Min(MainFrm.ADCInputMode,cbADCInputMode.Items.Count-1) ;

     // Device list
     MainFrm.SESLABIO.GetDeviceList( cbDeviceNumber.Items ) ;
     cbDeviceNumber.ItemIndex := Min(MainFrm.DeviceNum-1,cbADCInputMode.Items.Count-1) ;

     if cbADCInputMode.Items.Count > 1 then NIPanel.Visible := True
                                       else NIPanel.Visible := False ;

     if NIPanel.Visible then Panel1.top := NIPanel.Top + NIPanel.Height + 5
                        else Panel1.top := NIPanel.Top ;
     //ClientWidth := Panel1.Left + Panel1.Width ;
     ClientHeight := Panel1.Top + Panel1.Height + 2 ;

    // Initialise channel display settings to minimum magnification
    MainFrm.mnZoomOutAll.Click ;

     edModel.Text := MainFrm.SESLabIO.LabInterfaceModel ;

     end;


procedure TLabInterfaceSetupFrm.cbLabInterfaceChange(Sender: TObject);
// ----------------------
// Lab. interface changed
// ----------------------
begin
     Screen.Cursor := crHourGlass ;
     MainFrm.SESLabIO.LabInterfaceType := Integer(cbLabInterface.Items.Objects[cbLabInterface.ItemIndex]);
     MainFrm.LabInterfaceType := MainFrm.SESLabIO.LabInterfaceType ;
     FillOptionsLists ;
     Screen.Cursor := crDefault ;
     end;


procedure TLabInterfaceSetupFrm.cbDeviceNumberChange(Sender: TObject);
// ----------------------
// Device # changed
// ----------------------
begin
     Screen.Cursor := crHourGlass ;
     MainFrm.SESLabIO.DeviceNumber := cbDeviceNumber.ItemIndex + 1 ;
     MainFrm.DeviceNum := MainFrm.SESLabIO.DeviceNumber ;
     FillOptionsLists ;
     Screen.Cursor := crDefault ;
     end;

procedure TLabInterfaceSetupFrm.bCancelClick(Sender: TObject);
begin
     Close ;
     end;

procedure TLabInterfaceSetupFrm.cbADCInputModeChange(Sender: TObject);
// ----------------------
// A/D input mode changed
// ----------------------
begin
     Screen.Cursor := crHourGlass ;
     MainFrm.SESLABIO.ADCInputMode := cbADCInputMode.ItemIndex ;
     MainFrm.ADCInputMode := cbADCInputMode.ItemIndex ;
     FillOptionsLists ;
     Screen.Cursor := crDefault ;
     end;

end.
