unit SetupCED;
// -------------------------
// Set up CED 1902 amplifier
// -------------------------
// 19.05.03
// 10.07.03 ... ADCAmplifierGain no longer changed by SetupCED dialog
//              (only changed when Record clicked)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ValEdit, ValidatedEdit, math ;

type
  TSetupCEDFrm = class(TForm)
    CED1902Group: TGroupBox;
    Label11: TLabel;
    ckCED1902InUse: TCheckBox;
    cbCED1902ComPort: TComboBox;
    edCED1902Type: TEdit;
    InputGrp: TGroupBox;
    Label8: TLabel;
    Label1: TLabel;
    cbCED1902Input: TComboBox;
    cbCED1902Gain: TComboBox;
    edDCOffset: TValidatedEdit;
    FilterGrp: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    cbCED1902LPFilter: TComboBox;
    cbCED1902HPFilter: TComboBox;
    ckCED1902NotchFilter: TCheckBox;
    ckCED1902ACCoupled: TCheckBox;
    bOK: TButton;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure cbCED1902ComPortChange(Sender: TObject);
    procedure edDCOffsetKeyPress(Sender: TObject; var Key: Char);
    procedure ckCED1902InUseClick(Sender: TObject);
    procedure cbCED1902InputChange(Sender: TObject);
  private
    { Private declarations }
    procedure GetCED1902Options ;
  public
    { Public declarations }
  end;

const
     OffsetMax = 32767 ;

var
  SetupCEDFrm: TSetupCEDFrm;

implementation

uses use1902, shared, Main;

{$R *.DFM}

procedure TSetupCEDFrm.FormShow(Sender: TObject);
{ ---------------------------------------------------------------------------
  Initialise setup's combo lists and tables with current recording parameters
  ---------------------------------------------------------------------------}
begin

     { **** CED 1902 amplifier settings **** }

     ckCED1902InUse.Checked := CED1902.InUse ;

     { CED 1902 Communications port list }
     cbCED1902ComPort.clear ;
     cbCED1902ComPort.items.add( ' COM1 ' ) ;
     cbCED1902ComPort.items.add( ' COM2 ' ) ;
     cbCED1902ComPort.items.add( ' COM3 ' ) ;
     cbCED1902ComPort.items.add( ' COM4 ' ) ;
     cbCED1902ComPort.ItemIndex := CED1902.ComPort - 1 ;

     // Update settings in CED 1902 amplifier
     // (Must be done before GetCED1902Options to ensure gain list is correct)
     CED1902.UpdateAmplifier ;

     // Get options available in CED 1902
     GetCED1902Options ;

     CED1902.DCOffsetVMax := CED1902.DCOffsetRange*1000. ;
     edDCOffset.Value := (CED1902.DCOffset*CED1902.DCOffsetVMax)/OffsetMax ;

     end ;


procedure TSetupCEDFrm.GetCED1902Options ;
{ ------------------------------------------
  Get gain/filter options list from CED 1902
  ------------------------------------------}
var
   i : Integer ;
   LinkOpen : Boolean ;
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
         LinkOpen := CED1902.OpenLink ;

         { Read gain/filter options }
         if LinkOpen then CED1902Type := CED1902.Query( '?IF;' ) ;
         if LinkOpen and (CED1902Type <> '') then begin

            { Type of CED 1902 input stage }
            edCED1902Type.text := ' ' ;
            for i := 3 to Length(CED1902Type) do
                edCED1902Type.text := edCED1902Type.text + CED1902Type[i] ;

            { Input list }
            cbCED1902Input.Clear ;
            CED1902.GetList( '?IS;', List ) ;
            for i := 0 to List.Count-1 do cbCED1902Input.Items.Add( List[i] ) ;
            cbCED1902Input.Itemindex := Max(CED1902.Input - 1,0) ;

            { Gain list }
            cbCED1902Gain.clear ;
            CED1902.GetList( '?GS;', List ) ;
            for i := 0 to List.Count-1 do cbCED1902Gain.Items.Add( ' X' + List[i] ) ;
            CED1902.Gain := Min(Max(CED1902.Gain,1),List.Count) ;
            cbCED1902Gain.Itemindex := Max(CED1902.Gain - 1,0) ;

            { Low pass filter list }
            cbCED1902LPFilter.clear ;
            cbCED1902LPFilter.items.add(' None ' ) ;
            CED1902.GetList( '?LS;', List ) ;
            for i := 0 to List.Count-1 do cbCED1902LPFilter.Items.Add( List[i] + ' Hz') ;
            cbCED1902LPFilter.itemindex := Max(CED1902.LPFilter,0) ;

            { High pass filter list }
            cbCED1902HPFilter.clear ;
            cbCED1902HPFilter.items.add(' None ' ) ;
            CED1902.GetList( '?HS;', List ) ;
            for i := 0 to List.Count-1 do cbCED1902HPFilter.Items.Add( List[i] + ' Hz') ;
            cbCED1902HPFilter.itemindex := Max(CED1902.HPFilter,0) ;

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
         if LinkOpen then CED1902.CloseLink ;

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

