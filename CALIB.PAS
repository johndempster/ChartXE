unit Calib;
{ ===================================================
  CHART - Calibration wizard module
  (c) J. Dempster, University of Strathclyde, 1996-98
  ===================================================
  24/9/4 Calibration bug corrected }

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, SysUtils, Shared, use1902, ValEdit,
  ValidatedEdit, dialogs ;

type
  TCalibFrm = class(TForm)
    Panel1: TPanel;
    bBack: TButton;
    bNext: TButton;
    bFinish: TButton;
    bCancel: TButton;
    Panel2: TPanel;
    Instructions: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Timer1: TTimer;
    cbChannels: TComboBox;
    edCalibrationValue: TValidatedEdit;
    edVoltageLevel: TValidatedEdit;
    procedure Timer1Timer(Sender: TObject);
    procedure bNextClick(Sender: TObject);
    procedure bBackClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bFinishClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbChannelsChange(Sender: TObject);
    procedure edCalibrationValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure SetCalibrationValue ;
  public
    { Public declarations }
  end;

var
  CalibFrm: TCalibFrm;

implementation

uses Main;

{$R *.DFM}

type
TState = ( SelectChannel,
            ApplyCalibration,
            RemoveCalibration,
            EnterCalibrationValue ) ;
var
   State : TState ;
   NewState : Boolean ;
//   ChCal : Integer ;
   iADC : Integer ;
   V,VCal,VZero : Single ;


procedure TCalibFrm.FormActivate(Sender: TObject);
{ --------------------------------------
  Initialisations when form is activated
  --------------------------------------}
var
   ch : Integer ;
begin

     { Fill channel selection list }
     cbChannels.Clear ;
     for ch := 0 to MainFrm.SESLabIO.ADCNumChannels-1 do
          cbChannels.items.add( ' ' + MainFrm.ADCChannelName[ch] ) ;
    { Start with channel 0 selected }
//    ChCal := 0 ;
    cbChannels.ItemIndex := 0 ;
    SetCalibrationValue ;

    Timer1.Enabled := True ;

    { Set CED 1902 settings }
    if CED1902.InUse then CED1902.UpdateAmplifier ;

    State := SelectChannel ;
    bNext.Enabled := True ;
    bBack.Enabled := False ;
    bFinish.Enabled := False ;
    NewState := True ;

    end;

procedure TCalibFrm.SetCalibrationValue ;
// ---------------------
// Set calibration value
// ---------------------
begin
    if MainFrm.ADCChannelVoltsPerUnit[cbChannels.ItemIndex] = 0. then
       MainFrm.ADCChannelVoltsPerUnit[cbChannels.ItemIndex] := 1. ;
    edCalibrationValue.Units := MainFrm.ADCChannelUnits[cbChannels.ItemIndex] ;
    edCalibrationValue.Value := Mainfrm.ADCCalibrationValue[cbChannels.ItemIndex] ;
    end ;


procedure TCalibFrm.Timer1Timer(Sender: TObject);
{ ---------------------
  Timed event scheduler
  ---------------------}

begin

