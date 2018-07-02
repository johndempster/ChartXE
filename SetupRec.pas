unit SetupRec;
// -------------------------------------------------------------
// Sampling rate and input channel calibration setup dialog box
// -------------------------------------------------------------
// 7.10.03 ... Scaling factor now set correctly when calibration changed
// 21.07.05 ... A/D Input mode (differential/single ended) can now be set
// 23.09.12 ... SESLABIO. properties now updated instead of Main.
// 18.12.15 ... Input channel can now be remapped
//              Sampling interval now updated correctly and digital filter selection now works correctly

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, ComCtrls, ValEdit, ValidatedEdit, math ;

type
  TSetupRecFrm = class(TForm)
    GroupBox1: TGroupBox;
    lbNumChannels: TLabel;
    lbSamplingInterval: TLabel;
    Label4: TLabel;
    edNumChannels: TValidatedEdit;
    edSamplingInterval: TValidatedEdit;
    edDigitalFilter: TEdit;
    udFilterFactor: TUpDown;
    Channels: TGroupBox;
    lbADCVoltageRange: TLabel;
    ChannelTable: TStringGrid;
    bOK: TButton;
    Button1: TButton;
    GroupBox2: TGroupBox;
    ckBackupEnabled: TCheckBox;
    edBackupInterval: TValidatedEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel0: TPanel;
    cbADCVoltageRange0: TComboBox;
    cbAIInput0: TComboBox;
    Panel1: TPanel;
    cbADCVoltageRange1: TComboBox;
    cbAIInput1: TComboBox;
    Panel2: TPanel;
    cbADCVoltageRange2: TComboBox;
    cbAIInput2: TComboBox;
    Panel3: TPanel;
    cbADCVoltageRange3: TComboBox;
    cbAIInput3: TComboBox;
    Panel4: TPanel;
    cbADCVoltageRange4: TComboBox;
    cbAIInput4: TComboBox;
    Panel5: TPanel;
    cbADCVoltageRange5: TComboBox;
    cbAIInput5: TComboBox;
    Panel6: TPanel;
    cbADCVoltageRange6: TComboBox;
    cbAIInput6: TComboBox;
    Panel7: TPanel;
    cbADCVoltageRange7: TComboBox;
    cbAIInput7: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure edNumChannelsKeyPress(Sender: TObject; var Key: Char);
    procedure SetADCVoltageRangeAndChannel(
              Chan : Integer ;
              cbADCVoltageRange : TComboBox ;
              cbAIChannel : TComboBox ) ;
    procedure udFilterFactorChanging(Sender: TObject; var AllowChange: Boolean);
    procedure udFilterFactorChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: SmallInt;
      Direction: TUpDownDirection);

  private
    { Private declarations }
    VRange : Array[0..15] of Single ;
    NumVRange : Integer ;
    DigitalFilterFactor : Single ;
    procedure UpdateParameters ;
    procedure FillCalibrationTable ;
    procedure UpdateVoltageRange(
          Chan : Integer;
          cbADCVoltageRange : TComboBox ;
          cbADCChannel : TComboBox ) ;

  public
    { Public declarations }
  end;

var
  SetupRecFrm: TSetupRecFrm;
  function LPFilterCutoff( Factor : single ) : string ;

implementation

uses Main, shared ;

{$R *.DFM}
const
     ChNum = 0 ;
     ChName = 1 ;
     ChCal = 2 ;
     ChAmp = 3 ;
     ChUnits = 4 ;


procedure TSetupRecFrm.FormShow(Sender: TObject);
{ ---------------------------------------------------------------------------
  Initialise setup's combo lists and tables with current recording parameters
  ---------------------------------------------------------------------------}
var
   EndChannel,LeftAt,TopAt : Integer ;
