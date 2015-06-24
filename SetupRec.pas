unit SetupRec;
// -------------------------------------------------------------
// Sampling rate and input channel calibration setup dialog box
// -------------------------------------------------------------
// 7.10.03 ... Scaling factor now set correctly when calibration changed
// 21.07.05 ... A/D Input mode (differential/single ended) can now be set
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, ComCtrls, ValEdit, ValidatedEdit;

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
    cbADCVoltageRange0: TComboBox;
    bOK: TButton;
    Button1: TButton;
    cbADCVoltageRange1: TComboBox;
    cbADCVoltageRange2: TComboBox;
    cbADCVoltageRange3: TComboBox;
    cbADCVoltageRange4: TComboBox;
    cbADCVoltageRange5: TComboBox;
    cbADCVoltageRange6: TComboBox;
    cbADCVoltageRange7: TComboBox;
    GroupBox2: TGroupBox;
    ckBackupEnabled: TCheckBox;
    edBackupInterval: TValidatedEdit;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure edNumChannelsKeyPress(Sender: TObject; var Key: Char);
    procedure udFilterFactorClick(Sender: TObject; Button: TUDBtnType);
    procedure SetADCVoltageRange(
              Chan : Integer ;
              cbADCVoltageRange : TComboBox ) ;

  private
    { Private declarations }
    VRange : Array[0..15] of Single ;
    NumVRange : Integer ;
    procedure UpdateParameters ;
    procedure FillCalibrationTable ;
    procedure EnableADCSettings( Enabled : Boolean ) ;

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
   ch,i,EndChannel,LeftAt,TopAt : Integer ;
   Enabled : Boolean ;    // Enabled/disable controls flag
   LabelColor : TColor ; // Enabled/disabled label colour
begin

     // Enable/disable controls which must not be changed
     // after samples have been written to a data file
     if MainFrm.NumSamplesInFile > 0 then begin
        Enabled := False ;
        LabelColor := clGray ;
        end
     else begin
        Enabled := True ;
        LabelColor := clBlack ;
        end ;
     lbNumChannels.font.color := LabelColor ;
     lbSamplingInterval.font.color := LabelColor ;
     lbADCVoltageRange.font.color := LabelColor ;
     edSamplingInterval.enabled := Enabled ;
     edNumChannels.enabled := Enabled ;
     cbADCVoltageRange0.Enabled := Enabled ;
     cbADCVoltageRange1.Enabled := Enabled ;
     cbADCVoltageRange2.Enabled := Enabled ;
     cbADCVoltageRange3.Enabled := Enabled ;
     cbADCVoltageRange4.Enabled := Enabled ;
     cbADCVoltageRange5.Enabled := Enabled ;
     cbADCVoltageRange6.Enabled := Enabled ;
     cbADCVoltageRange7.Enabled := Enabled ;

     udFilterFactor.Position := Round(MainFrm.DigitalFilter.Factor*10.0) ;
     EdNumChannels.Value := MainFrm.ADCNumChannels ;

     UpdateParameters ;

     { Set channel calibration table }
     FillCalibrationTable ;

     { Set trace colour box }
     EndChannel := MainFrm.ADCNumChannels - 1 ;
     LeftAt := ChannelTable.Left + ChannelTable.Width + 2 ;
     TopAt := ChannelTable.Top + 2 ;

     // Place A/D input voltage range combo boxes next to channels
     cbADCVoltageRange0.Top :=  TopAt + (ChannelTable.DefaultRowHeight+1) ;
     cbADCVoltageRange0.Left :=  LeftAt ;
     cbADCVoltageRange1.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*2 ;
     cbADCVoltageRange1.Left := LeftAt ;
     cbADCVoltageRange2.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*3 ;
     cbADCVoltageRange2.Left := LeftAt ;
     cbADCVoltageRange3.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*4 ;
     cbADCVoltageRange3.Left := LeftAt ;
     cbADCVoltageRange4.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*5 ;
     cbADCVoltageRange4.Left := LeftAt ;
     cbADCVoltageRange5.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*6 ;
     cbADCVoltageRange5.Left := LeftAt ;
     cbADCVoltageRange6.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*7 ;
     cbADCVoltageRange6.Left := LeftAt ;
     cbADCVoltageRange7.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*8 ;
     cbADCVoltageRange7.Left := LeftAt ;

     // Trace colour boxes
     LeftAt := cbADCVoltageRange0.Left + cbADCVoltageRange0.Width + 5 ;

     // Select the current A/D converter range in use
     SetADCVoltageRange( 0, cbADCVoltageRange0 ) ;
     SetADCVoltageRange( 1, cbADCVoltageRange1 ) ;
     SetADCVoltageRange( 2, cbADCVoltageRange2 ) ;
     SetADCVoltageRange( 3, cbADCVoltageRange3 ) ;
     SetADCVoltageRange( 4, cbADCVoltageRange4 ) ;
     SetADCVoltageRange( 5, cbADCVoltageRange5 ) ;
     SetADCVoltageRange( 6, cbADCVoltageRange6 ) ;
     SetADCVoltageRange( 5, cbADCVoltageRange7 ) ;

     ChannelTable.cells[ChNum,0] := 'Ch.' ;
     ChannelTable.ColWidths[ChNum] := ChannelTable.DefaultColWidth div 2 ;

     ChannelTable.cells[ChName,0] := 'Name' ;
     ChannelTable.cells[ChCal,0] := 'V/Units' ;
     ChannelTable.ColWidths[ChCal] := (4 * ChannelTable.DefaultColWidth) div 2 ;
     ChannelTable.cells[ChAmp,0] := 'Amp. Gain' ;
     ChannelTable.ColWidths[ChAmp] := (3 * ChannelTable.DefaultColWidth) div 2 ;
     ChannelTable.cells[ChUnits,0] := 'Units' ;
     ChannelTable.RowCount := MainFrm.ADCNumChannels + 1 ;
     ChannelTable.options := [goEditing,goHorzLine,goVertLine] ;

     // Automatic data file backup
     ckBackupEnabled.Checked := MainFrm.BackupEnabled ;
     edBackupInterval.Value := MainFrm.BackupInterval ;

     //Enable A/D settings only when data file is empty
     if MainFrm.NumSamplesInFile <= 0 then EnableADCSettings(True)
                                      else EnableADCSettings(False) ;

     end ;

