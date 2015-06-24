unit EditMarkers;
// -------------------------------------
// CHART - Edit chart markers dialog box
// -------------------------------------
// 20.05.03
// 14.11.05 Table of markers can now be edited
// 10.08.06 Error when all markers deleted fixed

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, math ;

type
  TEditMarkersFrm = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    GroupBox1: TGroupBox;
    Table: TStringGrid;
    bDeleteMarker: TButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bDeleteMarkerClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditMarkersFrm: TEditMarkersFrm;

implementation

uses Main, shared ;

{$R *.dfm}

procedure TEditMarkersFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
var
     i : Integer ;
     t : Single ;
begin

     Table.RowCount := Max(MainFrm.MarkerList.Count +1,1) ;
     Table.Cells[0,0] := 'Time (' + MainFrm.TUnits + ')' ;
     Table.Cells[1,0] := 'Text' ;
     if Table.RowCount > 1 then Table.FixedRows := 1 ;

     for i := 0 to MainFrm.MarkerList.Count-1 do begin
         t := Single(MainFrm.MarkerList.Objects[i]) ;
         Table.Cells[0,i+1] := format( '%.4g',[t]) ;
         Table.Cells[1,i+1] := MainFrm.MarkerList.Strings[i] ;
         end ;

     end;


procedure TEditMarkersFrm.bOKClick(Sender: TObject);
// ------------------
// Update marker list
// ------------------
var
     i : Integer ;
     t : Single ;
begin

     MainFrm.MarkerList.Clear ;
     for i := 1 to Table.RowCount-1 do begin
         t := ExtractFloat( Table.Cells[0,i], -1.0 ) ;
         if t >= 0.0 then begin
            MainFrm.MarkerList.AddObject( Table.Cells[1,i], TObject(t) ) ;
            end ;
         end ;
     end;


procedure TEditMarkersFrm.bDeleteMarkerClick(Sender: TObject);
// ----------------------
// Delete selected marker
// ----------------------
var
     i : Integer ;
begin
     for i := Table.Row to Table.RowCount-2 do begin
         Table.Cells[0,i] := Table.Cells[0,i+1] ;
         Table.Cells[1,i] := Table.Cells[1,i+1] ;
         end ;
     Table.RowCount := Table.RowCount - 1 ;

     end;

end.
