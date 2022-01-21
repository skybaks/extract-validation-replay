
bool g_permissionCheckPassed = false;

void ExtractReplay()
{
    try
    {
        CGameDataFileManagerScript@ dataFileMgr = cast<CGameDataFileManagerScript>(cast<CSmArenaRulesMode>(GetApp().PlaygroundScript).DataFileMgr);
        string outputFileName = "Downloaded/ValidationReplay_" + StripFormatCodes(GetApp().RootMap.MapName) + ".Replay.Gbx";
        dataFileMgr.Replay_Save(outputFileName, GetApp().RootMap, dataFileMgr.Map_GetAuthorGhost(GetApp().RootMap));
        string outputMessage = "Replay extracted to: " + outputFileName;
        trace(outputMessage);
        UI::ShowNotification("Extract Validation Replay", outputMessage, 10000);
    }
    catch
    {
        error("Error Occurred when trying to extract replay");
    }
}

void RenderMenu()
{
    if (!g_permissionCheckPassed) return;
    if (UI::MenuItem("\\$65f" + Icons::ShareSquareO + "\\$z Extract Validation Replay", enabled: GetApp().RootMap !is null))
    {
        startnew(ExtractReplay);
    }
}

void Main()
{
    g_permissionCheckPassed = true;
    if (!Permissions::CreateLocalReplay())
    {
        error("Missing permission \"client_CreateLocalReplay\"");
        g_permissionCheckPassed = false;
    }
}
