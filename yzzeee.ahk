; ----------------------------------------------------------- Opacity
; [Win+A] Toggle always on top
#a::  Winset, Alwaysontop, , A

; [Win+WheelUp] Increase opacity
#WheelUp::
    DetectHiddenWindows, on
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255
    newtrans := curtrans + 8
    if newtrans > 0
    {
        WinSet, Transparent, %newtrans%, A
    }
    else
    {
        WinSet, Transparent, OFF, A
        WinSet, Transparent, 255, A
    }
return

; [Win+WheelDown] Decrease opacity
#WheelDown::
    DetectHiddenWindows, on
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255
    newtrans := curtrans - 8
    if newtrans > 0
    {
        WinSet, Transparent, %newtrans%, A
    }
return

; [Win+O] Set opacity 50%
#o::
    WinSet, Transparent, 127, A
return

; [Ctrl+Win+O] Reset opacity
^#o::
    WinSet, Transparent, 255, A
    WinSet, Transparent, OFF, A
return

; ----------------------------------------------------------- 한영변환
; 스페이스로 한영 한줄 바꾸기
Key=<#SPACE
hotkey,%Key%,sub,on
return
<#SPACE::
{
sub:
clipboard=
send,{shiftdown}{home}{shiftup}
send,^x
clipwait,1
 
if ErrorLevel
return
 
SourceText=%clipboard%
StringLen,length,SourceText
lang:=
loop,%length%
{
StringMid,chchr,SourceText,%A_Index%,1
chasc:=asc(chchr)
if (65<=chasc) and (chasc<=90)
{
lang=english
break
}
if (97<=chasc) and (chasc<=122)
{
lang=english
break
}
else
{
Send, {vk15scF2}
표 := "r,R,s,e,E,f,a,q,Q,t,T,d,w,W,c,z,x,v,g,k,o,i,O,j,p,u,P,h,hk,ho,hl,y,n,nj,np,nl,b,m,ml,l,r,R,rt,s,sw,sg,e,f,fr,fa,fq,ft,fx,fv,fg,a,q,qt,t,T,d,w,c,z,x,v,g"
낱 := "r,R,rt,s,sw,sg,e,E,f,fr,fa,fq,ft,fx,fv,fg,a,q,Q,qt,t,T,d,w,W,c,z,x,v,g,k,o,i,O,j,p,u,P,h,hk,ho,hl,y,n,nj,np,nl,b,m,ml,l"
StringSplit, 표, 표, `,
StringSplit, 낱, 낱, `,
;;InputBox, 입력, 한--> 로 , `n`n 한글 --> Roman
Loop, Parse, SourceText
If RegExMatch( A_LoopField, "[가-?]" )
{
초성 :=  Floor( ( Asc( A_LoopField ) - 44032 )/588) + 1
중성 :=  Floor( Mod( ( Asc( A_LoopField ) - 44032 ), 588)/28) + 20
종성 :=  Mod( ( Asc( A_LoopField ) - 44032 ), 28)  + 40
결과 .= 표%초성% 표%중성% (Mod( ( Asc( A_LoopField ) - 44032 ), 28) ? 표%종성%:"")  
}
Else If RegExMatch( A_LoopField, "[ㄱ-ㅣ]" )
{
개 := Asc( A_LoopField ) - 12592
결과 .= 낱%개%
}
Else
결과 .= A_LoopField
;;sgBox, 한글 : %입력%`n`n로마 : %결과%
SendInput,  %결과%
결과 :=
return
}
}
 
if lang=korean
gosub kor
 
if lang=english
gosub eng
 
if lang=
gosub not
 
return
 
not:
send,^v
return
 
eng:
Send, {vk15scF2}
Loop, Parse,SourceText
sendraw,%A_LoopField%
return
 
kor:
count:=1
;; Send {vk15scF2}
 
po1:
 
StringMid,check,SourceText,%count%,1
checkasc:=asc(check)
 
if (97<=chasc) and (chasc<=122){
envadd,count,1
sendraw,%check%
} 
 
if count<=%length%
goto po1
 
return
 
초중종분리(문자,ByRef 초성,ByRef 중성,ByRef 종성)
{
nSize := DllCall("MultiByteToWideChar"
, "Uint", 0
, "Uint", 0
, "Uint", &문자
, "int",  -1
, "Uint*", 결과
, "int",  StrLen(문자))
초성 := (결과-0xAC00) // (21*28)
중성 := Mod( ((결과-0xAC00) //28), 21)
종성 := Mod(결과-0xAC00,28)
Return 결과
}
 
자소한영변환(ByRef 초성="0",ByRef 중성="0",ByRef 종성="0")
{
초성_0=r
초성_1=R
초성_2=s
초성_3=e
초성_4=E
초성_5=f
초성_6=a
초성_7=q
초성_8=Q
초성_9=t
초성_10=T
초성_11=d
초성_12=w
초성_13=W
초성_14=c
초성_15=z
초성_16=x
초성_17=v
초성_18=g
중성_0=k
중성_1=o
중성_2=i
중성_3=O
중성_4=j
중성_5=p
중성_6=u
중성_7=P
중성_8=h
중성_9=hk
중성_10=ho
중성_11=hl
중성_12=y
중성_13=n
중성_14=nj
중성_15=np
중성_16=nl
중성_17=b
중성_18=m
중성_19=ml
중성_20=l
종성_0=
종성_1=r
종성_2=R
종성_3=rt
종성_4=s
종성_5=sw
종성_6=sg
종성_7=e
종성_8=f
종성_9=fr
종성_10=fa
종성_11=fq
종성_12=ft
종성_13=fx
종성_14=fv
종성_15=fg
종성_16=a
종성_17=q
종성_18=qt
종성_19=t
종성_20=T
종성_21=d
종성_22=w
종성_23=c
종성_24=z
종성_25=x
종성_26=v
종성_27=g
초성:=초성_%초성%
중성:=중성_%중성%
종성:=종성_%종성%
}
}

; ----------------------------------------------------------- 단축키
#N::run Notepad ; Win + N 키로 메모장 실행 
return
#C::run calc ; Win +  c키로 계산기 실행
return