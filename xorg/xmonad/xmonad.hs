import System.IO
import qualified Data.Map as M
import qualified System.IO.UTF8
import Data.Ratio ((%))
import XMonad
import XMonad.ManageHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Scratchpad
import XMonad.Util.XSelection
import XMonad.Util.Loggers
import XMonad.StackSet as W hiding(layout, workspaces)
import XMonad.Layout.NoBorders
import XMonad.Layout.WorkspaceDir
import XMonad.Layout.Named
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Gaps
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Reflect
import XMonad.Layout.Tabbed
import XMonad.Layout.MagicFocus
import XMonad.Prompt
import XMonad.Prompt.Workspace
import XMonad.Actions.Search
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.Plane
import XMonad.Actions.WindowBringer
import XMonad.Actions.GridSelect
import XMonad.Actions.Promote
import XMonad.Actions.NoBorders
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn

browser = "uzbl-browser"

golden = toRational (((sqrt 5) - 1)/2)

tall ratio = Tall 1 delta ratio
    where delta = (3/100)

myTall r = named "tall" $ tall r
myWide r = named "wide" $ Mirror $ tall r
myFull   = named "full" $ noBorders (tabbedBottom shrinkText tabTheme)

defaultSet r =
    myTall r ||| myWide r ||| myFull
defaultMSet r =
    myWide r ||| myTall r ||| myFull
defaultWSet r =
    myFull   ||| myTall r ||| myWide r

webSpaces = map (("web"++) . show) [1..5]

myLayoutHook = (workspaceDir "~") . smartBorders . avoidStruts $
    onWorkspace "stats" stats $
    onWorkspaces webSpaces web $
    defaultSet golden
    where
    stats = defaultMSet golden
    web = defaultWSet 0.88

iconDir = "/home/komar/.xmonad/dzen2_img/"
wrapSpace = wrap "^p(8)" "^p(1)"
preIcon i = wrap ("^p(2)^i(" ++ iconDir ++ i ++ ")^p(2)") "^p(1)"

layoutNameToIcon n = "^i(" ++ iconDir ++ "lay" ++ n ++ ".xbm)"

myLogHook pipe = dynamicLogWithPP $ dzenPP {
    ppSort    = fmap (.namedScratchpadFilterOutWorkspace) $ ppSort dzenPP,
    ppOutput  = hPutStrLn pipe,
    ppTitle   = dzenColor "#5d728d" "" . shorten 100,
    ppCurrent = dzenColor "#719e4b" "#333333" . preIcon "dcur.xbm",
    ppUrgent  = dzenColor "#a53333" "" . preIcon "durg.xbm" . dzenColor "#666666" "" . dzenStrip,
    ppVisible = dzenColor "#719e4b" "#252525" . preIcon "dvis.xbm",
    ppHidden  = dzenColor "#444444" "" . wrapSpace,
    ppWsSep   = "^p(2)",
    ppSep     = dzenColor "#aaaaaa" "" "^p(3)|^p(3)",
    ppLayout  = dzenColor "#c0712c" "" . layoutNameToIcon
}

scratchpads = [
    NS "urxvt"     "urxvt -name scratchpad"
        (resource =? "scratchpad")   urxvtFloating,
    NS "alsamixer" "urxvt -name scratchmixer -e alsamixer"
        (resource =? "scratchmixer") urxvtFloating]
    where urxvtFloating = customFloating $ W.RationalRect 0 0.7 1 0.301

--myScratchpadManageHook = scratchpadManageHook(W.RationalRect 0.25 0.33 0.5 0.33)
myScratchpadManageHook = namedScratchpadManageHook scratchpads
myManageHook = myScratchpadManageHook <+> myConditions <+> manageDocks <+> manageHook defaultConfig
myConditions = composeAll [
    resource  =? "stats"      --> doF (W.shift "stats"),
    resource  =? "mail"       --> doF (W.shift "mail"),
    resource  =? "irc"        --> doF (W.shift "irc"),
    isFullscreen              --> doFullFloat,
    className =? "Gajim.py"   --> doF (W.shift "im")]

tabTheme = defaultTheme {
    activeColor          = "#111111",
    inactiveColor        = "#000000",
    urgentColor          = "#222222",
    activeBorderColor    = "#5d728d",
    inactiveBorderColor  = "#5d728d",
    urgentBorderColor    = "#dd0000",
    activeTextColor      = "#c4a000",
    inactiveTextColor    = "#aaaaaa",
    urgentTextColor      = "#dd0000",
    decoHeight           = 12
}

defaultFont = "-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*"

