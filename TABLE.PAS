unit Table;
// ---------------------------------------------
// CHART - Measurements table display dialog box
// ---------------------------------------------
// 20.5.03

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Grids, Shared, ClipBrd;

type
  TTabForm = class(TForm)
    Table: TStringGrid;
    bCopy: TButton;
    bClear: TButton;
    procedure bClearClick(Sender: TObject);
    procedure bCopyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TabForm: TTabForm;

implementation

uses Main;

{$R *.DFM}
procedure TTabForm.FormShow(Sender: TObject);
// -----------------------------------------
// Initialise table when form first displayed
// ------------------------------------------
var
     ch : Integer ;
begin
     if Table.RowCount > 1 then begin
        Table.FixedRows := 1 ;
        Table.ColCount := MainFrm.scDisplay.NumChannels + 1 ;
        Table.Cells[0,0] := 'Time (' + MainFrm.TUnits + ')' ;
        for ch := 0 to MainFrm.scDisplay.NumChannels-1 do
            Table.Cells[ch+1,0] := MainFrm.scDisplay.ChanName[ch]
                                   + ' (' + MainFrm.scDisplay.ChanUnits[ch] + ')' ;
        end ;
     end;


procedure TTabForm.bClearClick(Sender: TObject);
// ------------------------
// Clear measurements table
// ------------------------
begin
     Table.RowCount := 0 ;
     end;


procedure TTabForm.bCopyClick(Sender: TObject);
// -----------------------------------
// Copy meaurements table to clipboard
// -----------------------------------
var
   CopyBuf0,Line0 : PChar ;
   Line : String ;
   BufSize,Row : LongInt ;
begin
try
     screen.cursor := crHourglass ;
     BufSize := MinInt([Table.ColCount*12*Table.RowCount,64000]) ;
     CopyBuf0 := StrAlloc( BufSize ) ;
     StrPCopy( CopyBuf0, ' ' ) ;
     Line0 := StrAlloc(  256 ) ;
     for Row := 1 to Table.RowCount-1 do begin
         Line := Table.Cells[0,Row] + chr(9) +
                 Table.Cells[1,Row] + chr(9) +
                 Table.Cells[2,Row] + chr(13) + chr(10) ;
         StrPCopy( Line0, Line ) ;
         StrCat( CopyBuf0, Line0 ) ;
         end ;
     ClipBoard.SetTextBuf( CopyBuf0 ) ;
finally
     StrDispose( Line0 ) ;
     StrDispose( CopyBuf0 ) ;
     screen.cursor := crDefault ;
     end;
end ;


end.