begin

     DigitalFilterFactor := MainFrm.DigitalFilter.Factor ;
     EdNumChannels.Value := MainFrm.SESLabIO.ADCNumChannels ;
     edSamplingInterval.Value := MainFrm.SESLabIO.ADCSamplingInterval ;

     UpdateParameters ;

     { Set channel calibration table }
     FillCalibrationTable ;

     { Set trace colour box }
     EndChannel := MainFrm.SESLabIO.ADCNumChannels - 1 ;
     LeftAt := ChannelTable.Left + ChannelTable.Width + 2 ;
     TopAt := ChannelTable.Top + 2 ;

     // Place input voltage range and channel number
     Panel0.Left := LeftAt ;
     Panel0.Top := TopAt + (ChannelTable.DefaultRowHeight+1) ;
     Panel1.Left := LeftAt ;
     Panel1.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*2 ;
     Panel2.Left := LeftAt ;
     Panel2.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*3 ;
     Panel3.Left := LeftAt ;
     Panel3.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*4 ;
     Panel4.Left := LeftAt ;
     Panel4.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*5 ;
     Panel5.Left := LeftAt ;
     Panel5.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*6 ;
     Panel6.Left := LeftAt ;
     Panel6.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*7 ;
     Panel7.Left := LeftAt ;
     Panel7.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*8 ;

     // Trace colour boxes
     LeftAt := cbADCVoltageRange0.Left + cbADCVoltageRange0.Width + 5 ;

     // Select the current A/D converter range in use
     SetADCVoltageRangeAndChannel( 0, cbADCVoltageRange0, cbAIInput0 ) ;
     SetADCVoltageRangeAndChannel( 1, cbADCVoltageRange1, cbAIInput1 ) ;
     SetADCVoltageRangeAndChannel( 2, cbADCVoltageRange2, cbAIInput2 ) ;
     SetADCVoltageRangeAndChannel( 3, cbADCVoltageRange3, cbAIInput3 ) ;
     SetADCVoltageRangeAndChannel( 4, cbADCVoltageRange4, cbAIInput4 ) ;
     SetADCVoltageRangeAndChannel( 5, cbADCVoltageRange5, cbAIInput5 ) ;
     SetADCVoltageRangeAndChannel( 6, cbADCVoltageRange6, cbAIInput6 ) ;
     SetADCVoltageRangeAndChannel( 7, cbADCVoltageRange7, cbAIInput7 ) ;

     ChannelTable.cells[ChNum,0] := 'Ch.' ;
     ChannelTable.ColWidths[ChNum] := ChannelTable.DefaultColWidth div 2 ;

     ChannelTable.cells[ChName,0] := 'Name' ;
     ChannelTable.cells[ChCal,0] := 'V/Units' ;
     ChannelTable.ColWidths[ChCal] := (4 * ChannelTable.DefaultColWidth) div 2 ;
     ChannelTable.cells[ChAmp,0] := 'Amp. Gain' ;
     ChannelTable.ColWidths[ChAmp] := (3 * ChannelTable.DefaultColWidth) div 2 ;
     ChannelTable.cells[ChUnits,0] := 'Units' ;
     ChannelTable.RowCount := MainFrm.SESLabIO.ADCNumChannels + 1 ;
     ChannelTable.options := [goEditing,goHorzLine,goVertLine] ;

     // Automatic data file backup
     ckBackupEnabled.Checked := MainFrm.BackupEnabled ;
     edBackupInterval.Value := MainFrm.BackupInterval ;

     end ;


procedure TSetupRecFrm.FillCalibrationTable ;
// ------------------------------
// Fill channel calibration table
// ------------------------------
var
    ch,ADCScaleTo16Bit : Integer ;
begin

     ADCScaleTo16Bit := (MainFrm.ADCMaxValue+1) div MainFrm.SESLabIO.ADCMaxValue ;

     { Set channel calibration table }
     ChannelTable.RowCount := MainFrm.SESLabIO.ADCNumChannels+1 ;
     for ch := 0 to MainFrm.SESLabIO.ADCNumChannels-1 do begin
         ChannelTable.cells[ChNum,ch+1] := format('%d',[ch]);
         ChannelTable.cells[ChName,ch+1] := MainFrm.SESLabIO.ADCChannelName[ch] ;

         ChannelTable.cells[ChCal,ch+1] := Format( '%10.4g',
                                      [MainFrm.SESLabIO.ADCChannelVoltsPerUnit[ch]/
                                       ADCScaleTo16Bit] ) ;

         ChannelTable.cells[ChAmp,ch+1] := Format( '%10.4g',
                                      [MainFrm.SESLabIO.ADCChannelGain[ch]] ) ;
         ChannelTable.cells[ChUnits,ch+1] := MainFrm.SESLabIO.ADCChannelUnits[ch] ;
         end ;
     end ;


procedure TSetupRecFrm.SetADCVoltageRangeAndChannel(
          Chan : Integer ;
          cbADCVoltageRange : TComboBox ;
          cbAIChannel : TComboBox ) ;
