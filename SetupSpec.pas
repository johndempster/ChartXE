unit SetupSpec;
// ---------------------------------------------
// CHART - Setup dialog box for special channels
// ---------------------------------------------
// 20.5.03
// 21.12.11

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ValEdit, ValidatedEdit, math ;

type
  TSetupSpeFrm = class(TForm)
    RMSGroup: TGroupBox;
    Label3: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    cbRMSFromChannel: TComboBox;
    cbRMSToChannel: TComboBox;
    ckRMSInUse: TCheckBox;
    edRMSNumPoints: TValidatedEdit;
    HeartrateGrp: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label17: TLabel;
    ckHRinUse: TCheckBox;
    cbHRFromChannel: TComboBox;
    cbHRToChannel: TComboBox;
    RadioGroup1: TRadioGroup;
    rbDisplayRR: TRadioButton;
    rbDisplayHR: TRadioButton;
    edHRMaxScale: TValidatedEdit;
    edHRThreshold: TValidatedEdit;
    bOK: TButton;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure rbDisplayHRClick(Sender: TObject);
    procedure rbDisplayRRClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetupSpeFrm: TSetupSpeFrm;

implementation

uses shared , Main;

{$R *.DFM}

procedure TSetupSpeFrm.FormShow(Sender: TObject);
{ ---------------------------------------------------------------------------
  Initialise setup's combo lists and tables with current recording parameters
  ---------------------------------------------------------------------------}

var
   ch : Integer ;
begin

     { RMS processor }
     cbRMSFromChannel.clear ;
     for ch := 0 to MainFrm.ADCNumChannels-1 do
         cbRMSFromChannel.items.add(format('Ch.%d %s',[ch,MainFrm.ADCChannelName[ch]])) ;
     cbRMSToChannel.items := cbRMSFromChannel.items ;
     cbHRFromChannel.items := cbRMSFromChannel.items ;
     cbHRToChannel.items := cbRMSFromChannel.items ;

     ckRMSInUse.checked := MainFrm.RMS.InUse ;
     cbRMSFromChannel.itemindex := MainFrm.RMS.FromChannel ;
     cbRMSToChannel.itemindex := MainFrm.RMS.ToChannel ;
     edRMSNumPoints.value := MainFrm.RMS.NumAverage ;

     { Heart rate processor }
     ckHRInUse.checked := MainFrm.HR.InUse ;
     cbHRFromChannel.itemindex := MainFrm.HR.FromChannel ;
     cbHRToChannel.itemindex := MainFrm.HR.ToChannel ;

     { Heartbeat detection threshold }
     edHRThreshold.Value := MainFrm.HR.PercentageThreshold ;

     { Set display mode radio buttons and scale maximum}
     if MainFrm.HR.DisplayHR then begin
        rbDisplayHR.checked := True ;
        edHRMaxScale.Units := 'bpm' ;
        end
     else begin
        rbDisplayRR.checked := True ;
        edHRMaxScale.Units := 's' ;
        end ;
     edHRMaxScale.Value := MainFrm.HR.MaxScale ;
     end ;


procedure TSetupSpeFrm.bOKClick(Sender: TObject);
var
   ch : Integer ;
begin

     MainFrm.RMS.FromChannel := cbRMSFromChannel.itemindex  ;
     MainFrm.RMS.ToChannel := cbRMSToChannel.itemindex ;
     MainFrm.RMS.NumAverage := Round(edRMSNumPoints.value) ;
     MainFrm.RMS.InUse := ckRMSInUse.checked ;
     if MainFrm.ADCNumChannels <= 1 then begin
        { If only one channel disable RMS calculation }
        MainFrm.RMS.InUse := False ;
        ckRMSInUse.checked := False ;
        end ;
     if MainFrm.RMS.InUse then begin
        //MainFrm.Channel[MainFrm.RMS.ToChannel] := MainFrm.Channel[MainFrm.RMS.FromChannel] ;
        MainFrm.ADCChannelName[MainFrm.RMS.ToChannel] := 'RMS' ;
        end
     else if MainFrm.ADCChannelName[MainFrm.RMS.ToChannel] = 'RMS' then begin
         { If channel has been used for RMS result, remove RMS title }
         MainFrm.ADCChannelName[MainFrm.RMS.ToChannel] :=
         'Ch.' + IntToStr(MainFrm.RMS.ToChannel) ;
        end ;

     { Heart rate processor }
     MainFrm.HR.FromChannel := cbHRFromChannel.itemindex ;
     MainFrm.HR.ToChannel := cbHRToChannel.itemindex ;
     MainFrm.HR.InUse := ckHRInUse.checked ;
     if MainFrm.ADCNumChannels <= 1 then begin
        { If only one channel disable RMS calculation }
        MainFrm.HR.InUse := False ;
        ckHRInUse.checked := False ;
        end ;

      MainFrm.HR.PercentageThreshold := ExtractFloat(edHRThreshold.text,50.0);

     if rbDisplayHR.checked then MainFrm.HR.DisplayHR := True
                            else MainFrm.HR.DisplayHR := False ;

     MainFrm.HR.MaxScale := ExtractFloat( edHRMaxScale.text, MainFrm.HR.MaxScale ) ;

     if MainFrm.HR.InUse then begin

        if MainFrm.HR.DisplayHR then begin
           MainFrm.HR.Scale := (60.*MainFrm.ADCMaxValue) / ( MainFrm.HR.MaxScale * MainFrm.ADCSamplingInterval ) ;
           MainFrm.ADCChannelUnits[MainFrm.HR.ToChannel] := 'bpm' ;
           MainFrm.ADCChannelName[MainFrm.HR.ToChannel] := 'H.R.' ;
           end
        else begin
           MainFrm.HR.Scale := MainFrm.scDisplay.MaxADCValue*MainFrm.ADCSamplingInterval / MainFrm.HR.MaxScale ;
           MainFrm.ADCChannelUnits[MainFrm.HR.ToChannel] :=  's' ;
           MainFrm.ADCChannelName[MainFrm.HR.ToChannel] := 'R-R' ;
           end ;
        MainFrm.ADCChannelScale[MainFrm.HR.ToChannel] := MainFrm.HR.MaxScale / Max(MainFrm.ADCMaxValue,1) ;
        MainFrm.ADCChannelGain[MainFrm.HR.ToChannel] := 1. ;
        MainFrm.ADCChannelVoltsPerUnit[MainFrm.HR.ToChannel] := MainFrm.ADCChannelVoltageRange[MainFrm.HR.ToChannel] /
                                                (MainFrm.ADCChannelScale[MainFrm.HR.ToChannel]*
                                                MainFrm.ADCChannelGain[MainFrm.HR.ToChannel]*
                                                (MainFrm.ADCMaxValue+1)) ;

        MainFrm.ADCChannelZero[MainFrm.HR.ToChannel] := 0 ;
        end
     else if MainFrm.ADCChannelName[MainFrm.HR.ToChannel] = 'H.R.' then
         { If channel has been used for HR result, remove HR title }
         MainFrm.ADCChannelName[MainFrm.HR.ToChannel] := format('Ch.%d',[MainFrm.HR.ToChannel]) ;

     end;

procedure TSetupSpeFrm.rbDisplayHRClick(Sender: TObject);
// -------------------------------
// Display heart rate as beats/min.
// -------------------------------
begin
     edHRMaxScale.Units := 'bpm' ;
     end;

procedure TSetupSpeFrm.rbDisplayRRClick(Sender: TObject);
// ----------------------------------
// Display heart rate as R-R interval
// ----------------------------------
begin
     edHRMaxScale.Units := 's' ;
     end;

end.