procedure TSetupCEDFrm.bOKClick(Sender: TObject);
// --------------------------------------
// Update settings when OK button clicked
// --------------------------------------
var
   V : Single ;
begin

     { CED 1902 amplifier }
     CED1902.Input := Max(cbCED1902Input.itemIndex,0) + 1;
     CED1902.Gain := Max(cbCED1902Gain.ItemIndex,0) + 1;
     if cbCED1902Gain.ItemIndex >= 0 then begin
         CED1902.GainValue := ExtractFloat( cbCED1902Gain.items[cbCED1902Gain.ItemIndex],1. );
         end
     else CED1902.GainValue := 1.0 ;
     CED1902.LPFilter := Max(cbCED1902LPFilter.ItemIndex,0) ;
     CED1902.HPFilter := Max(cbCED1902HPFilter.ItemIndex,0) ;
     if ckCED1902NotchFilter.checked then CED1902.NotchFilter := 1
                                     else CED1902.NotchFilter := 0 ;
     if ckCED1902ACCoupled.checked   then CED1902.ACCoupled := 1
                                     else CED1902.ACCoupled := 0 ;
     if ckCED1902InUse.checked       then CED1902.InUse := True
                                     else CED1902.InUse := False ;

     CED1902.ComPort := cbCED1902ComPort.itemIndex + 1 ;

     { Send new values to CED 1902 }
     if CED1902.InUse then CED1902.UpdateAmplifier ;

     { Set DC Offset }
     V := ExtractFloat( edDCOffset.text, 0. ) ;
     V := Min( Max(V,-CED1902.DCOffsetVMax),CED1902.DCOffsetVMax) ;
     if CED1902.DCOffsetVMax <> 0.0 then begin
        CED1902.DCOffset := Trunc((OffsetMax*V)/CED1902.DCOffsetVMax ) ;
        end
     else CED1902.DCOffset := 0 ;
     CED1902.DCOffset := Min(Max(CED1902.DCOffset,-OffSetMax),OffSetMax) ;

     end;


procedure TSetupCEDFrm.cbCED1902ComPortChange(Sender: TObject);
// ------------------------------------
// CED 1902 communications port changed
// ------------------------------------
begin
     CED1902.ComPort := cbCED1902ComPort.ItemIndex + 1 ;
     if CED1902.InUse then GetCED1902Options ;
     end;


procedure TSetupCEDFrm.edDCOffsetKeyPress(Sender: TObject; var Key: Char);
// --------------------------
// CED 1902 DC offset changed
// --------------------------
var
   V : single ;
begin
     if key = #13 then begin
        V := edDCOffset.Value ;
        V := MinFlt( [MaxFlt([V,-CED1902.DCOffsetVMax]),CED1902.DCOffsetVMax]) ;
        edDCOffset.Value := V ;
        CED1902.DCOffset := Round((OffsetMax*V)/CED1902.DCOffsetVMax ) ;
        end ;
     end;


procedure TSetupCEDFrm.ckCED1902InUseClick(Sender: TObject);
// --------------------------------
// CED 1902 in use tick box clicked
// --------------------------------
begin
     CED1902.InUse := ckCED1902InUse.Checked ;
     if CED1902.InUse then begin
        if not CED1902.UpdateAmplifier then Exit ;
        end ;
     GetCED1902Options ;
     end;


procedure TSetupCEDFrm.cbCED1902InputChange(Sender: TObject);
{ ---------------------------
  New CED 1902 input selected
  ---------------------------}
var
   List : TStringList ;
   i : Integer ;
begin
     { Change the 1902 input setting }
     CED1902.Input := cbCED1902Input.itemIndex + 1;
     CED1902.UpdateAmplifier ;

     { Get gain list }
     if CED1902.OpenLink then begin
        List := TStringList.Create ;
        cbCED1902Gain.clear ;
        CED1902.GetList( '?GS;', List ) ;
        for i := 0 to List.Count-1 do cbCED1902Gain.Items.Add( ' X' + List[i] ) ;
        CED1902.Gain := Min(Max(CED1902.Gain,1),List.Count) ;
        cbCED1902Gain.Itemindex := Max(CED1902.Gain-1,0) ;
        CED1902.CloseLink ;
        List.Free ;
        end ;

     end ;


end.
