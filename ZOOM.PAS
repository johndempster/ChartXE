unit Zoom;
{ =========================================================
  CHART - Display magnification adjustment module
  (c) J. Dempster, University of Strathclyde 1996-98
  23/8/98 OK and cancel buttons changed to standard buttons
  =========================================================}

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Global, Shared, SysUtils ;

type
  TZoomFrm = class(TForm)
    pbDisplay: TPaintBox;
    cbChannels: TComboBox;
    Label1: TLabel;
    lbTMin: TLabel;
    lbTMax: TLabel;
    bOK: TButton;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure pbDisplayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbDisplayMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbChannelsChange(Sender: TObject);
    procedure bOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ZoomFrm: TZoomFrm;

implementation

{$R *.DFM}

type
TMousePos = ( TopLeft,
              TopRight,
              BottomLeft,
              BottomRight,
              MLeft,
              MRight,
              MTop,
              MBottom,
              MDrag ) ;

var
   ZoomCh : TChannel ;
   ZoomBox : TRect ;
   MousePos : TMousePos ;
   MoveZoomBox : Boolean ;
   ChOnDisplay : LongInt ;
   XOld,YOld : Integer ;

procedure TZoomFrm.FormActivate(Sender: TObject);
{ --------------------------------------
  Initialisations when form is displayed
  --------------------------------------}
var
   ch : Integer ;
begin
     { Fill channel selection list }
     cbChannels.Clear ;
     for ch := 0 to fH.NumChannels-1 do
          cbChannels.items.add( ' ' + Channel[ch].ADCName ) ;
    { Start with channel 0 selected }
    ChOnDisplay := Curs.Channel ;
    cbChannels.ItemIndex := ChOnDisplay ;

    { Set scaling for the channel to be worked on }

    ZoomCh := Channel[ChOnDisplay] ;
    ZoomCh.Left := pbDisplay.Width div 50 ;
    ZoomCh.Right := pbDisplay.Width - ZoomCh.Left;
    ZoomCh.Top := pbDisplay.Height div 50 ;
    ZoomCh.Bottom := pbDisplay.Height - ZoomCh.Top ;

    ZoomCh.yMin := MinADCValue  ;
    ZoomCh.yMax := MaxADCValue  ;


    pbDisplay.Refresh ;
    MoveZoomBox := False ;

    end;


procedure TZoomFrm.FormPaint(Sender: TObject);
var
   i,ch : LongInt ;
   xPix,yPix,yFirst,ySecond : Integer ;
   Rect : TRect ;

begin

     Ch := cbChannels.ItemIndex ;
     ChOnDisplay := Ch ;

     { Erase Display }
     pbDisplay.canvas.brush.color := clWhite ;
     Rect := Bounds(0,0,pbDisplay.width,pbDisplay.height) ;
     pbDisplay.canvas.fillrect(Rect);

     { Set trace colour }

     pbDisplay.canvas.pen.color := ZoomCh.color ;

     { Set scaling }
     ZoomCh.xScale := (ZoomCh.Right - ZoomCh.Left) / (ZoomCh.xMax - ZoomCh.xMin ) ;
     ZoomCh.yScale := (ZoomCh.Bottom - ZoomCh.Top) / (ZoomCh.yMax - ZoomCh.yMin ) ;

     { Set size of zoom box }

     ZoomBox.Left :=  Trunc((Channel[ch].xMin - ZoomCh.xMin)*ZoomCh.xScale)
                      + ZoomCh.Left ;
     ZoomBox.Right := Trunc((Channel[ch].xMax - ZoomCh.xMin)*ZoomCh.xScale)
                       + ZoomCh.Left ;
     ZoomBox.Top := ZoomCh.Bottom -
                     Trunc((Channel[ch].yMax - ZoomCh.yMin)*ZoomCh.yScale) ;
     ZoomBox.Bottom := ZoomCh.Bottom -
                     Trunc((Channel[ch].yMin - ZoomCh.yMin)*ZoomCh.yScale) ;

     { Display labels }

     lbTMin.caption := Format( '%5.4g s', [ZoomCh.xMin] ) ;
     lbTMax.caption := Format( '%5.4g s', [ZoomCh.xMax] ) ;
     lbTmin.left := pbDisplay.Left ;
     lbTmin.top := pbDisplay.Top + pbDisplay.Height + 2 ;
     lbTMax.Left := pbDisplay.Left + pbDisplay.width - lbTmax.width ;
     lbTmax.top := lbTmin.top ;

     { Plot channel}


     ySecond := PlayBuf^.yMin[ch,0] ;
     for i := 0 to PlayBuf^.nPoints-1 do begin

             { Determine order Min/Max points are to be plotted }

             If ( ySecond < PlayBuf^.yMin[ch,i] ) Then begin
                yFirst := PlayBuf^.yMin[ch,i] ;
                ySecond := PlayBuf^.yMax[ch,i] ;
                end
             else begin
                yFirst := PlayBuf^.yMax[ch,i] ;
                ySecond := PlayBuf^.yMin[ch,i] ;
                end ;

             { Plot pair of points }

             xPix := Trunc( ZoomCh.xScale*
             (PlayBuf^.x[i] - ZoomCh.xMin) + ZoomCh.Left) ;
             yPix := Trunc( ZoomCh.Bottom -
                            ZoomCh.yScale*(yFirst - ZoomCh.yMin));
             if i = 0 then pbDisplay.canvas.moveto(xPix,yPix)
                      else pbDisplay.canvas.lineto(xPix,yPix);
             yPix := Trunc( ZoomCh.Bottom -
                            ZoomCh.yScale*(ySecond - ZoomCh.yMin));
             pbDisplay.canvas.LineTo( xPix, yPix ) ;
             end ;

     pbDisplay.canvas.DrawFocusRect( ZoomBox ) ;

     MoveZoomBox := False ;
     end ;