xpconfig = defaultXPConfig {
    font        = defaultFont,
    bgColor     = "#000000",
    fgColor     = "#aaaaaa",
    bgHLight    = "#cccccc",
    fgHLight    = "#000000",
    promptBorderWidth = 0,
    height = 10
}

floatSearchResult dhRef = oneShotHook dhRef (className =? "Uzbl-core") (doRectFloat $ W.RationalRect 0.15 0.15 0.7 0.7)

myConf spawner xmproc dynHooksRef = defaultConfig {
    manageHook = manageSpawn spawner <+> myManageHook <+> dynamicMasterHook dynHooksRef,
    layoutHook = myLayoutHook,
    logHook = myLogHook xmproc,
    focusFollowsMouse = False,
    modMask = mod4Mask,
    normalBorderColor = "#000000",
    focusedBorderColor = "#3465a4",
    terminal = "urxvt",
    workspaces = ["c1", "d1", "c2", "d2", "c3", "d3", "sys1", "ds1", "sys2", "ds2", "web1", "web2", "web3", "web4", "web5", "im", "irc", "mail", "temp", "stats"]
} `additionalKeysP` (myKeys dynHooksRef xmproc spawner) `additionalKeys` myKeysMulti

main = do
    sp <- mkSpawner
    xmproc <- spawnPipe $ "/home/komar/.xmonad/panel_launch.sh"
    dynHooksRef <- initDynamicHooks
    xmonad $ withUrgencyHook NoUrgencyHook $ myConf sp xmproc dynHooksRef

workspaceKeys = ["M-1", "M-<F1>", "M-2", "M-<F2>", "M-3", "M-<F3>", "M-4", "M-<F4>", "M-5", "M-<F5>",
    "M-6", "M-7", "M-8", "M-9", "M-0", "M--", "M-i", "M-o", "M-=", "M-\\"]
workspaceSKeys = map ("S-"++) workspaceKeys

myKeys dhRef xmproc spawner = [
    ("M-`",               workspacePrompt xpconfig (windows . W.view)),
    ("M-S-`",             workspacePrompt xpconfig (windows . W.shift)),
    ("M-p",               shellPromptHere spawner xpconfig),
    ("M-s",               namedScratchpadAction scratchpads "urxvt"),
    ("M-a",               namedScratchpadAction scratchpads "alsamixer"),
    ("M-d",               changeDir xpconfig),
    ("M-S-z",             floatSearchResult dhRef >> (selectSearchBrowser browser mySearchEngine)),
    ("M-z",               floatSearchResult dhRef >> (promptSearchBrowser xpconfig browser mySearchEngine)),
    ("M-<Esc>",           goToSelected defaultGSConfig),
    ("M-<Return>",        promote),
    ("M-S-<Backspace>",   focusUrgent),
    ("M-<Backspace>",     toggleWS)]
    ++
    [(sc, withNthWorkspace W.greedyView n) | (sc, n) <- zip workspaceKeys [0..]]
    ++
    [(sc, withNthWorkspace W.shift n) | (sc, n) <- zip  workspaceSKeys [0..]]
    ++
    [(mod ++ sc, func (Lines 1) Linear dir) |
        (sc, dir) <- [("[", ToLeft), ("]", ToRight)],
        (mod, func) <- [("M-", planeMove), ("M-S-", planeShift)]]

mySearchEngine = searchEngineF "multi" parseGoogle
    where
    parseGoogle s | s == "gmail" = "http://gmail.com"
                  | otherwise    = (use mymulti) s
    mymulti = intelligent multi

myKeysMulti = [
    ((0,                    xK_XF86AudioPlay        ), spawn ("mpc toggle")),
    ((0,                    xK_XF86AudioStop        ), spawn ("mpc stop")),
    ((0,                    xK_XF86AudioPrev        ), spawn ("mpc prev")),
    ((0,                    xK_XF86AudioNext        ), spawn ("mpc next")),
    ((0,                    xK_XF86AudioMute        ), spawn ("amixer -q set Master toggle")),
    ((0,                    xK_XF86AudioLowerVolume ), spawn ("amixer set Master\\ Front 2dB-")),
    ((0,                    xK_XF86AudioRaiseVolume ), spawn ("amixer set Master\\ Front 2dB+"))]

xK_XF86AudioLowerVolume = 0x1008ff11
xK_XF86AudioMute = 0x1008ff12
xK_XF86AudioRaiseVolume = 0x1008ff13
xK_XF86AudioStop = 0x1008ff15
xK_XF86AudioPlay = 0x1008ff14
xK_XF86AudioPrev = 0x1008ff16
xK_XF86AudioNext = 0x1008ff17