procedure TSetupRecFrm.EnableADCSettings( Enabled : Boolean ) ;
// -----------------------------------
// Enable/disable A/D control settings
// -----------------------------------

begin
    cbADCVoltageRange0.Enabled := Enabled ;
    cbADCVoltageRange1.Enabled := Enabled ;
    cbADCVoltageRange2.Enabled := Enabled ;
    cbADCVoltageRange3.Enabled := Enabled ;
    cbADCVoltageRange4.Enabled := Enabled ;
    cbADCVoltageRange5.Enabled := Enabled ;
    cbADCVoltageRange6.Enabled := Enabled ;
    cbADCVoltageRange7.Enabled := Enabled ;
    edNumChannels.Enabled := Enabled ;
    edSamplingInterval.Enabled := Enabled ;
    end ;


procedure TSetupRecFrm.FillCalibrationTable ;
// ------------------------------
// Fill channel calibration table
// ------------------------------
var
    ch : Integer ;
begin
     { Set channel calibration table }
     ChannelTable.RowCount := MainFrm.ADCNumChannels+1 ;
     for ch := 0 to MainFrm.ADCNumChannels-1 do begin
         ChannelTable.cells[ChNum,ch+1] := format('%d',[ch]);
         ChannelTable.cells[ChName,ch+1] := MainFrm.ADCChannelName[ch] ;

         ChannelTable.cells[ChCal,ch+1] := Format( '%10.4g',
                                      [MainFrm.ADCChannelVoltsPerUnit[ch]] ) ;

         ChannelTable.cells[ChAmp,ch+1] := Format( '%10.4g',
                                      [MainFrm.ADCChannelGain[ch]] ) ;
         ChannelTable.cells[ChUnits,ch+1] := MainFrm.ADCChannelUnits[ch] ;
         end ;
     end ;


procedure TSetupRecFrm.SetADCVoltageRange(
          Chan : Integer ;
          cbADCVoltageRange : TComboBox ) ;
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
         Diff := Abs(MainFrm.ADCChannelVoltageRange[Chan]-VRange[i]) ;
         if MinDiff >= Diff then begin
            MinDiff := Diff ;
            cbADCVoltageRange.ItemIndex := i ;
            RangeInList := True ;
            end ;
         end ;

     if not RangeInList then begin
         cbADCVoltageRange.items.addObject( format(
                                             ' +/- %.3g V ',
                                             [MainFrm.ADCChannelVoltageRange[Chan]]),
                                              TObject(MainFrm.ADCChannelVoltageRange[Chan]));
         end ;

     end ;


procedure TSetupRecFrm.UpdateParameters ;
begin

     MainFrm.ADCNumChannels := Round(edNumChannels.Value) ;
     cbADCVoltageRange0.Visible := True ;
     cbADCVoltageRange1.Visible := False ;
     cbADCVoltageRange2.Visible := False ;
     cbADCVoltageRange3.Visible := False ;
     cbADCVoltageRange4.Visible := False ;
     cbADCVoltageRange5.Visible := False ;
     cbADCVoltageRange6.Visible := False ;
     cbADCVoltageRange7.Visible := False ;
     if MainFrm.ADCNumChannels >= 2 then cbADCVoltageRange1.Visible := True ;
     if MainFrm.ADCNumChannels >= 3 then cbADCVoltageRange2.Visible := True ;
     if MainFrm.ADCNumChannels >= 4 then cbADCVoltageRange3.Visible := True ;
     if MainFrm.ADCNumChannels >= 5 then cbADCVoltageRange4.Visible := True ;
     if MainFrm.ADCNumChannels >= 6 then cbADCVoltageRange5.Visible := True ;
     if MainFrm.ADCNumChannels >= 7 then cbADCVoltageRange6.Visible := True ;
     if MainFrm.ADCNumChannels >= 7 then cbADCVoltageRange7.Visible := True ;

     { Set recording parameters }
     if MainFrm.SESLabIO.ADCSamplingInterval <
        MinDT*MainFrm.ADCNumChannels then
        MainFrm.ADCSamplingInterval := MinDT*MainFrm.ADCNumChannels ;
     if MainFrm.ADCSamplingInterval > MaxDT then
        MainFrm.ADCSamplingInterval := MaxDT ;
     EdSamplingInterval.Value := MainFrm.ADCSamplingInterval ;

     { Digital low-pass filter constant }
     edDigitalFilter.text := LPFilterCutOff( MainFrm.DigitalFilter.Factor ) ;

     end ;


