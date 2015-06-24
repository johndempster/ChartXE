unit Stimset;
{ =============================================================
  CHART - Set stimulator parameters module
  (c) J. Dempster, University of Strathclyde 1996-98
  23/8/98 ... OK and Cancel buttons changed to ordinary buttons
  6/2/01 .... Spin buttons removed and Validated edit boxes added
  18/5/03 ... Pulse amplitude can now be set
  23.07.13 ... 0.0 settings now replaced with defaults
  03.12.13 ... On and Off voltages now defined
  =============================================================}
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Spin, Shared, SysUtils, ValEdit,
  ValidatedEdit ;

type
  TStimulatorDlg = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    edPulseVOn: TValidatedEdit;
    Label5: TLabel;
    edPulseVOff: TValidatedEdit;
    GroupBox2: TGroupBox;
    Period: TLabel;
    edRepeatPeriod: TValidatedEdit;
    Label2: TLabel;
    edNumStimuli: TValidatedEdit;
    Label1: TLabel;
    edPulseFrequency: TValidatedEdit;
    Label3: TLabel;
    edPulseWidth: TValidatedEdit;
    procedure FormActivate(Sender: TObject);
    procedure bOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StimulatorDlg: TStimulatorDlg;

implementation
{$R *.DFM}
uses Main ;

procedure TStimulatorDlg.FormActivate(Sender: TObject);
begin
     if MainFrm.Stimulator.GroupInterval <= 0.0 then MainFrm.Stimulator.GroupInterval := 1.0 ;
     EdRepeatPeriod.Value := MainFrm.Stimulator.GroupInterval ;

     EdNumStimuli.Value := MainFrm.Stimulator.PulsesPergroup ;

     if MainFrm.Stimulator.PulseFrequency <= 0.0 then MainFrm.Stimulator.PulseFrequency := 1.0 ;
     EdPulseFrequency.Value := MainFrm.Stimulator.PulseFrequency ;

     if MainFrm.Stimulator.PulseWidth <= 0.0 then MainFrm.Stimulator.PulseWidth := 0.1 ;
     EdPulseWidth.Value := MainFrm.Stimulator.PulseWidth ;

     edPulseVOn.Value := MainFrm.Stimulator.PulseVOn ;
     edPulseVOff.Value := MainFrm.Stimulator.PulseVOff ;

     end;


procedure TStimulatorDlg.bOKClick(Sender: TObject);
begin

     MainFrm.Stimulator.GroupInterval := EdRepeatPeriod.Value ;
     if MainFrm.Stimulator.GroupInterval <= 0.0 then MainFrm.Stimulator.GroupInterval := 1.0 ;

     MainFrm.Stimulator.RepeatPeriodmsec := Trunc( MainFrm.Stimulator.GroupInterval * 1000. ) ;
     MainFrm.Stimulator.PulsesPerGroup := Round(EdNumStimuli.Value);

     MainFrm.Stimulator.PulseFrequency := EdPulseFrequency.Value ;
     if MainFrm.Stimulator.PulseFrequency <= 0.0 then MainFrm.Stimulator.PulseFrequency := 1.0 ;

     MainFrm.Stimulator.PulseWidth := EdPulseWidth.Value ;
     if MainFrm.Stimulator.PulseWidth <= 0.0 then MainFrm.Stimulator.PulseWidth := 0.1 ;

     MainFrm.Stimulator.PulseVOn := edPulseVOn.Value ;
     MainFrm.Stimulator.PulseVOff := edPulseVOff.Value ;

     end;

end.
