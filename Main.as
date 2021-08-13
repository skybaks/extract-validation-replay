
bool permissionCheckPassed = false;

void RenderMenu()
{
    if (!permissionCheckPassed) return;
    CTrackMania@ app = cast<CTrackMania>(GetApp());
    if (UI::MenuItem("\\$65f" + Icons::ShareSquareO + "\\$z Extract Validation Replay", enabled: app.RootMap !is null))
    {
        try
        {
            CGameDataFileManagerScript@ dataFileMgr = cast<CGameDataFileManagerScript>(cast<CSmArenaRulesMode>(app.PlaygroundScript).DataFileMgr);
            string outputFileName = "Downloaded/ValidationReplay_" + StripFormatCodes(app.RootMap.MapName) + ".Replay.Gbx";
            dataFileMgr.Replay_Save(outputFileName, app.RootMap, dataFileMgr.Map_GetAuthorGhost(app.RootMap));
            UI::ShowNotification("Extract Validation Replay", "Replay extracted to: " + outputFileName, 10000);
        }
        catch
        {
            error("Error Occurred when trying to extract replay");
        }
    }
}

void Main()
{
    permissionCheckPassed = true;
    if (!Permissions::CreateLocalReplay())
    {
        error(Meta::ExecutingPlugin().Name + ": Missing permission \"client_CreateLocalReplay\"");
        permissionCheckPassed = false;
    }
}