var
   i : Integer ;
   Diff,MinDiff : single ;
   RangeInList : Boolean ;
begin

     // Set up A/D Converter voltage range selection box
     cbADCVoltageRange.clear ;
     MainFrm.SESLabIO.GetADCVoltageRanges( VRange, NumVRange) ;
     for i := 0 to NumVRange-1 do begin
         cbADCVoltageRange.items.addObject( format(
                                             ' +/- %.3g V ',
                                             [VRange[i]]),
                                              TObject(VRange[i]));
         end ;

     MinDiff := 1E30 ;
     RangeInList := False ;
     for i := 0 to NumVRange-1 do begin
         Diff := Abs(MainFrm.SESLabIO.ADCChannelVoltageRange[Chan]-VRange[i]) ;
         if MinDiff >= Diff then begin
            MinDiff := Diff ;
            cbADCVoltageRange.ItemIndex := i ;
            RangeInList := True ;
            end ;
         end ;

     if not RangeInList then begin
         cbADCVoltageRange.items.addObject( format(
                                             ' +/- %.3g V ',
                                             [MainFrm.SESLabIO.ADCChannelVoltageRange[Chan]]),
                                              TObject(MainFrm.SESLabIO.ADCChannelVoltageRange[Chan]));
         end ;

     // Input channels
     cbAIChannel.Clear ;
     for i := 0 to MainFrm.SESLabIO.ADCMaxChannels-1 do begin
         cbAIChannel.Items.Add(format('AI%d',[i]));
         end;
     cbAIChannel.ItemIndex := Min(Max(MainFrm.SESLabIO.ADCChannelInputNumber[Chan],
                              0),cbAIChannel.Items.Count-1) ;

     end ;


procedure TSetupRecFrm.UpdateParameters ;
// -----------------
// Update parameters
// -----------------
begin

     MainFrm.SESLabIO.ADCNumChannels := Round(edNumChannels.Value) ;
     edNumChannels.Value := MainFrm.SESLabIO.ADCNumChannels ;

     // Make voltage range / input channel panels visible
     Panel0.Visible := True ;
     Panel1.Visible := False ;
     Panel2.Visible := False ;
     Panel3.Visible := False ;
     Panel4.Visible := False ;
     Panel5.Visible := False ;
     Panel6.Visible := False ;
     Panel7.Visible := False ;
     if MainFrm.SESLabIO.ADCNumChannels >= 2 then Panel1.Visible := True ;
     if MainFrm.SESLabIO.ADCNumChannels >= 3 then Panel2.Visible := True ;
     if MainFrm.SESLabIO.ADCNumChannels >= 4 then Panel3.Visible := True ;
     if MainFrm.SESLabIO.ADCNumChannels >= 5 then Panel4.Visible := True ;
     if MainFrm.SESLabIO.ADCNumChannels >= 6 then Panel5.Visible := True ;
     if MainFrm.SESLabIO.ADCNumChannels >= 7 then Panel6.Visible := True ;
     if MainFrm.SESLabIO.ADCNumChannels >= 7 then Panel7.Visible := True ;

     { Set recording parameters }
     MainFrm.SESLabIO.ADCSamplingInterval := EdSamplingInterval.Value ;
     EdSamplingInterval.Value := MainFrm.SESLabIO.ADCSamplingInterval ;

     { Digital low-pass filter constant }
     edDigitalFilter.text := LPFilterCutOff( MainFrm.DigitalFilter.Factor ) ;

     end ;


procedure TSetupRecFrm.bOKClick(Sender: TObject);
var
   ch,ADCScaleTo16Bit : Integer ;
