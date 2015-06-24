unit Maths;
{ 16/8/98 TProb & ZProb added }



interface
uses sysutils, stdctrls ;
function ExtractInt ( CBuf : string ) : longint ;
procedure GetRangeFromEditBox( const ed : TEdit ;
                               var LoValue,HiValue : Single ;
                               Min,Max : Single ;
                               const FormatString : String ;
                               const Units : String ) ;
function ExtractListOfFloats ( const CBuf : string ;
                                var Values : Array of Single ;
                                PositiveOnly : Boolean ) : Integer ;

function MinInt( const Buf : array of LongInt ) : LongInt ;
function MinFlt( const Buf : array of Single ) : Single ;
function MaxInt( const Buf : array of LongInt ) : LongInt ;
function MaxFlt( const Buf : array of Single ) : Single ;
function Log10( const x : Single ) : Single;
function AntiLog10( const x : single ) : Single ;
function GaussianRandom( GSet : Single ) : Single ;
function Power( x,y : Single ) : Single ;
function IntLimitTo( Value, LowerLimit, UpperLimit : Integer ) : Integer ;
function LongIntLimitTo( Value, LowerLimit, UpperLimit : LongInt ) : LongInt ;
function FloatLimitTo( Value, LowerLimit, UpperLimit : Single ) : Single ;
function MakeMultiple( Value, Factor,Step : Integer ) : Integer ;
procedure RealFFT( var Data : Array of single ; n : Integer ; ISign : Integer ) ;
procedure Fourier1( var Data : Array of Single ; NN : Integer ; ISign : Integer ) ;
procedure Sort( var SortBuf, LinkedBuf : Array of single ; nPoints : Integer ) ;
function ZProb( ZIn : single ) : single ;
function TProb( T : single ; Nf : Integer ) : single ;
function SafeExp( x : single ) : single ;
implementation

  const
     MaxSingle = 1E38 ;


function ExtractInt ( CBuf : string ) : longint ;
{ ---------------------------------------------------
  Extract a 32 bit integer number from a string which
  may contain additional non-numeric text
  ---------------------------------------------------}

Type
    TState = (RemoveLeadingWhiteSpace, ReadNumber) ;
var CNum : string ;
    i : integer ;
    Quit : Boolean ;
    State : TState ;

begin
     CNum := '' ;
     i := 1;
     Quit := False ;
     State := RemoveLeadingWhiteSpace ;
     while not Quit do begin

           case State of

                { Ignore all non-numeric characters before number }
                RemoveLeadingWhiteSpace : begin
                   if CBuf[i] in ['0'..'9','+','-'] then State := ReadNumber
                                                    else i := i + 1 ;
                   end ;

                { Copy number into string CNum }
                ReadNumber : begin
                    {End copying when a non-numeric character
                    or the end of the string is encountered }
                    if CBuf[i] in ['0'..'9','E','e','+','-','.'] then begin
                       CNum := CNum + CBuf[i] ;
                       i := i + 1 ;
                       end
                    else Quit := True ;
                    end ;
                else end ;

           if i > Length(CBuf) then Quit := True ;
           end ;
     try


        ExtractInt := StrToInt( CNum ) ;
     except
        ExtractInt := 1 ;
        end ;
     end ;

procedure GetRangeFromEditBox( const ed : TEdit ;
                               var LoValue,HiValue : Single ;
                               Min,Max : Single ;
                               const FormatString : String ;
                               const Units : String ) ;
var
   Values : Array[0..10] of Single ;
   Temp : Single ;
   nValues : Integer ;
begin
     LoValue := Min ;
     HiValue := Max ;
     nValues := ExtractListofFloats( ed.text, Values, True ) ;
     if nValues >=1 then LoValue := Values[0] ;
     if nValues >=2 then HiValue := Values[1] ;
     if LoValue > HiValue then begin
        Temp := LoValue ;
        LoValue := HiValue ;
        HiValue := Temp ;
        end ;
     ed.text := format( FormatString, [LoValue,HiValue] ) + ' ' + Units ;
     end ;


function ExtractListOfFloats ( const CBuf : string ;
                                var Values : Array of Single ;
                                PositiveOnly : Boolean ) : Integer ;
{ -------------------------------------------------------------
  Extract a series of floating point number from a string which
  may contain additional non-numeric text
  ---------------------------------------}

var
   CNum : string ;
   i,nValues : integer ;
   EndOfNumber : Boolean ;