{ Read A/D channel }

     iADC := Mainfrm.SESLabIO.ReadADC( cbChannels.ItemIndex ) ;
     V := (iADC * MainFrm.ADCChannelVoltageRange[cbChannels.ItemIndex])/(Mainfrm.ADCMaxValue*Mainfrm.ADCChannelGain[cbChannels.ItemIndex]) ;
     edVoltageLevel.Value := V ;

     if NewState then begin

     NewState := False ;

     case State of
          SelectChannel : Begin
             if MainFrm.SESLabIO.ADCNumChannels > 1 then begin
                Instructions.lines[0] := ' CALIBRATION STEP 1 of 4 ' ;
                Instructions.lines[1] := ' Select the "Input Channel" to be calibrated. ' ;
                Instructions.lines[2] := ' Then click the "Next" button to continue.' ;
                Instructions.lines[3] := ' ' ;
                Instructions.Lines[4] := ' ' ;
                end
             else begin
                State := ApplyCalibration ;
                NewState := True ;
                end ;
             end ;
          ApplyCalibration : Begin

             Instructions.lines[0] := ' CALIBRATION STEP 2 of 4 ' ;
             Instructions.lines[1] := ' Apply a calibration weight to the transducer. ' ;
             Instructions.Lines[2] := ' Wait till the Voltage Level reading settles down.' ;
             Instructions.lines[3] := ' Then click the "Next" button to continue.' ;
             Instructions.Lines[4] := ' ' ;
             end ;

          RemoveCalibration : Begin
             Instructions.lines[0] := ' CALIBRATION STEP 3 of 4 ' ;
             Instructions.lines[1] := ' Remove the calibration weight. ' ;
             Instructions.Lines[2] := ' Wait till the Voltage Level reading settles down.' ;
             Instructions.lines[3] := ' Then click the "Next" button to continue.' ;
             Instructions.Lines[4] := ' ' ;
             VCal := V ;
             end ;

          EnterCalibrationValue : Begin
             Instructions.lines[0] := ' CALIBRATION STEP 4 of 4 ' ;
             Instructions.lines[1] := ' Enter the value of the calibration weight into' ;
             Instructions.lines[2] := ' the "Calibration Value" box.' ;
             Instructions.lines[3] := ' Then click the "Finish" button to complete the' ;
             Instructions.Lines[4] := ' calibration.' ;
             VZero := V ;
             { Use this as the zero level }
             Mainfrm.ADCChannelZero[cbChannels.ItemIndex] := iADC ;
             end ;
          end ;
     end ;
     end;


procedure TCalibFrm.bNextClick(Sender: TObject);
{ -----------------------------------------------
  Move forward a stage in the calibration process
  -----------------------------------------------}
begin
     if State = SelectChannel then State := ApplyCalibration
     else if State = ApplyCalibration then State := RemoveCalibration
     else if State = RemoveCalibration then State := EnterCalibrationValue ;

     if State = EnterCalibrationValue then begin
        bNext.Enabled := False ;
        bFinish.Enabled := True ;
        end ;
     bBack.enabled := True ;
     NewState := True ;
     end;


procedure TCalibFrm.bBackClick(Sender: TObject);
{ --------------------------------------------
  Move back a stage in the calibration process
  --------------------------------------------}
begin
     if State = EnterCalibrationValue then State := RemoveCalibration
     else if State = RemoveCalibration then State := ApplyCalibration
     else if State = ApplyCalibration then State := SelectChannel ;

     if State = SelectChannel then bBack.Enabled := False ;
     bFinish.Enabled := False ;
     bNext.Enabled := True ;
     NewState := True ;
     end;



procedure TCalibFrm.bFinishClick(Sender: TObject);
{ ------------------------------
  Finish the calibration process
  ------------------------------}
var
   VDiff,OldFactor : Single ;
begin
     Mainfrm.ADCCalibrationValue[cbChannels.ItemIndex] := edCalibrationValue.Value ;
     VDiff := VCal - VZero ;
     OldFactor := Mainfrm.ADCChannelVoltsPerUnit[cbChannels.ItemIndex] ;
     try
        Mainfrm.ADCChannelVoltsPerUnit[cbChannels.ItemIndex]  :=  VDiff / Mainfrm.ADCCalibrationValue[cbChannels.ItemIndex] ;
     except
        on EZeroDivide do begin
           ShowMessage('Calibration step too small! Reverting to old value.');
           Mainfrm.ADCChannelVoltsPerUnit[cbChannels.ItemIndex] := OldFactor ;
           end ;
        on EInvalidOp do begin
           Mainfrm.ADCChannelVoltsPerUnit[cbChannels.ItemIndex] := OldFactor ;
           ShowMessage('Calibration step too small! Reverting to old value.');
           end ;
        end ;

     Timer1.Enabled := False ;
     end;


procedure TCalibFrm.bCancelClick(Sender: TObject);
begin
     Timer1.Enabled := False ;
     end;

procedure TCalibFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Timer1.Enabled := False ;
     end;

procedure TCalibFrm.cbChannelsChange(Sender: TObject);
begin
     SetCalibrationValue ;
     end;

procedure TCalibFrm.edCalibrationValueKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = #13 then begin
       Mainfrm.ADCCalibrationValue[cbChannels.ItemIndex] := edCalibrationValue.Value ;
       SetCalibrationValue ;
       end ;
    end;

end.