procedure TSetupRecFrm.bOKClick(Sender: TObject);
var
   ch : Integer ;
begin

     { Recording parameters }

     MainFrm.ADCSamplingInterval := EdSamplingInterval.Value ;
     MainFrm.ADCNumChannels := Round(EdNumChannels.Value ) ;

     // Digital low pass filter factor
     MainFrm.DigitalFilter.Factor := udFilterFactor.Position*0.1 ;

     // A/D converter voltage range
     MainFrm.ADCChannelVoltageRange[0] := Single(cbADCVoltageRange0.Items.Objects[
                                                    cbADCVoltageRange0.ItemIndex]) ;
     MainFrm.ADCChannelVoltageRange[1] := Single(cbADCVoltageRange1.Items.Objects[
                                                    cbADCVoltageRange1.ItemIndex]) ;
     MainFrm.ADCChannelVoltageRange[2] := Single(cbADCVoltageRange2.Items.Objects[
                                                    cbADCVoltageRange2.ItemIndex]) ;
     MainFrm.ADCChannelVoltageRange[3] := Single(cbADCVoltageRange3.Items.Objects[
                                                    cbADCVoltageRange3.ItemIndex]) ;
     MainFrm.ADCChannelVoltageRange[4] := Single(cbADCVoltageRange4.Items.Objects[
                                                    cbADCVoltageRange4.ItemIndex]) ;
     MainFrm.ADCChannelVoltageRange[5] := Single(cbADCVoltageRange5.Items.Objects[
                                                    cbADCVoltageRange5.ItemIndex]) ;
     MainFrm.ADCChannelVoltageRange[6] := Single(cbADCVoltageRange6.Items.Objects[
                                                    cbADCVoltageRange6.ItemIndex]) ;
     MainFrm.ADCChannelVoltageRange[7] := Single(cbADCVoltageRange7.Items.Objects[
                                                    cbADCVoltageRange7.ItemIndex]) ;

//     for ch := 0 to 7 do MainFrm.ADCChannelVoltageRange[ch] ;

     { Channel calibration }
     for ch := 0 to MainFrm.ADCNumChannels-1 do begin
         MainFrm.ADCChannelName[ch] := ChannelTable.cells[ChName,ch+1] ;
         MainFrm.ADCChannelVoltsPerUnit[ch] := ExtractFloat(
                                           ChannelTable.cells[ChCal,ch+1],1. );
         if MainFrm.ADCChannelVoltsPerUnit[ch] = 0.0 then MainFrm.ADCChannelVoltsPerUnit[ch] := 1.0 ;
         MainFrm.ADCChannelGain[ch] := ExtractFloat(
                                                ChannelTable.cells[ChAmp,ch+1],1. );
         if MainFrm.ADCChannelGain[ch] = 0.0 then MainFrm.ADCChannelGain[ch] := 1.0 ;

         MainFrm.ADCChannelUnits[ch] := ChannelTable.cells[ChUnits,ch+1] ;

         MainFrm.ADCChannelScale[ch] := MainFrm.ADCChannelVoltageRange[Ch] /
                                                (MainFrm.ADCChannelVoltsPerUnit[Ch]*
                                                MainFrm.ADCChannelGain[Ch]*
                                                (MainFrm.ADCMaxValue+1)) ;

         end ;

     // Automatic data file backup
     MainFrm.BackupEnabled := ckBackupEnabled.Checked  ;
     MainFrm.BackupInterval := edBackupInterval.Value ;

     // Save to data file
     MainFrm.SaveToDataFile( MainFrm.SaveFileName ) ;

     end;

     
procedure TSetupRecFrm.edNumChannelsKeyPress(Sender: TObject;
  var Key: Char);

var
   ch,Row,OldCount : Integer ;
begin

     MainFrm.ADCNumChannels := Round(edNumChannels.Value) ;

     if key = chr(13) then begin
         FillCalibrationTable ;
         UpdateParameters ;
         end ;
     end;

procedure TSetupRecFrm.udFilterFactorClick(Sender: TObject;
  Button: TUDBtnType);
var
   Factor : single ;
begin
     Factor := udFilterFactor.Position*0.1 ;
     EdDigitalFilter.text := LPFilterCutoff( Factor )
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