begin
     nValues := 0 ;
     CNum := '' ;
     for i := 1 to length(CBuf) do begin

         { If character is numeric ... add it to number string }
         if PositiveOnly then begin
            { Minus sign is treated as a number separator }
            if CBuf[i] in ['0'..'9', 'E', 'e', '.' ] then begin
               CNum := CNum + CBuf[i] ;
               EndOfNumber := False ;
               end
            else EndOfNumber := True ;
            end
         else begin
            { Positive or negative numbers }
            if CBuf[i] in ['0'..'9', 'E', 'e', '.', '-' ] then begin
               CNum := CNum + CBuf[i] ;
               EndOfNumber := False ;
               end
            else EndOfNumber := True ;
            end ;

         { If all characters are finished ... check number }
         if i = length(CBuf) then EndOfNumber := True ;

         if (EndOfNumber) and (Length(CNum) > 0)
            and (nValues <= High(Values)) then begin
              try
                 Values[nValues] := StrToFloat( CNum ) ;
                 CNum := '' ;
                 Inc(nValues) ;
              except
                    on E : EConvertError do CNum := '' ;
                    end ;
              end ;
         end ;
     { Return number of values extracted }
     Result := nValues ;
     end ;


function MinInt( const Buf : array of LongInt ) : LongInt ;
{ -------------------------------------------
  Return the smallest value in the array 'Buf'
  -------------------------------------------}
var
   i,Min : LongInt ;
begin
     Min := High(Min) ;
     for i := 0 to High(Buf) do
         if Buf[i] < Min then Min := Buf[i] ;
     Result := Min ;
     end ;


function MinFlt( const Buf : array of Single ) : Single ;
{ ---------------------------------------------------------
  Return the smallest value in the floating point  array 'Buf'
  ---------------------------------------------------------}
var
   i : Integer ;
   Min : Single ;
begin
     Min := MaxSingle ;
     for i := 0 to High(Buf) do
         if Buf[i] < Min then Min := Buf[i] ;
     Result := Min ;
     end ;


function MaxInt( const Buf : array of LongInt ) : LongInt ;
{ ---------------------------------------------------------
  Return the largest long integer value in the array 'Buf'
  ---------------------------------------------------------}
var
   Max : LongInt ;
   i : Integer ;
begin
     Max:= -High(Max) ;
     for i := 0 to High(Buf) do
         if Buf[i] > Max then Max := Buf[i] ;
     Result := Max ;
     end ;


function MaxFlt( const Buf : array of Single ) : Single ;
{ ---------------------------------------------------------
  Return the largest floating point value in the array 'Buf'
  ---------------------------------------------------------}
var
   i : Integer ;
   Max : Single ;
begin
     Max:= -MaxSingle ;
     for i := 0 to High(Buf) do
         if Buf[i] > Max then Max := Buf[i] ;
     Result := Max ;
     end ;


function Log10( const x : Single ) : Single ;
{ -----------------------------------
  Return the logarithm (base 10) of x
  -----------------------------------}
begin
     Log10 := ln(x) / ln(10. ) ;
     end ;

function AntiLog10( const x : single )  : Single ;
{ ---------------------------------------
  Return the antilogarithm (base 10) of x
  ---------------------------------------}
begin
     AntiLog10 := exp( x * ln( 10. ) ) ;
     end ;


function GaussianRandom( GSet : Single ) : Single ;
{ -------------------------------------------------------------
  Return a random variable (-1..1) from a gaussian distribution
  -------------------------------------------------------------}
var
        v1,v2,r,fac : Single ;
begin
	if GSet = 1. then begin
            repeat
	          v1 := 2.*random - 1. ;
	          v2 := 2.*random - 1. ;
	          r := v1*v1 + v2*v2 ;
                  until r < 1. ;
	    fac := sqrt( -2.*ln(r)/r);
	    gset := v1*fac ;
	    GaussianRandom := v2*fac ;
            end
	else begin
             GaussianRandom := gset ;
             gset := 1. ;
             end ;
	end ;


function Power( x,y : Single ) : Single ;
{ ----------------------------------
  Calculate x to the power y (x^^y)
  ----------------------------------}
begin
     if x > 0. then Power := exp( ln(x)*y )
               else Power := 0. ;
     end ;



function FloatLimitTo( Value, LowerLimit, UpperLimit : Single ) : Single ;
{ -------------------------------------------------------------------
  Make sure Value is kept within the limits LowerLimit and UpperLimit
  -------------------------------------------------------------------}
begin
     if Value < LowerLimit then Value := LowerLimit ;
     if Value > UpperLimit then Value := UpperLimit ;
     Result := Value ;
     end ;


function IntLimitTo( Value, LowerLimit, UpperLimit : Integer ) : Integer ;
{ -------------------------------------------------------------------
  Make sure Value is kept within the limits LowerLimit and UpperLimit
  -------------------------------------------------------------------}
begin
     if Value < LowerLimit then Value := LowerLimit ;
     if Value > UpperLimit then Value := UpperLimit ;
     Result := Value ;
     end ;


