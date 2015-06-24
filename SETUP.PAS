unit Setup;
{ ===============================================================
  CHART - Setup module (c) J. Dempster, University of Strathclyde
  ===============================================================
  12/10/98 Now read CED 1902 gain/filter lists }

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Spin, ExtCtrls, shared, sysUtils, Grids, Dialogs, Global,
  TabNotBk,ComCtrls, ValEdit, ValidatedEdit ;

type
  TSetupDlg = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    GroupBox1: TGroupBox;
    lbNumChannels: TLabel;
    lbSamplingInterval: TLabel;
    Label4: TLabel;
    ColorDialog1: TColorDialog;
    CED1902Group: TGroupBox;
    Label11: TLabel;
    ckCED1902InUse: TCheckBox;
    cbCED1902ComPort: TComboBox;
    RMSGroup: TGroupBox;
    Label3: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    cbRMSFromChannel: TComboBox;
    cbRMSToChannel: TComboBox;
    ckRMSInUse: TCheckBox;
    HeartrateGrp: TGroupBox;
    ckHRinUse: TCheckBox;
    Label15: TLabel;
    cbHRFromChannel: TComboBox;
    cbHRToChannel: TComboBox;
    Label16: TLabel;
    Channels: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    ChannelTable: TStringGrid;
    cbADCVoltageRange: TComboBox;
    Label18: TLabel;
    RadioGroup1: TRadioGroup;
    rbDisplayRR: TRadioButton;
    rbDisplayHR: TRadioButton;
    Label17: TLabel;
    ChColor0: TPanel;
    ChColor1: TPanel;
    ChColor2: TPanel;
    ChColor3: TPanel;
    bOK: TButton;
    Button1: TButton;
    edCED1902Type: TEdit;
    edNumChannels: TValidatedEdit;
    edSamplingInterval: TValidatedEdit;
    edDigitalFilter: TEdit;
    InputGrp: TGroupBox;
    cbCED1902Input: TComboBox;
    Label8: TLabel;
    cbCED1902Gain: TComboBox;
    edDCOffset: TValidatedEdit;
    Label1: TLabel;
    FilterGrp: TGroupBox;
    Label9: TLabel;
    cbCED1902LPFilter: TComboBox;
    Label10: TLabel;
    cbCED1902HPFilter: TComboBox;
    ckCED1902NotchFilter: TCheckBox;
    ckCED1902ACCoupled: TCheckBox;
    edRMSNumPoints: TValidatedEdit;
    edHRMaxScale: TValidatedEdit;
    edHRThreshold: TValidatedEdit;
    udFilterFactor: TUpDown;
    procedure cbCED1902InputChange(Sender: TObject);
    procedure ckCED1902InUseClick(Sender: TObject);
    procedure cbCED1902GainChange(Sender: TObject);
    procedure rbDisplayRRClick(Sender: TObject);
    procedure rbDisplayHRClick(Sender: TObject);
    procedure ChColor0Click(Sender: TObject);
    procedure ChColor0DblClick(Sender: TObject);
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure edDCOffsetKeyPress(Sender: TObject; var Key: Char);
    procedure bOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbCED1902ComPortChange(Sender: TObject);
    procedure cbHRFromChannelChange(Sender: TObject);
    procedure cbHRToChannelChange(Sender: TObject);
    procedure cbRMSFromChannelChange(Sender: TObject);
    procedure cbRMSToChannelChange(Sender: TObject);
    procedure edHRThresholdKeyPress(Sender: TObject; var Key: Char);
    procedure edNumChannelsKeyPress(Sender: TObject; var Key: Char);
    procedure udFilterFactorClick(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
    procedure GetCED1902Options ;
    procedure UpdateParameters ;
  public
    { Public declarations }
  end;

function LPFilterCutoff( Factor : single ) : string ;

const
     ChNum = 0 ;
     ChName = 1 ;
     ChCal = 2 ;
     ChAmp = 3 ;
     ChUnits = 4 ;
var
  SetupDlg: TSetupDlg;
  FileContainsData : Boolean ;
  FilterFactor : Single ;

implementation

{$R *.DFM}

uses Main, use1902 ;

const
     OffsetMax = 32767 ;




procedure TSetupDlg.FormShow(Sender: TObject);
{ ---------------------------------------------------------------------------
  Initialise setup's combo lists and tables with current recording parameters
  ---------------------------------------------------------------------------}

var
   ch,i,NumOptions,EndChannel,LeftAt,TopAt : Integer ;
   Diff,MinDiff : single ;
begin


     if fH.NumSamplesInFile > 0 then begin
        lbNumChannels.font.color := clGray ;
        lbSamplingInterval.font.color := clGray ;
        edSamplingInterval.enabled := False ;
        edNumChannels.enabled := False ;
        end
     else begin
        lbNumChannels.font.color := clBlack ;
        lbSamplingInterval.font.color := clBlack ;
        edSamplingInterval.enabled := True ;
        edNumChannels.enabled := True ;
        end ;

     udFilterFactor.Position := Round(FH.DigitalFilter*10.0) ;
     UpdateParameters ;

     { Set channel calibration table }
     for ch := 0 to fH.NumChannels-1 do begin
         ChannelTable.cells[ChNum,ch+1] := format('%d',[ch]);
         ChannelTable.cells[ChName,ch+1] := Channel[ch].ADCName ;

         ChannelTable.cells[ChCal,ch+1] := Format( '%10.4g',
                                      [Channel[ch].ADCCalibrationFactor] ) ;

         ChannelTable.cells[ChAmp,ch+1] := Format( '%10.4g',
                                      [Channel[ch].ADCAmplifierGain] ) ;
         ChannelTable.cells[ChUnits,ch+1] := Channel[ch].ADCUnits ;
         end ;

     { Set trace colour box }
     EndChannel := fH.NumChannels - 1 ;
     LeftAt := ChannelTable.Left + ChannelTable.Width + 2 ;
     TopAt := ChannelTable.Top + 2 ;
     ChColor0.Top :=  TopAt + (ChannelTable.DefaultRowHeight+1) ;
     ChColor0.Left :=  LeftAt ;
     ChColor1.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*2 ;
     ChColor1.Left := LeftAt ;
     ChColor2.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*3 ;
     ChColor2.Left := LeftAt ;
     ChColor3.Top := TopAt + (ChannelTable.DefaultRowHeight+1)*4 ;
     ChColor3.Left := LeftAt ;

     { Set channel color blocks }
     ChColor0.Color := Channel[0].color ;
     ChColor1.Color := Channel[1].color ;
     ChColor2.Color := Channel[2].color ;
     ChColor3.Color := Channel[3].color ;

     // Set up A/D Converter voltage range selection box
     cbADCVoltageRange.clear ;
     for i := 0 to Form1.SESLabIO.ADCNumVoltageRanges-1 do begin
         Form1.SESLabIO.ADCVoltageRangeIndex := i ;
         cbADCVoltageRange.items.add(
           format(' +/- %.3g V ',[Form1.SESLabIO.ADCVoltageRange] )) ;
         end ;

     // Select the current A/D converter range in use
     MinDiff := 1E30 ;
     for i := 0 to Form1.SESLabIO.ADCNumVoltageRanges-1 do begin
         Form1.SESLabIO.ADCVoltageRangeIndex := i ;
         Diff := Abs(fH.ADCVoltageRange-Form1.SESLabIO.ADCVoltageRange) ;
         if MinDiff >= Diff then begin
            MinDiff := Diff ;
            cbADCVoltageRange.ItemIndex := i
            end ;
         end ;

     ChannelTable.cells[ChNum,0] := 'Ch.' ;
     ChannelTable.ColWidths[ChNum] := ChannelTable.DefaultColWidth div 2 ;

     ChannelTable.cells[ChName,0] := 'Name' ;
     ChannelTable.cells[ChCal,0] := 'V/Units' ;
     ChannelTable.ColWidths[ChCal] := (3 * ChannelTable.DefaultColWidth) div 2 ;
     ChannelTable.cells[ChAmp,0] := 'Amp. Gain' ;
     ChannelTable.ColWidths[ChAmp] := (3 * ChannelTable.DefaultColWidth) div 2 ;
     ChannelTable.cells[ChUnits,0] := 'Units' ;
     ChannelTable.RowCount := FH.NumChannels + 1 ;
     ChannelTable.options := [goEditing,goHorzLine,goVertLine] ;

     { **** CED 1902 amplifier settings **** }

     ckCED1902InUse.Checked := CED1902.InUse ;

     { CED 1902 Communications port list }
     cbCED1902ComPort.clear ;
     cbCED1902ComPort.items.add( ' COM1 ' ) ;
     cbCED1902ComPort.items.add( ' COM2 ' ) ;
     cbCED1902ComPort.ItemIndex := CED1902.ComPort - 1 ;

     GetCED1902Options ;
     ChannelTable.cells[3,1] := Format( '%.2f',[CED1902.GainValue]) ;

     CED1902.DCOffsetVMax := CED1902.DCOffsetRange*1000. ;
     edDCOffset.Value := (CED1902.DCOffset*CED1902.DCOffsetVMax)/OffsetMax ;

     { RMS processor }
     cbRMSFromChannel.clear ;
     for ch := 0 to fH.NumChannels-1 do
         cbRMSFromChannel.items.add(format('Ch.%d %s',[ch,Channel[ch].ADCName])) ;
     cbRMSToChannel.items := cbRMSFromChannel.items ;
     cbHRFromChannel.items := cbRMSFromChannel.items ;
     cbHRToChannel.items := cbRMSFromChannel.items ;

     ckRMSInUse.checked := RMS.InUse ;
     cbRMSFromChannel.itemindex := RMS.FromChannel ;
     cbRMSToChannel.itemindex := RMS.ToChannel ;
     edRMSNumPoints.value := RMS.NumAverage ;

     { Heart rate processor }
     ckHRInUse.checked := HR.InUse ;
     cbHRFromChannel.itemindex := HR.FromChannel ;
     cbHRToChannel.itemindex := HR.ToChannel ;

     { Heartbeat detection threshold }
     edHRThreshold.Value := HR.PercentageThreshold ;

     { Set display mode radio buttons and scale maximum}
     if HR.DisplayHR then begin
        rbDisplayHR.checked := True ;
        edHRMaxScale.Units := 'bpm' ;
        end
     else begin
        rbDisplayRR.checked := True ;
        edHRMaxScale.Units := 's' ;
        end ;
     edHRMaxScale.Value := HR.MaxScale ;
     end ;


procedure TSetupDlg.UpdateParameters ;
begin
     { Set recording parameters }


     if FH.dt < MinDT*fH.NumChannels then FH.dt := MinDT*fH.NumChannels ;
     if FH.dt > MaxDT then FH.dt := MaxDT ;
     EdSamplingInterval.Value := fH.dt ;

     EdNumChannels.Value := fH.NumChannels ;

     { Digital low-pass filter constant }
     edDigitalFilter.text := LPFilterCutOff( fH.DigitalFilter ) ;

     ChColor0.Visible := True ;
     if Fh.NumChannels >= 2 then ChColor1.Visible := True
                            else ChColor1.Visible := False ;
     if Fh.NumChannels >= 3 then ChColor2.Visible := True
                            else ChColor2.Visible := False ;
     if Fh.NumChannels >= 4 then ChColor3.Visible := True
                            else ChColor3.Visible := False ;

     end ;


procedure TSetupDlg.GetCED1902Options ;
{ ------------------------------------------
  Get gain/filter options list from CED 1902
  ------------------------------------------}
var
   i : Integer ;
   OK : Boolean ;
   List : TStringList ;
   CED1902Type : string ;
begin

   edCED1902Type.text := 'Disabled' ;

   CED1902.InUse := ckCED1902InUse.checked ;

   if CED1902.InUse then begin
      { Get lists from CED 1902 }
      try
         List := TStringList.Create ;
         { Open com port to CED 1902 }
         OK := CED1902.OpenLink ;

         { Read gain/filter options }
         if OK then CED1902Type := CED1902.Query( '?IF;' ) ;
         if OK and (CED1902Type <> '') then begin

            { Type of CED 1902 input stage }
            edCED1902Type.text := ' ' ;
            for i := 3 to Length(CED1902Type) do
                edCED1902Type.text := edCED1902Type.text + CED1902Type[i] ;

            { Input list }
            cbCED1902Input.Clear ;
            CED1902.GetList( '?IS;', List ) ;
            for i := 0 to List.Count-1 do cbCED1902Input.Items.Add( List[i] ) ;
            cbCED1902Input.Itemindex := CED1902.Input - 1 ;

            { Gain list }
            cbCED1902Gain.clear ;
            CED1902.GetList( '?GS;', List ) ;
            for i := 0 to List.Count-1 do cbCED1902Gain.Items.Add( ' X' + List[i] ) ;
            cbCED1902Gain.Itemindex := CED1902.Gain - 1 ;

            { Low pass filter list }
            cbCED1902LPFilter.clear ;
            cbCED1902LPFilter.items.add(' None ' ) ;
            CED1902.GetList( '?LS;', List ) ;
            for i := 0 to List.Count-1 do cbCED1902LPFilter.Items.Add( List[i] + ' Hz') ;
            cbCED1902LPFilter.itemindex := CED1902.LPFilter ;

            { High pass filter list }
            cbCED1902HPFilter.clear ;
            cbCED1902HPFilter.items.add(' None ' ) ;
            CED1902.GetList( '?HS;', List ) ;
            for i := 0 to List.Count-1 do cbCED1902HPFilter.Items.Add( List[i] + ' Hz') ;
            cbCED1902HPFilter.itemindex := CED1902.HPFilter ;

            { 50Hz Notch filter }
            if CED1902.NotchFilter = 1 then ckCED1902NotchFilter.checked := True
                                       else ckCED1902NotchFilter.checked := False ;
            {AC/DC Coupling }
            if CED1902.ACCoupled = 1 then ckCED1902ACCoupled.checked := True
                                     else ckCED1902ACCoupled.checked := False ;

            end
         else begin
            CED1902.InUse := False ;
            ckCED1902InUse.Checked := False ;
            edCED1902Type.text := '1902 not available' ;
            end ;
         CED1902.CloseLink ;

      finally
         List.Free ;
         end ;
      end ;

   if not CED1902.InUse then begin
      { Input list }
      cbCED1902Input.clear ;
      cbCED1902Input.Items.Add( ' None ' ) ;
      cbCED1902Input.Itemindex := 0 ;

      { Gain list }
      cbCED1902Gain.clear ;
      cbCED1902Gain.Items.Add( ' X1' ) ;
      cbCED1902Gain.Itemindex := 0 ;

      { Low pass filter list }
      cbCED1902LPFilter.clear ;
      cbCED1902LPFilter.items.add(' None ' ) ;
      cbCED1902LPFilter.itemindex := 0 ;

      { High pass filter list }
      cbCED1902HPFilter.clear ;
      cbCED1902HPFilter.items.add(' None ' ) ;
      cbCED1902HPFilter.itemindex := 0 ;
      end ;

   { CED 1902 settings are disabled if not in use }
   cbCED1902Gain.enabled := ckCED1902InUse.checked ;
   cbCED1902Input.enabled := ckCED1902InUse.checked ;
   cbCED1902LPFilter.enabled := ckCED1902InUse.checked ;
   cbCED1902HPFilter.enabled := ckCED1902InUse.checked ;
   ckCED1902ACCoupled.enabled := ckCED1902InUse.checked ;
   ckCED1902NotchFilter.enabled := ckCED1902InUse.checked ;

   end ;


procedure TSetupDlg.cbCED1902InputChange(Sender: TObject);
{ ---------------------------
  New CED 1902 input selected
  ---------------------------}
var
   List : TStringList ;
   i : Integer ;
   OK : Boolean ;
begin
     { Change the 1902 input setting }
     CED1902.Input := cbCED1902Input.itemIndex + 1;
     CED1902.UpdateAmplifier ;

     { Gain list }
     List := TStringList.Create ;
     try
        OK := CED1902.OpenLink ;
        if OK then begin
           cbCED1902Gain.clear ;
           CED1902.GetList( '?GS;', List ) ;
           for i := 0 to List.Count-1 do cbCED1902Gain.Items.Add( ' X' + List[i] ) ;
           cbCED1902Gain.Itemindex := CED1902.Gain - 1 ;
           end ;
     finally
        List.Free ;
        CED1902.CloseLink ;
        end ;

     { Make sure that the selected gain remains within the new range of values }
     cbCED1902Gain.ItemIndex := MinInt([CED1902.Gain-1,cbCED1902Gain.items.count-1]) ;
     { Update Ch.0 amplifier gain }
     ChannelTable.cells[3,1] := cbCED1902Gain.items[cbCED1902Gain.ItemIndex] ;

     end ;


procedure TSetupDlg.ckCED1902InUseClick(Sender: TObject);
begin
     CED1902.InUse := ckCED1902InUse.Checked ;
     GetCED1902Options ;
     end;


procedure TSetupDlg.cbCED1902GainChange(Sender: TObject);
begin
     { Update Ch.0 amplifier gain }
     if CED1902.InUse then
        ChannelTable.cells[3,1] := cbCED1902Gain.items[cbCED1902Gain.ItemIndex] ;
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
        LPFilterCutoff := format('%.3g Hz',[f1/fH.dt]);

        end
     else LPFilterCutoff := 'No Filter' ;
     end ;


procedure TSetupDlg.rbDisplayRRClick(Sender: TObject);
var
   Value : Single ;
begin
     Value := 2. ;
     edHRMaxScale.text := Format( '%3.1f s', [Value] ) ;
     HR.DisplayHR := False ;
     end;

procedure TSetupDlg.rbDisplayHRClick(Sender: TObject);
var
   Value : Single ;
begin
     Value := 200. ;
     edHRMaxScale.text := Format( '%4.0f bpm', [Value] ) ;
     HR.DisplayHR := True ;
     end;

procedure TSetupDlg.ChColor0Click(Sender: TObject);
begin
     ColorDialog1.execute ;
     TPanel(Sender).color := ColorDialog1.color ;
     end;

procedure TSetupDlg.ChColor0DblClick(Sender: TObject);
begin
     ColorDialog1.execute ;
     TPanel(Sender).color := ColorDialog1.color ;
     end;

procedure TSetupDlg.TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var
   ch : Integer ;
begin
     { If only one channel ... disable special channels }
     if EdNumChannels.Value <= 1 then begin
        ckHRInUse.Checked := False ;
        ckHRInUse.Enabled := False ;
        ckRMSInUse.Checked := False ;
        ckRMSInUse.Enabled := False ;
        end
     else begin
        ckHRInUse.Enabled := True ;
        ckRMSInUse.Enabled := True ;
        end ;

     { Update special page channel selection menus }
     cbRMSFromChannel.clear ;
     for ch := 0 to fH.NumChannels-1 do
         cbRMSFromChannel.items.add(format('Ch.%d %s',[ch,Channel[ch].ADCName])) ;
     cbRMSToChannel.items := cbRMSFromChannel.items ;
     cbRMSFromChannel.ItemIndex := RMS.FromChannel ;
     cbRMSToChannel.ItemIndex := RMS.ToChannel ;
     cbHRFromChannel.items := cbRMSFromChannel.items ;
     cbHRToChannel.items := cbRMSFromChannel.items ;
     cbHRFromChannel.ItemIndex := HR.FromChannel ;
     cbHRToChannel.ItemIndex := HR.ToChannel ;

     end;


procedure TSetupDlg.edDCOffsetKeyPress(Sender: TObject; var Key: Char);
var
   V : single ;
begin
     if key = chr(13) then begin
        V := edDCOffset.Value ;
        V := MinFlt( [MaxFlt([V,-CED1902.DCOffsetVMax]),CED1902.DCOffsetVMax]) ;
        edDCOffset.Value := V ;
        CED1902.DCOffset := Round((OffsetMax*V)/CED1902.DCOffsetVMax ) ;
        end ;
     end;

procedure TSetupDlg.bOKClick(Sender: TObject);
var
   ch : Integer ;
   OldCalibrationFactor,V : Single ;
begin

     { Recording parameters }

     { Note conversion from ms --> s }
     fH.dt := EdSamplingInterval.Value ;

     fH.NumChannels := Round(EdNumChannels.Value ) ;

     // Digital low pass filter factor
     fH.DigitalFilter := udFilterFactor.Position*0.1 ;

     { Channel calibration }

     fH.ADCVoltageRange := ExtractFloat(
                           cbADCVoltageRange.items[cbADCVoltageRange.ItemIndex],
                            fH.ADCVoltageRange ) ;

     for ch := 0 to fH.NumChannels-1 do begin
         Channel[ch].ADCName := ChannelTable.cells[ChName,ch+1] ;


         OldCalibrationFactor := Channel[ch].ADCCalibrationFactor ;
         Channel[ch].ADCCalibrationFactor := ExtractFloat(
                                           ChannelTable.cells[ChCal,ch+1],1. );
         { ADjust channel scaling factor to account for changes in
           user-entered calibration factor }
         Channel[ch].ADCSCale := (Channel[ch].ADCScale * OldCalibrationFactor) /
                                  Channel[ch].ADCCalibrationFactor  ;

         Channel[ch].ADCAmplifierGain := ExtractFloat(
                                       ChannelTable.cells[ChAmp,ch+1],1. );

         Channel[ch].ADCUnits := ChannelTable.cells[ChUnits,ch+1] ;
         end ;

     { Set channel colours }
      Channel[0].color := ChColor0.color ;
      Channel[1].color := ChColor1.color ;
      Channel[2].color := ChColor2.color ;
      Channel[3].color := ChColor3.color ;

     { CED 1902 amplifier }

     CED1902.Input := cbCED1902Input.itemIndex + 1;
     CED1902.Gain := cbCED1902Gain.ItemIndex + 1;
     CED1902.GainValue := ExtractFloat( cbCED1902Gain.items[cbCED1902Gain.ItemIndex],1. );
     CED1902.LPFilter := cbCED1902LPFilter.ItemIndex ;
     CED1902.HPFilter := cbCED1902HPFilter.ItemIndex ;
     if ckCED1902NotchFilter.checked then CED1902.NotchFilter := 1
                                     else CED1902.NotchFilter := 0 ;
     if ckCED1902ACCoupled.checked   then CED1902.ACCoupled := 1
                                     else CED1902.ACCoupled := 0 ;
     if ckCED1902InUse.checked       then CED1902.InUse := True
                                     else CED1902.InUse := False ;

     CED1902.ComPort := cbCED1902ComPort.itemIndex + 1 ;

     { Send new values to CED 1902 }
     if CED1902.InUse then begin
        CED1902.UpdateAmplifier ;
        { Update Ch.0 amplifier gain table}
        ChannelTable.cells[3,1] := cbCED1902Gain.items[cbCED1902Gain.ItemIndex] ;

        end ;

     { Set DC Offset }
     V := ExtractFloat( edDCOffset.text, 0. ) ;
     V := MinFlt( [MaxFlt([V,-CED1902.DCOffsetVMax]),CED1902.DCOffsetVMax]) ;
     CED1902.DCOffset := Trunc((OffsetMax*V)/CED1902.DCOffsetVMax ) ;
     CED1902.DCOffset := MinInt([MaxInt([CED1902.DCOffset,-OffSetMax]),OffSetMax]) ;

     RMS.FromChannel := cbRMSFromChannel.itemindex  ;
     RMS.ToChannel := cbRMSToChannel.itemindex ;
     RMS.NumAverage := Round(edRMSNumPoints.value) ;
     RMS.InUse := ckRMSInUse.checked ;
     if fH.NumChannels <= 1 then begin
        { If only one channel disable RMS calculation }
        RMS.InUse := False ;
        ckRMSInUse.checked := False ;
        end ;
     if RMS.InUse then begin
        Channel[RMS.ToChannel] := Channel[RMS.FromChannel] ;
        Channel[RMS.ToChannel].ADCName := 'RMS' ;
        end
     else if Channel[RMS.ToChannel].ADCName = 'RMS' then begin
         { If channel has been used for RMS result, remove RMS title }
         Channel[RMS.ToChannel].ADCName := 'Ch.' + IntToStr(RMS.ToChannel) ;
        end ;

     { Heart rate processor }
     HR.FromChannel := cbHRFromChannel.itemindex ;
     HR.ToChannel := cbHRToChannel.itemindex ;
     HR.InUse := ckHRInUse.checked ;
     if fH.NumChannels <= 1 then begin
        { If only one channel disable RMS calculation }
        HR.InUse := False ;
        ckHRInUse.checked := False ;
        end ;

      HR.PercentageThreshold := ExtractFloat(edHRThreshold.text,50.0);

     if rbDisplayHR.checked then HR.DisplayHR := True
                            else HR.DisplayHR := False ;

     HR.MaxScale := ExtractFloat( edHRMaxScale.text, HR.MaxScale ) ;
     if HR.InUse then begin

        if HR.DisplayHR then begin
           HR.Scale := (60.*MaxADCValue) / ( HR.MaxScale * fH.dt ) ;
           Channel[HR.ToChannel].ADCUnits := 'bpm' ;
           Channel[HR.ToChannel].ADCName := 'H.R.' ;
           end
        else begin
           HR.Scale := MaxADCValue*fH.dt / HR.MaxScale ;
           Channel[HR.ToChannel].ADCUnits := 's' ;
           Channel[HR.ToChannel].ADCName := 'R-R' ;
           end ;
        Channel[HR.ToChannel].ADCScale := HR.MaxScale / MaxADCValue ;
        Channel[HR.ToChannel].ADCAmplifierGain := 1. ;
        Channel[HR.ToChannel].ADCCalibrationFactor := 1. ;
        Channel[HR.ToChannel].ADCZero := 0 ;
        end
     else if Channel[HR.ToChannel].ADCName = 'H.R.' then
         { If channel has been used for HR result, remove HR title }
         Channel[HR.ToChannel].ADCName := format('Ch.%d',[HR.ToChannel]) ;

     end;





procedure TSetupDlg.cbCED1902ComPortChange(Sender: TObject);
begin
     CED1902.ComPort := cbCED1902ComPort.ItemIndex + 1 ;
     if CED1902.InUse then GetCED1902Options ;
     end;

procedure TSetupDlg.cbHRFromChannelChange(Sender: TObject);
begin
     HR.FromChannel := MaxInt([cbHRFromChannel.ItemIndex,0]) ;
     end;

procedure TSetupDlg.cbHRToChannelChange(Sender: TObject);
begin
     HR.ToChannel := MaxInt([cbHRToChannel.ItemIndex,0]) ;
     end;

procedure TSetupDlg.cbRMSFromChannelChange(Sender: TObject);
begin
     RMS.FromChannel := MaxInt([cbRMSFromChannel.ItemIndex,0]) ;
     end;

procedure TSetupDlg.cbRMSToChannelChange(Sender: TObject);
begin
     RMS.ToChannel := MaxInt([cbRMSToChannel.ItemIndex,0]) ;
     end;

procedure TSetupDlg.edHRThresholdKeyPress(Sender: TObject; var Key: Char);
var
   value : single ;
begin
     if key = chr(13) then begin
         Value := ExtractFloat(edHRThreshold.text,50.0);
         Value := MinFlt([MaxFlt([Value,1.0]),99.0]) ;
         edHRThreshold.text := format('%5.2g %%',[Value]) ;
         end ;
     end;

procedure TSetupDlg.edNumChannelsKeyPress(Sender: TObject; var Key: Char);
begin
     FH.NumCHannels := Round(edNumChannels.Value) ;
     UpdateParameters ;
     end;

procedure TSetupDlg.udFilterFactorClick(Sender: TObject;
  Button: TUDBtnType);
var
   Factor : single ;
begin
     Factor := udFilterFactor.Position*0.1 ;
     EdDigitalFilter.text := LPFilterCutoff( Factor )
     end;

end.
