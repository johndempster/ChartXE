program Chart;

uses
  Forms,
  MAIN in 'MAIN.PAS' {MainFrm},
  SHARED in 'SHARED.PAS',
  STIMSET in 'STIMSET.PAS' {StimulatorDlg},
  ABOUT in 'ABOUT.PAS' {AboutDlg},
  TABLE in 'TABLE.PAS' {TabForm},
  CALIB in 'CALIB.PAS' {CalibFrm},
  use1902 in 'use1902.pas' {CED1902: TDataModule},
  SetupRec in 'SetupRec.pas' {SetupRecFrm},
  SetupCED in 'SetupCED.pas' {SetupCEDFrm},
  SetupSpec in 'SetupSpec.pas' {SetupSpeFrm},
  Maths in '..\Components\Maths.pas',
  PRINTREC in 'PRINTREC.PAS' {PrintRecFrm},
  EditMarkers in 'EditMarkers.pas' {EditMarkersFrm},
  LabInterfaceSetup in 'LabInterfaceSetup.pas' {LabInterfaceSetupFrm};

{$R *.RES}

begin
  Application.Title := 'Chart';
  Application.HelpFile := 'CHART.chm';
  Application.CreateForm(TCED1902, CED1902);
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TStimulatorDlg, StimulatorDlg);
  Application.CreateForm(TAboutDlg, AboutDlg);
  Application.CreateForm(TTabForm, TabForm);
  Application.CreateForm(TCalibFrm, CalibFrm);
  Application.CreateForm(TSetupRecFrm, SetupRecFrm);
  Application.CreateForm(TSetupCEDFrm, SetupCEDFrm);
  Application.CreateForm(TSetupSpeFrm, SetupSpeFrm);
  Application.CreateForm(TPrintRecFrm, PrintRecFrm);
  Application.CreateForm(TEditMarkersFrm, EditMarkersFrm);
  Application.CreateForm(TLabInterfaceSetupFrm, LabInterfaceSetupFrm);
  Application.Run;
end.
