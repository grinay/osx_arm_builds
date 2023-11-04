using System.Runtime.InteropServices;

namespace QPdf.net;

public class QpdfWrapper
{
    private const string BinaryPath = "qpdf29";
    [DllImport(BinaryPath, CallingConvention = CallingConvention.Cdecl,
        EntryPoint = "qpdfjob_run_from_json")]
    public static extern int RunFromJSON(
        [MarshalAs(UnmanagedType.LPStr)] string json);
}