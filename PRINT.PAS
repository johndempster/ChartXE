unit Print;
{ ==========================================================================
  CHART - Printing module (c) J. Dempster, University of Strathclyde 1996-98
  ==========================================================================
  15/10/98 Format %s error on whole file printing fixed }

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,Printers,Global,Shared, Grids, SysUtils, Spin, ValEdit ;

type
  TPrintDlg = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    CalibrationBarTable: TStringGrid;
    GroupBox3: TGroupBox;
    ckShowZeroLevels: TCheckBox;
    Label5: TLabel;
    GroupBox4: TGroupBox;
    FontLab: TLabel;
    cbFonts: TComboBox;
    Label6: TLabel;
    RangeGrp: TRadioGroup;
    rbDisplay: TRadioButton;
    rbWholeFile: TRadioButton;
    edMessage: TEdit;
    bPrint: TButton;
    bCancel: TButton;
    edLeftMargin: TValidatedEdit;
    edTopMargin: TValidatedEdit;
    edRightmargin: TValidatedEdit;
    edBottomMargin: TValidatedEdit;
    edFontSize: TValidatedEdit;
    edLineThickness: TValidatedEdit;
    procedure FormActivate(Sender: TObject);
    procedure rbWholeFileClick(Sender: TObject);
    procedure rbDisplayClick(Sender: TObject);
    procedure tbLeftMarginKeyPress(Sender: TObject; var Key: Char);
    procedure bPrintClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateParameters ;
  public
    { Public declarations }
    StartAtSector : LongInt ;
  end;

procedure PrintHorizontalCursor( Const Chan : TChannel ; Level : Integer ) ;

var
  PrintDlg: TPrintDlg;

implementation

{$R *.DFM}
var
   NumPages : Integer ;


procedure TPrintDlg.FormActivate(Sender: TObject);
{ ---------------------------------
  Initialise Print Record(s) form
  ---------------------------------}
var
   ch : Integer ;
begin

     EdMessage.text := '' ;

     { Fill Fonts list with typefaces available to printer }
     cbFonts.items := printer.fonts ;
     cbFonts.itemindex := cbFonts.items.indexof('Arial') ;
     if cbFonts.itemindex < 0 then  cbFonts.itemindex := 0 ;

     { Fill calibration bar table }

     { Set Column widths }
     CalibrationBarTable.colwidths[0] := PrintDlg.Canvas.TextWidth('XXXXX') ;
     CalibrationBarTable.colwidths[1] := PrintDlg.Canvas.TextWidth('XXXXXXXXX') ;

     CalibrationBarTable.options := [goEditing,goHorzLine,goVertLine] ;
     CalibrationBarTable.RowCount := fH.NumChannels + 1 ;
     CalibrationBarTable.cells[0,0] := 'Time ';

     CalibrationBarTable.cells[1,0] := Format( '%.3g s',
                                       [(Channel[0].xMax - Channel[0].xMin)*0.1 ] ) ;
     for ch := 0 to fH.NumChannels-1 do begin
         CalibrationBarTable.cells[0,ch+1] := Channel[ch].ADCName ;
         if CalibrationBarTable.cells[1,ch+1] = '' then
            CalibrationBarTable.cells[1,ch+1] := Format( '%.3g %s',
                                           [(Channel[ch].yMax - Channel[ch].yMin)
                                           * Channel[ch].ADCScale * 0.1,
                                            CHannel[ch].ADCUnits ] ) ;
         end ;

     edFontSize.Value := Settings.Plot.FontSize ;
     edLeftMargin.Value := Settings.Plot.LeftMargin ;
     edRightMargin.Value := Settings.Plot.RightMargin ;
     edTopMargin.Value := Settings.Plot.TopMargin ;
     edBottomMargin.Value := Settings.Plot.BottomMargin ;
     edLineThickness.Value := Settings.Plot.LineThickness ;

     rbDisplay.checked := True ;
     end;


procedure TPrintDlg.UpdateParameters ;
var
   ch : Integer ;
   Val : single ;