procedure TZoomFrm.pbDisplayMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     MoveZoomBox := True ;
     end;

procedure TZoomFrm.pbDisplayMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
const
     Margin = 10 ;
     ZoomMin = 10 ;
var
   Height,Width : LongInt ;
begin

     { Find MousePos of mouse relative to Zoom box
       and change mouse cursor shape appropriately }

     if not MoveZoomBox then begin

        if (Abs(Y - ZoomBox.Top) < Margin) and
              (X <= ZoomBox.Right) and (X >= ZoomBox.Left ) then begin
            pbDisplay.Cursor := crSizeNS ;
            MousePos := MTop ;
            end
        else if (Abs(Y - ZoomBox.Bottom) < Margin ) and
               (X <= ZoomBox.Right) and (X >= ZoomBox.Left ) then begin
            pbDisplay.Cursor := crSizeNS ;
            MousePos := MBottom ;
            end
        else if (ZoomBox.Bottom > Y) and (Y > ZoomBox.Top) and
                (ZoomBox.Right > X) and (X > ZoomBox.Left) then begin
            pbDisplay.Cursor := CrSize ;
            MousePos := MDrag ;
            XOld := X ;
            YOld := Y ;
            end
        else
            pbDisplay.Cursor := crDefault ;

        end
     else if MoveZoomBox then begin

          pbDisplay.canvas.DrawFocusRect( ZoomBox ) ;

          { Move the part of the zoom box which is under the mouse }

          case MousePos of
          MTop : Begin
              if (ZoomBox.Bottom-Y) > ZoomMin then ZoomBox.Top := Y ;
              end ;
          MBottom : Begin
              if (Y - ZoomBox.Top) > ZoomMin then ZoomBox.Bottom := Y ;
              end ;
          MDrag : begin
              Width := ZoomBox.Right - ZoomBox.Left ;
              Height := ZoomBox.Bottom - ZoomBox.Top ;
              ZoomBox.Left := MaxInt( [ZoomBox.Left + (X - XOld),ZoomCh.Left]) ;
              ZoomBox.Right := MinInt( [ZoomBox.Left + Width,ZoomCh.Right]) ;
              ZoomBox.Left := ZoomBox.Right - Width ;
              ZoomBox.Top := MaxInt( [ZoomBox.Top + (Y - YOld),ZoomCh.Top]) ;
              ZoomBox.Bottom := MinInt( [ZoomBox.Top + Height,ZoomCh.Bottom]) ;
              ZoomBox.Top := ZoomBox.Bottom - Height ;
              XOld := X ;
              YOld := Y ;
              end
          else
          end ;

          { Keep within bounds }

          ZoomBox.Left :=    MaxInt( [ZoomBox.Left,ZoomCh.Left] ) ;
          ZoomBox.Left :=    MinInt( [ZoomBox.Left,ZoomCh.Right] ) ;
          ZoomBox.Right :=   MaxInt( [ZoomBox.Right,ZoomCh.Left] ) ;
          ZoomBox.Right :=   MinInt( [ZoomBox.Right,ZoomCh.Right] ) ;
          ZoomBox.Top :=     MaxInt( [ZoomBox.Top,ZoomCh.Top] ) ;
          ZoomBox.Top :=     MinInt( [ZoomBox.Top,ZoomCh.Bottom] ) ;
          ZoomBox.Bottom :=  MaxInt( [ZoomBox.Bottom,ZoomCh.Top] ) ;
          ZoomBox.Bottom :=  MinInt( [ZoomBox.Bottom,ZoomCh.Bottom] ) ;

          pbDisplay.canvas.DrawFocusRect( ZoomBox ) ;
          end ;

     end ;

procedure TZoomFrm.pbDisplayMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     MoveZoomBox := False ;
     end;


procedure TZoomFrm.cbChannelsChange(Sender: TObject);
begin

     Channel[ChOnDisplay].xMin := ((ZoomBox.Left - ZoomCh.Left) / ZoomCh.xScale)
                                  + ZoomCh.xMin ;
     Channel[ChOnDisplay].xMax := ((ZoomBox.Right - ZoomCh.Left) / ZoomCh.xScale)
                                  + ZoomCh.xMin ;
     Channel[ChOnDisplay].yMin := ((ZoomCh.Bottom - ZoomBox.Bottom) / ZoomCh.yScale)
                                  + ZoomCh.yMin ;
     Channel[ChOnDisplay].yMax := ((ZoomCh.Bottom - ZoomBox.Top) / ZoomCh.yScale)
                                  + ZoomCh.yMin ;

     { If the channel number has changed re-plot the display }
     pbDisplay.Refresh
     end;

procedure TZoomFrm.bOKClick(Sender: TObject);
{ ----------------------------------------
  Accept new display magification settings
  ----------------------------------------}
var
   ch : Integer ;
begin
     Ch := cbChannels.itemindex ;

     Channel[ch].xMin := ((ZoomBox.Left - ZoomCh.Left) / ZoomCh.xScale)
                         + ZoomCh.xMin ;
     Channel[ch].xMax := ((ZoomBox.Right - ZoomCh.Left) / ZoomCh.xScale)
                         + ZoomCh.xMin ;
     Channel[ch].yMin := ((ZoomCh.Bottom - ZoomBox.Bottom) / ZoomCh.yScale)
                         + ZoomCh.yMin ;
     Channel[ch].yMax := ((ZoomCh.Bottom - ZoomBox.Top) / ZoomCh.yScale)
                         + ZoomCh.yMin ;
     end;

end.