function LongIntLimitTo( Value, LowerLimit, UpperLimit : LongInt ) : LongInt ;
{ -------------------------------------------------------------------
  Make sure Value is kept within the limits LowerLimit and UpperLimit
  -------------------------------------------------------------------}
begin
     if Value < LowerLimit then Value := LowerLimit ;
     if Value > UpperLimit then Value := UpperLimit ;
     Result := Value ;
     end ;

function MakeMultiple( Value, Factor,Step : Integer ) : Integer ;
{ -------------------------------------------------------
  Return nearest (and smaller) integer to "Value" which is
  a multiple of "Factor"
  -------------------------------------------------------}
begin
     Result := (((Value-1) div Factor)+Step)*Factor ;
     end ;


procedure RealFFT( var Data : Array of single ; n : Integer ; ISign : Integer ) ;
{
C	Calculates the FFT of a set of 2N real data points. Replaces
C	this data (in array DATA) by the positive frequency half of its
C	complex Fourier Transform. The real-valued first and last components
C	of the complex transform are returned as elements DATA(1) and DATA(2)
C	respectively. N must be a power of 2.
C	from page 400 ... Numerical Recipes
C}
var
   WR,WI,WPR,WPI,WTEMP,Theta,C1,C2,WRS,WIS,H1R,H1I,H2R,H2I : double ;
   I,J,I1,I2,I3,I4,N2P3 : Integer ;
begin

     Theta := ( 6.28318530717959/2.0 )/ N ;
     C1 := 0.5 ;

     IF ISign = 1  THEN begin
        { Set up for forward transform }
        C2 := -0.5 ;
        Fourier1( Data, N, 1) ;
        end
     ELSE begin
        { Set up for inverse transform }
        C2 := 0.5 ;
        Theta := -Theta ;
        end ;

     WPR := SIN( 0.5 * Theta ) ;
     WPR := -2.0*WPR*WPR ;
     WPI := SIN( Theta ) ;
     WR := 1. + WPR ;
     WI := WPI ;
     N2P3 := 2*N + 3 ;

     for I := 2 to ( (N div 2) + 1) do begin
           I1 := 2*I - 1 ;
           I2 := I1 + 1 ;
           I3 := N2P3 - I2 ;
           I4 := I3 + 1 ;

           WRS := (WR) ;
           WIS := (WI) ;

           H1R :=  C1*( Data[I1] + Data[I3] ) ;
           H1I :=  C1*( Data[I2] - Data[I4] ) ;
           H2R := -C2*( Data[I2] + Data[I4] ) ;
           H2I :=  C2*( Data[I1] - Data[I3] ) ;

           Data[I1] :=  H1R + WRS*H2R - WIS*H2I ;
           Data[I2] :=  H1I + WRS*H2I + WIS*H2R ;
           Data[I3] :=  H1R - WRS*H2R + WIS*H2I ;
           Data[I4] := -H1I + WRS*H2I + WIS*H2R ;

           WTEMP := WR ;
           WR := WR*WPR - WI*WPI + WR ;
           WI := WI*WPR + WTEMP*WPI + WI ;
           end ;

     IF ISign = 1 THEN begin
        H1R := Data[1] ;
        Data[1] := H1R + Data[2] ;
        Data[2] := H1R - Data[2] ;
        end
     ELSE begin
        H1R := Data[1] ;
        Data[1] := C1*(H1R + Data[2]) ;
        Data[2] := C1*(H1R - Data[2]) ;
        Fourier1( Data, N, -1 ) ;
        end ;
     end ;


procedure Fourier1( var Data : Array of Single ; NN : Integer ; ISign : Integer ) ;

{	Replace Data by its discrete Fourier transform, if ISIGN
C	is input as 1, or replaces Data by NN times its inverse DFT
C	if ISIGN is input as -1. Data is a complex array of length NN
C	or, equivalently a REAL array of length 2*NN. NN must be an
C	integer power of 2 }
var
	WR,WI,WPR,WPI,WTEMP,Theta, TempR, TempI : double ;
        I,J,N,M,MMax,IStep : Integer ;