begin

     { Recording parameters }

     MainFrm.SESLabIO.ADCNumChannels := Round(edNumChannels.Value) ;
     MainFrm.SESLabIO.ADCSamplingInterval := edSamplingInterval.Value ;

     ADCScaleTo16Bit := (MainFrm.ADCMaxValue+1) div MainFrm.SESLabIO.ADCMaxValue ;

     // Digital low pass filter factor
     MainFrm.DigitalFilter.Factor := DigitalFilterFactor ;

     // A/D converter voltage range
     UpdateVoltageRange( 0, cbADCVoltageRange0, cbAIInput0 ) ;
     UpdateVoltageRange( 1, cbADCVoltageRange1, cbAIInput1 ) ;
     UpdateVoltageRange( 2, cbADCVoltageRange2, cbAIInput2 ) ;
     UpdateVoltageRange( 3, cbADCVoltageRange3, cbAIInput3 ) ;
     UpdateVoltageRange( 4, cbADCVoltageRange4, cbAIInput4 ) ;
     UpdateVoltageRange( 5, cbADCVoltageRange5, cbAIInput5 ) ;
     UpdateVoltageRange( 6, cbADCVoltageRange6, cbAIInput6 ) ;
     UpdateVoltageRange( 7, cbADCVoltageRange7, cbAIInput7 ) ;

     { Channel calibration }
     for ch := 0 to MainFrm.SESLabIO.ADCNumChannels-1 do begin
         MainFrm.SESLabIO.ADCChannelName[ch] := ChannelTable.cells[ChName,ch+1] ;
         MainFrm.SESLabIO.ADCChannelVoltsPerUnit[ch] := ADCScaleTo16Bit*ExtractFloat(
                                                        ChannelTable.cells[ChCal,ch+1],1. );
         MainFrm.SESLabIO.ADCChannelGain[ch] := ExtractFloat(
                                                ChannelTable.cells[ChAmp,ch+1],1. );
         MainFrm.SESLabIO.ADCChannelUnits[ch] := ChannelTable.cells[ChUnits,ch+1] ;
         end ;

     // Automatic data file backup
     MainFrm.BackupEnabled := ckBackupEnabled.Checked  ;
     MainFrm.BackupInterval := edBackupInterval.Value ;

     // Save to data file
     MainFrm.SaveToDataFile( MainFrm.SaveFileName ) ;

     end;

procedure TSetupRecFrm.UpdateVoltageRange(
          Chan : Integer;
          cbADCVoltageRange : TComboBox ;
          cbADCChannel : TComboBox ) ;
// --------------------------------------
// Update voltage range and input channel
// --------------------------------------
var
    NewRange : Single ;
begin
     NewRange :=  Single(cbADCVoltageRange.Items.Objects[cbADCVoltageRange.ItemIndex]) ;
     MainFrm.SESLabIO.ADCChannelVoltageRange[Chan] := NewRange ;
     MainFrm.SESLabIO.ADCChannelInputNumber[Chan] := Max(cbADCChannel.ItemIndex,0);
     end ;

procedure TSetupRecFrm.edNumChannelsKeyPress(Sender: TObject;
  var Key: Char);

begin

     MainFrm.SESLabIO.ADCNumChannels := Round(edNumChannels.Value) ;

     if key = #13 then begin
         FillCalibrationTable ;
         UpdateParameters ;
         end ;

     end;

procedure TSetupRecFrm.udFilterFactorChanging(Sender: TObject;
  var AllowChange: Boolean);
var
   Factor : single ;
begin
     Factor := udFilterFactor.Position*0.1 ;
     EdDigitalFilter.text := LPFilterCutoff( Factor ) ;
     outputdebugstring(pchar(format('%d %4g',[udFilterFactor.Position,Factor])));
     end;

procedure TSetupRecFrm.udFilterFactorChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: SmallInt; Direction: TUpDownDirection);

begin
     if Direction = updUp then DigitalFilterFactor := Max(DigitalFilterFactor - 0.1,0.1)
     else if Direction = updDown then DigitalFilterFactor := Min(DigitalFilterFactor + 0.1,1.0) ;
     EdDigitalFilter.text := LPFilterCutoff( DigitalFilterFactor ) ;

     end;


function LPFilterCutoff( Factor : single ) : string ;
Const
     fTolerance = 0.01 ;
var
   A,H1,H3,wt,f1,f2,f3 : Single ;
begin

     if Factor < 1. then begin
        A := 1. - Factor ;
        f1 := 0.001 ;
        f2 := 0.5 ;

        while Abs(f1-f2) > fTolerance do begin
           f3 := (f1+f2) / 2. ;
           wT := 2.*pi*f1 ;
           H1 := ((1.-A)*(1.-A) / (1. + A*A - 2*A*cos(wT)) ) - 0.5;
           wT := 2.*pi*f3 ;
           H3 := ((1.-A)*(1.-A) / (1. + A*A - 2*A*cos(wT)) ) - 0.5;
           if (H3*H1) < 0. then f2 := f3
                         else f1 := f3 ;
           end ;
        LPFilterCutoff := format('%.3g Hz',[f1/MainFrm.SESLabIO.ADCSamplingInterval]);

        end
     else LPFilterCutoff := 'No Filter' ;
     end ;

end.