begin

     Val := ExtractFloat( CalibrationBarTable.cells[1,0], 1.0 ) ;
     CalibrationBarTable.cells[1,0] := format( '%.1f s', [Val] ) ;

     for ch := 0 to fH.NumChannels-1 do begin
         Val := ExtractFloat( CalibrationBarTable.cells[1,ch+1], 0.0 ) ;
         CalibrationBarTable.cells[1,ch+1] := format( '%.1f %s',
                                           [Val,Channel[ch].ADCUnits] ) ;
         end ;

     end ;


procedure PrintHorizontalCursor( Const Chan : TChannel ; Level : Integer ) ;
{ Draw dotted horizontal cursor at ADC level 'Level'
  in printer display area defined by  record data channel 'Chan'}
var
   yPix : Integer ;
   OldColor : TColor ;
   OldStyle : TPenStyle ;
   OldMode : TPenMode ;
   OldPenWidth : Integer ;
begin
     with Printer.canvas do begin
          OldColor := pen.color ;
          OldStyle := pen.Style ;
          OldMode := pen.mode ;
          OldPenWidth := Pen.Width ;
          pen.mode := pmMask ;
          pen.style := psDot ;
          pen.Width := 1 ;
          end ;

     yPix := Trunc( Chan.Bottom - (Level - Chan.yMin)*Chan.yScale ) ;
     Printer.canvas.polyline([Point(Chan.Left,yPix),Point(Chan.Right,yPix)]);

     with Printer.canvas do begin
          pen.style := OldStyle ;
          pen.color := OldColor ;
          pen.mode := OldMode ;
          Pen.Width := OldPenWidth ;
          end ;

     end ;


procedure TPrintDlg.rbWholeFileClick(Sender: TObject);
var
   Pages : Single ;
begin
     { Display number of pages to be printed in message window }
     Pages := ((fH.NumSamplesInFile div fH.NumChannels)*fH.dt)/ fH.tDisplay ;
     NumPages := Trunc(Pages) ;
     if (Pages - NumPages) > 0. then NumPages := NumPages + 1 ;
     edMessage.text := format('%d pages',[NumPages]) ;
     end;


procedure TPrintDlg.rbDisplayClick(Sender: TObject);
begin
     { Clear message window }
     NumPages := 1 ;
     edMessage.text := ''
     end;

procedure TPrintDlg.tbLeftMarginKeyPress(Sender: TObject; var Key: Char);
begin
     if key = chr(13) then UpdateParameters ;
     end;


procedure TPrintDlg.bPrintClick(Sender: TObject);
{ -------------------------------------------------
  Print currently displayed chart traces on printer
  -------------------------------------------------}
var
   PrChan : array[0..ChannelLimit] of TChannel ;
   TopMargin,LeftMargin,BottomMargin,RightMargin,TopLine : LongInt ;
   ch, NextCh, i, xPix, yPix,LineSpace,Line,CharWidth,ChanHeight  : LongInt;
   yFirst,ySecond,y : LongInt ;
   FilePointer,BlockSize,nRead,nBlock,Sector : LongInt ;
   PageNum : LongInt ;
   StartPoint,EndPoint : TPoint ;
   x,xStep,BarValue,Gain : Single ;
   OldPenWidth,Tick : LongInt ;
   PreDisplayGain : Array[0..ChannelLimit] of LongInt ;
   ptOld : TPoint ;
   ptFirst :  array[0..ChannelLimit] of TPoint ;
   ptSecond : array[0..ChannelLimit] of TPoint ;
   yMax :     array[0..ChannelLimit] of Integer ;
   yMin :     array[0..ChannelLimit] of Integer ;
   yLast :    array[0..ChannelLimit] of Integer ;
   StartPlot,PageDone,EndOfRun : Boolean ;