begin
	N := 2*NN ;

	{ Do bit-reversal }
	J := 1 ;
        i := 1 ;
        while i <= n do begin
            IF J > I  THEN begin
               { Exchange complex numbers }
               TEMPR := Data[J] ;
               TEMPI := Data[J+1] ;
               Data[J] := Data[I] ;
               Data[J+1] := Data[I+1] ;
               Data[I] := TEMPR ;
               Data[I+1] := TEMPI ;
               end ;
            M := N div 2 ;

            while (M >= 2) and (J > M) do begin
                  J := J - M ;
                  M := M div 2 ;
                  end ;
            J := J + M ;
            i := i + 2 ;
            end ;

	MMAX := 2 ;
	while  N > MMAX  do begin
               ISTEP := 2*MMAX ;
               Theta := 6.28318530717959 / (ISIGN*MMAX) ;
               WPR := SIN(0.5*Theta) ;
               WPR := -2.0*WPR*WPR ;
               WPI := SIN(Theta) ;
               WR := 1.0 ;
               WI := 0.0 ;
               M := 1 ;
               while M <= MMAX do begin
                        I := M ;
                        while I <= N do begin
				J := I + MMAX ;
				TEMPR := WR*Data[J] - WI*Data[J+1] ;
				TEMPI := WR*Data[J+1] + WI*Data[J] ;
				Data[J] := Data[I] - TEMPR ;
				Data[J+1] := Data[I+1] - TEMPI ;
				Data[I] := Data[I] + TEMPR ;
				Data[I+1] := Data[I+1] + TEMPI ;
                                I := I + ISTEP ;
                                end ;
			WTEMP := WR ;
			WR := WR*WPR - WI*WPI + WR ;
			WI := WI*WPR + WTEMP*WPI + WI ;
                        M := M + 2 ;
                        end ;
               MMAX := ISTEP ;
               end ;
        end ;


procedure Sort( var SortBuf, LinkedBuf : Array of single ; nPoints : Integer ) ;
{ -------------------------------------------------------------
  Sort array "SortBuf" containing "nPoints" data points
  into ascending order. Move matching samples in "LinkedBuf"
  to same array positions
  -------------------------------------------------------------}
var
   Current,Last : Integer ;
   Temp : single ;
begin
     for Last := (nPoints-1) DownTo 1 do begin
         for Current := 0 to Last-1 do begin
             if SortBuf[Current] >  SortBuf[Current+1] then begin
                Temp := SortBuf[Current] ;
                SortBuf[Current] := SortBuf[Current+1] ;
                SortBuf[Current+1] := Temp ;
                Temp := LinkedBuf[Current] ;
                LinkedBuf[Current] := LinkedBuf[Current+1] ;
                LinkedBuf[Current+1] := Temp ;
                end ;
             end ;
         end ;
     end ;


function ZProb( ZIn : single ) : single ;
{ ---------------------------------------------------------------------
  Calculate probability p(z>=ZIn) for normal probability density function
  using Applied Statistics algorithm AS66 (I.D. Hill, 1985)
  Enter with : ZIn = Z value
  ---------------------------------------------------------------------}
var
   b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12 : double ;
   dz,Temp,Prob : Double ;
begin
     { Constants used in approximation equation }
     b1 := 0.398942280385 ;
     b2 := 3.8052E-8 ;
     b3 := 1.00000615302 ;
     b4 := 3.98064794E-4 ;
     b5 := 1.98615381364 ;
     b6 := 0.151679116635 ;
     b7 := 5.29330324926 ;
     b8 := 4.8385912808 ;
     b9 := 15.1508972451 ;
     b10 := 0.742380924027 ;
     b11 := 30.789933034 ;
     b12 := 3.99019417011 ;
     { Calculate probabilty }
     dz := ZIn ;
     Temp := b11 / ( dz + b12 ) ;
     Temp := b9  / ( dz + b10 + Temp ) ;
     Temp := b7  / ( dz + b8 - Temp ) ;
     Temp := b5  / ( dz - b6 + Temp ) ;
     Temp := b3  / ( dz + b4 + Temp ) ;
     Prob := (b1*exp( -dz*dz*0.5 ) ) / ( dz - b2 + Temp ) ;
     Result := Prob ;
     end ;


function TProb( T : single ; Nf : Integer ) : single ;
{ ---------------------------------------------------------------------
  Calculate probability p(t>=TIn,Nf) for T probability density function
  Enter with : TIn = T value
               Nf = degrees of freedom
  ---------------------------------------------------------------------}
var
   dbT, dbNf : double ;
   Z, Prob : single ;
begin
     dbT := T ;
     dbNf := Nf ;
     Z := ( dbNf - (2./3. ) + (0.1/dbNf) ) *
            sqrt( (1./(dbNf - 5./6. )) * ln( 1. + (dbT*dbT)/dbNf ) );
     Prob := ZProb( Z ) ;
     Result := Prob ;
     end ;


function SafeExp( x : single ) : single ;
{ -------------------------------------------------------
  Exponential function which avoids underflow errors for
  large negative values of x
  -------------------------------------------------------}
const
     MinSingle = 1.5E-45 ;
var
   MinX : single ;
begin
     MinX := ln(MinSingle) + 1.0 ;
     if x < MinX then SafeExp := 0.0
                 else SafeExp := exp(x) ;
     end ;


end.
