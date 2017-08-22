unit Fake;

interface

uses Windows, SysUtils;

var aDWORD: array [0..17] of DWORD;

implementation

procedure SetProcedure;
type
    TDWordArray = array [0..$FFFFF] of DWORD;
var lib: THandle;
    NameRealDll, NameDll, Name: String;
    i, mylib: DWORD;
    pExportDirectory: PImageExportDirectory;
    pNameRVAs: ^TDWordArray;

   function GetModuleName: string;
   var S: array[0..MAX_PATH] of Char;
   begin
     GetModuleFileName(hInstance, S, SizeOf(S));
     Result:=LowerCase(S);
   end;

begin
   NameDll:=GetModuleName; mylib := dword(GetModuleHandle(PChar(NameDll)));
   NameRealDll:='_'+ExtractFileName(NameDll);

   lib := LoadLibrary(PChar(NameRealDll));
   
   pExportDirectory := pointer(pdword(mylib+$178)^ + mylib);
   pNameRVAs := pointer(dword(pExportDirectory^.AddressOfNames) + mylib);
   for i := 0 to pExportDirectory^.NumberOfNames - 1 do begin
      Name := PChar(pNameRVAs^[i]+mylib);
      aDWORD[i] := dword(GetProcAddress(lib, PAnsiChar(Name)));
   end;

end;

procedure LiquidVR;
asm
   jmp dword [aDWORD+0];
end;

procedure VRCompositorSystemInternal;
asm
   jmp dword [aDWORD+4];
end;

procedure VRControlPanel;
asm
   jmp dword [aDWORD+8];
end;

procedure VRDashboardManager;
asm
   jmp dword [aDWORD+12];
end;

procedure VROculusDirect;
asm
   jmp dword [aDWORD+16];
end;

procedure VRRenderModelsInternal;
asm
   jmp dword [aDWORD+20];
end;

procedure VRTrackedCameraInternal;
asm
   jmp dword [aDWORD+24];
end;

procedure VR_GetGenericInterface;
asm
   jmp dword [aDWORD+28];
end;

procedure VR_GetInitToken;
asm
   jmp dword [aDWORD+32];
end;

procedure VR_GetStringForHmdError;
asm
   jmp dword [aDWORD+36];
end;

procedure VR_GetVRInitErrorAsEnglishDescription;
asm
   jmp dword [aDWORD+40];
end;

procedure VR_GetVRInitErrorAsSymbol;
asm
   jmp dword [aDWORD+44];
end;

procedure VR_InitInternal;
asm
   jmp dword [aDWORD+48];
end;

procedure VR_IsHmdPresent;
asm
   jmp dword [aDWORD+52];
end;

procedure VR_IsInterfaceVersionValid;
asm
   jmp dword [aDWORD+56];
end;

procedure VR_IsRuntimeInstalled;
asm
   jmp dword [aDWORD+60];
end;

procedure VR_RuntimePath;
asm
   jmp dword [aDWORD+64];
end;

procedure VR_ShutdownInternal;
asm
   jmp dword [aDWORD+68];
end;

exports
   LiquidVR index 1 name 'LiquidVR',
   VRCompositorSystemInternal index 2 name 'VRCompositorSystemInternal',
   VRControlPanel index 3 name 'VRControlPanel',
   VRDashboardManager index 4 name 'VRDashboardManager',
   VROculusDirect index 5 name 'VROculusDirect',
   VRRenderModelsInternal index 6 name 'VRRenderModelsInternal',
   VRTrackedCameraInternal index 7 name 'VRTrackedCameraInternal',
   VR_GetGenericInterface index 8 name 'VR_GetGenericInterface',
   VR_GetInitToken index 9 name 'VR_GetInitToken',
   VR_GetStringForHmdError index 10 name 'VR_GetStringForHmdError',
   VR_GetVRInitErrorAsEnglishDescription index 11 name 'VR_GetVRInitErrorAsEnglishDescription',
   VR_GetVRInitErrorAsSymbol index 12 name 'VR_GetVRInitErrorAsSymbol',
   VR_InitInternal index 13 name 'VR_InitInternal',
   VR_IsHmdPresent index 14 name 'VR_IsHmdPresent',
   VR_IsInterfaceVersionValid index 15 name 'VR_IsInterfaceVersionValid',
   VR_IsRuntimeInstalled index 16 name 'VR_IsRuntimeInstalled',
   VR_RuntimePath index 17 name 'VR_RuntimePath',
   VR_ShutdownInternal index 18 name 'VR_ShutdownInternal';

initialization SetProcedure;

end.