begin

     { Disable buttons }
     bPrint.Enabled := false ;
     bCancel.enabled := False ;
     Screen.Cursor := crHourglass ;

     { If print-out of current display is selected, start at first
       displayed sector, otherwise start at beginning of file }
     if rbDisplay.checked then begin
        Sector := StartAtSector ;
        PageNum := 0 ;
        NumPages := 1 ;
        end
     else begin
        Sector := 0 ;
        PageNum := 0 ;
        end ;

     EndOfRun := False ;
     while not EndOfRun do begin

          Printer.BeginDoc ;

          PageNum := PageNum + 1 ;
          edMessage.text := format('Printing ... Page %d of %d',[PageNum,NumPages]) ;

          { Set printer typeface and size }
          printer.canvas.font.name := cbFonts.items[cbFonts.ItemIndex] ;
          Settings.Plot.FontSize := Round(edFontSize.Value) ;
          printer.canvas.font.size := Round(edFontSize.Value) ;

          LineSpace := printer.canvas.textheight( 'X' ) ;
          Tick := LineSpace div 2 ;

          { Define plotting region on page
            Note 5 lines at top for identification text }
          Settings.Plot.TopMargin := edTopMargin.Value ;
          TopLine := PrinterCmToPixels('Y',edTopMargin.Value) ;
          CharWidth := Printer.Canvas.TextWidth('X') ;
          TopMargin := TopLine + 5*LineSpace ;

          Settings.Plot.LeftMargin := edLeftMargin.Value ;
          LeftMargin :=   PrinterCmToPixels('X',edLeftMargin.Value) ;
          Settings.Plot.BottomMargin := edBottomMargin.Value ;
          BottomMargin := PrinterCmToPixels('Y',edBottomMargin.Value) ;
          Settings.Plot.RightMargin := edRightMargin.Value ;
          RightMargin :=  PrinterCmToPixels('X',edRightMargin.Value) ;

          OldPenWidth := Printer.Canvas.Pen.Width ;
          Settings.Plot.LineThickness := Round(edLineThickness.value) ;
          Printer.Canvas.Pen.Width := Settings.Plot.LineThickness ;

          { Print file name & page number}
          Line := TopLine ;
          if rbDisplay.checked then
             Printer.Canvas.TextOut( LeftMargin, Line,'File ... ' + fH.FileName )
          else
             Printer.Canvas.TextOut( LeftMargin, Line,
                                     Format('File ... %s (Page %d of %d)',
                                     [fH.FileName,PageNum,NumPages] ) ) ;

          Line := Line + LineSpace ;
          Printer.Canvas.TextOut( LeftMargin, Line, fH.IdentLine ) ;

         { Set up printer page scaling }
         ChanHeight := (Printer.PageHeight - TopMargin - BottomMargin) div
                        fH.NumChannels ;
         for ch := 0 to fH.NumChannels-1 do begin
             PrChan[ch] := Channel[ch] ;
             PrChan[ch].Left := LeftMargin ;
             PrChan[ch].Right := Printer.PageWidth - RightMargin ;
             PrChan[ch].Top := TopMargin + ch*ChanHeight ;
             PrChan[ch].Bottom := PrChan[ch].Top + ChanHeight ;
             PrChan[ch].xMin := (Sector*NumSamplesPerSector)*fH.dt /
                                fH.NumChannels ;
             PrChan[ch].xMax := PrChan[ch].xMin + fH.tDisplay ;
             PrChan[ch].xScale := (PrChan[ch].Right - PrChan[ch].Left) /
                                (PrChan[ch].xMax  - PrChan[ch].xMin ) ;
             PrChan[ch].yScale := (PrChan[ch].Bottom - PrChan[ch].Top) /
                                (PrChan[ch].yMax   - PrChan[ch].yMin ) ;

             { Get real<->A/D units scaling factor from first value in
               gain change list }
             PrChan[ch].ADCScale := GainChanges.Scale[ch+1] /
                                    PrChan[ch].ADCCalibrationFactor ;
             { If this is the heart rate channel replace scale factor }
             if (ch = HR.ToChannel) and HR.InUse then
                  PrChan[Hr.ToChannel].ADCScale := HR.MaxScale/MaxADCValue ;

             end ;

         {Determine starting file pointer and min/max block sizes }
         { The A/D sample stream stored on file is condensed down into
           a series of points no more than the number of horizontal
           pixels available for display }

         FilePointer := Sector*NumBytesPerSector + fH.NumBytesInHeader ;
         x := PrChan[0].xMin ;
         Blocksize := Trunc(fH.tDisplay/(fH.dt*(PrChan[0].Right-PrChan[0].Left)))
                      * fH.NumChannels ;
         BlockSize := MaxInt( [BlockSize,fH.NumChannels] ) ;
         xStep := ( BlockSize div fH.NumChannels ) * fH.dt ;

         { Initialise display pointers }
         i := NumSamplesPerSector ;
         NextCh := fH.NumChannels-1 ;
         for ch := 0 to fH.NumChannels-1 do begin
             yMax[ch] := MinADCValue ;
             yMin[ch] := MaxADCValue ;
             end ;

         { Plot out points }
         StartPlot := True ;
         PageDone := False ;
         while (not PageDone) do begin

               { If needed - Read next buffer-full of data from file }
               if i >= NumSamplesPerSector then begin
                  nRead := FileSeek( fH.FileHandle, FilePointer, 0 ) ;
                  nRead := FileRead( fH.FileHandle, ADC^, NumBytesPerSector ) ;
                  FilePointer := FilePointer + NumBytesPerSector ;
                  Sector := Sector + 1 ;
                  if FilePointer >= (fH.NumSamplesInFile*2 + fH.NumBytesInHeader) then begin
                     PageDone := True ;
                     EndOfRun := True ;
                     end ;
                  i := 0 ;
                  end ;

               { Apply recursive low-pass digital filter }
               y := Trunc( (fH.DigitalFilter * ADC^[i]) +
                    ((1.-fH.DigitalFilter) * yLast[NextCh]) ) ;
               yLast[NextCh] := y ;

               { Update Min./Max. of block }
               If y <= YMin[NextCh] Then YMin[NextCh] := y ;
               If y >= YMax[NextCh] Then YMax[NextCh] := y ;
               i := i + 1 ;
               NextCh := NextCh - 1 ;
               if NextCh < 0 then NextCh := Fh.NumChannels - 1 ;
               nBlock := nBlock + 1 ;

               { If block done ... plot point }
               if nBlock >= Blocksize Then begin
                  x := x + xStep ;

                  if x >= PrChan[0].xmax then PageDone := True ;

                  xPix := Trunc( PrChan[0].xScale*
                          (x - PrChan[0].xMin) + PrChan[0].Left) ;

                  for ch := 0 to fH.NumChannels-1 do begin

                      { Keep traces within limits of their part of display area }
                      if yMin[ch] < Trunc(PrChan[ch].yMin) then yMin[ch] :=
                                                           Trunc(Channel[ch].yMin) ;
                      if yMax[ch] < Trunc(PrChan[ch].yMin) then yMax[ch] :=
                                                           Trunc(Channel[ch].yMin) ;
                      if yMin[ch] > Trunc(PrChan[ch].yMax) then yMin[ch] :=
                                                           Trunc(Channel[ch].yMax) ;
                      if yMax[ch] > Trunc(PrChan[ch].yMax) then yMax[ch] :=
                                                           Trunc(PrChan[ch].yMax) ;

                      { Put Min/Max. into correct order ... consistent with
                        previous block }
                      ySecond := ptSecond[ch].y ;
                      If ySecond < yMin[ch] Then begin
                         yFirst := yMin[ch] ;
                         ySecond := yMax[ch] ;
                         end
                      else begin
                         yFirst := yMax[ch] ;
                         ySecond := yMin[ch] ;
                         end ;

                      { Plot min/max limits for block }

                      ptOld := ptSecond[ch] ;
                      ptFirst[ch] := Point( xPix, Trunc( PrChan[ch].Bottom -
                                 PrChan[ch].yScale*(yFirst - PrChan[ch].yMin)) );
                      ptSecond[ch] := Point( xPix, Trunc( PrChan[ch].Bottom -
                                 PrChan[ch].yScale*(ySecond - PrChan[ch].yMin)) );
                      if StartPlot then begin
                         ptOld := ptFirst[ch] ;
                         if ch = fH.NumChannels-1 then StartPlot := False ;
                         end ;
                      Printer.canvas.polyline( [ptOld,ptFirst[ch],ptSecond[ch]] ) ;

                      yMax[ch] := MinADCValue ;
                      yMin[ch] := MaxADCValue ;
                      end ;

                  nBlock := 0 ;
                  end ;
               end ;

         { Print zero level cursor(s) }

         If ckShowZeroLevels.checked then
            for ch := 0 to fH.NumChannels-1 do
                PrintHorizontalCursor( PrChan[ch], PrChan[ch].ADCZero ) ;

         { Print gain change list (Note : start's at fH.NumChannels+1 to
           exclude first gain setting of file which would be always X1 anyway }

         for ch := 0 to fH.Numchannels-1 do PreDisplayGain[ch] := 0 ;
         for i := fH.NumChannels+1 to GainChanges.Num  do begin

             { Store the last gain change record which has occured *BEFORE*
               the displayed region of the recording }
             if GainChanges.Time[i] <= PrChan[0].xMin then
                PreDisplayGain[GainChanges.Channel[i]] := i ;

             { Print the gain changes which occurred *DURING* the displayed region }
             if (GainChanges.Time[i] >= PrChan[0].xMin) and
                (GainChanges.Time[i] <= PrChan[0].xMax) then begin

                xPix := Trunc( PrChan[0].xScale*(GainChanges.Time[i]
                            - PrChan[0].xMin) + PrChan[0].Left ) ;
                yPix := Trunc( PrChan[GainChanges.Channel[i]].Bottom
                            - Printer.canvas.TextHeight('X'));
                try Gain := GainChanges.Scale[GainChanges.Channel[i]+1] /
                            GainChanges.Scale[i] ;
                except
                    on EZeroDivide do Gain := 1. ;
                    end ;
                if Gain > 0.99 then Printer.canvas.TextOut( xPix,yPix,
                                    format('x%d',[Trunc( Gain+0.1 )]) )
                else Printer.canvas.TextOut( xPix,yPix,
                     format('x1/%d',[Trunc(1./Gain+0.1 )]) ) ;
                end ;
             end ;

         { Display the effects of any gain changes previous to the start of
           the displayed region at the left edge of the display area }

         for ch := 0 to fH.NumChannels-1 do begin
             if PreDisplayGain[ch] <> 0 then begin
                xPix := PrChan[ch].Left ;
                yPix := Trunc( PrChan[ch].Bottom - Printer.canvas.TextHeight('X'));
                try Gain := GainChanges.Scale[GainChanges.Channel[PreDisplayGain[ch]]+1] /
                            GainChanges.Scale[PreDisplayGain[ch]] ;
                except
                    on EZeroDivide do gain := 1. ;
                    end ;
                if Gain > 0.99 then Printer.canvas.TextOut( xPix,yPix,
                                    format('x%d',[Trunc( Gain+0.1 )]) )
                else Printer.canvas.TextOut( xPix,yPix,
                     format('x1/%d',[Trunc(1./Gain+0.1 )]) ) ;
                end ;
             end ;


         { Plot name and calibration bar of channel }
         for ch := 0 to fH.NumChannels-1 do begin

             Printer.Canvas.TextOut( PrChan[ch].Left -
                                 printer.canvas.textwidth(PrChan[ch].ADCName)
                                 - printer.canvas.textwidth(' ') div 2,
                                (PrChan[ch].Top + PrChan[ch].Bottom) div 2,
                                 PrChan[ch].ADCName ) ;

             { Plot Calibration bar beside channel }

             BarValue := ExtractFloat( CalibrationBarTable.Cells[1,ch+1], 0. ) ;
             if BarValue > 0. then begin
                CalibrationBarTable.Cells[1,ch+1] := Format('%.3g %s',
                                                     [BarValue,PrChan[ch].ADCUnits]) ;
                StartPoint := Point(PrChan[ch].Left - 5*CharWidth, PrChan[ch].Bottom) ;

                { Calculate size of bar }
                EndPoint := Point( StartPoint.x, StartPoint.y -
                               Trunc( BarValue*PrChan[ch].yScale /
                               PrChan[ch].ADCScale ) ) ;
                Printer.Canvas.Polyline( [StartPoint,EndPoint] ) ;

                { Ticks at end of bar }
                Printer.Canvas.Polyline( [Point(StartPoint.x-Tick,StartPoint.y),
                                      Point(StartPoint.x+Tick,StartPoint.y) ]);

                Printer.Canvas.Polyline( [Point(EndPoint.x+Tick,EndPoint.y),
                                      Point(EndPoint.x-Tick,EndPoint.y) ]);
                { Size of bar }
                Printer.Canvas.TextOut( StartPoint.X -
                Printer.Canvas.TextWidth(CalibrationBarTable.Cells[1,ch+1]) div 2,
                                  StartPoint.Y + LineSpace,
                                  CalibrationBarTable.Cells[1,ch+1] ) ;
                end ;
             end ;

         { Plot markers (if any) }

         for i := 1 to Markers.Num do begin
             if ( Markers.Time[i] >= PrChan[0].xMin ) and
                ( Markers.Time[i] <= PrChan[0].xMax ) then begin
                yPix := Printer.PageHeight - BottomMargin ;
                xPix := Trunc( PrChan[0].xScale *(Markers.Time[i] - PrChan[0].xMin)
                           + PrChan[0].Left) ;
                Printer.canvas.textout( xPix, yPix, Markers.text[i] ) ;
                end ;
             end ;


         { Time calibration bar }

         BarValue := ExtractFloat( CalibrationBarTable.Cells[1,0], 0. ) ;
         if BarValue > 0. then begin
            CalibrationBarTable.Cells[1,0] := Format('%.3g s', [BarValue] ) ;

            StartPoint := Point( LeftMargin,
                          Printer.PageHeight - BottomMargin + LineSpace) ;
            EndPoint :=   Point( StartPoint.x + Trunc( BarValue*PrChan[0].xScale ) ,
                                 StartPoint.y ) ;
            Printer.Canvas.Polyline( [StartPoint,EndPoint] ) ;
            { Ticks at end of bar }

            Printer.Canvas.Polyline( [Point(StartPoint.x,StartPoint.y+Tick),
                                      Point(StartPoint.x,StartPoint.y-Tick) ]);
            Printer.Canvas.Polyline( [Point(EndPoint.x,EndPoint.y+Tick),
                                      Point(EndPoint.x,EndPoint.y-Tick) ]);
            { Value of calibration bar }
            Printer.Canvas.TextOut( StartPoint.X, StartPoint.Y + LineSpace,
                                    CalibrationBarTable.Cells[1,0] ) ;
            end ;

         { Print program ident. and date/time at bottom of page }
          printer.canvas.font.size := 8 ;

         LineSpace := printer.canvas.TextHeight('X') ;
         Printer.Canvas.TextOut( Printer.PageWidth div 20,
                                 Printer.PageHeight - 2*LineSpace,
                                 format('%s %s',
                                 [ProgName,DateTimeToStr(Now)] ) ) ;

         Printer.EndDoc ;

         { Terminate printing if at end of file OR if only currently
           displayed screen is to be printed }
         if rbDisplay.Checked or
            (Sector*NumSamplesPerSector >= fH.NumSamplesInFile ) then
                         EndofRun := True ;

         end ;

       { Re-Activate buttons }
     bPrint.enabled := True ;
     bCancel.enabled := True ;
     { Restore cursor to normal }
     Screen.Cursor := crDefault ;

     end;


end.
