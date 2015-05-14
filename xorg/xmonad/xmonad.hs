import System.IO
import qualified Data.Map as M
import qualified System.IO.UTF8
import Data.Ratio ((%))
import XMonad
import XMonad.ManageHook
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
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
import qualified XMonad.Layout.HintedTile as H
import qualified XMonad.Layout.ResizableTile as R
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
import XMonad.Actions.TopicSpace
import XMonad.Actions.DynamicWorkspaceGroups
-- for MyDzenUrgencyHook
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Dzen (dzenWithArgs, seconds)
import XMonad.Util.WorkspaceCompare

import XMonad.Prompt.Input

browser = "chromium"

golden = toRational (((sqrt 5) - 1)/2)

tall ratio = R.ResizableTall 1 delta ratio []
    where delta = (3/100)

myTall r = named "tall" $ tall r
myWide r = named "wide" $ Mirror $ tall r
myFull   = named "full" $ noBorders (tabbedBottom shrinkText tabTheme)
mySimpleFull = named "full" $ noBorders Full

defaultSet r =
    myTall r ||| myWide r ||| myFull
defaultMSet r =
    myWide r ||| myTall r ||| myFull
defaultWSet r =
    myFull   ||| myTall r ||| myWide r
defaultVSet r =
    mySimpleFull ||| myTall r ||| myWide r

webSpaces = ["web1", "web2", "pdf1", "pdf2", "pdf3"]
vncSpaces = map (("vnc"++) . show) [1..2]

-- FIXME dynamically create workspacedirs from topics configuration
myLayoutHook = workspaceDir "~" $ smartBorders $
    (onWorkspace "stats"    $ avoidStruts stats) $
    (onWorkspaces webSpaces $ avoidStruts web) $
    (onWorkspace "mail" $ avoidStruts web) $
    (onWorkspaces vncSpaces $ vnc) $
    (onWorkspace "temp" $ norm) $
    norm
    where
    stats = defaultMSet golden
    web   = defaultWSet golden
    vnc   = defaultVSet golden
    norm  = avoidStruts $ defaultSet golden

iconDir = "/home/komar/.xmonad/dzen2_img/"
wrapSpace = wrap "^p(8)" "^p(1)"
preIcon i = wrap ("^i(" ++ iconDir ++ i ++ ")") "^p(1)"

layoutNameToIcon n = "^i(" ++ iconDir ++ "lay" ++ n ++ ".xbm)"

myLogHook pipe = dynamicLogWithPP $ dzenPP {
    ppSort    = fmap (.namedScratchpadFilterOutWorkspace) $ getSortByXineramaRule,
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
        (resource =? "scratchpad")   (urxvtFloating 0 0.7 1 0.301),
    NS "alsamixer" "urxvt -name scratchmixer -e alsamixer"
        (resource =? "scratchmixer") (urxvtFloating 0.15 0 0.7 0.3),
    NS "bc"        "urxvt -name bc -e bc -l"
        (resource =? "bc")           (urxvtFloating 0.7 0.2 0.3 0.6)]
    where urxvtFloating x y w h = customFloating $ W.RationalRect x y w h

myScratchpadManageHook = namedScratchpadManageHook scratchpads
myManageHook = myScratchpadManageHook <+> myConditions <+> manageDocks <+> manageHook defaultConfig
myConditions = composeAll [
    resource  =? "stats"      --> doF (W.shift "stats"),
    isIM                      --> doF (W.shift "im"),
    isMail                    --> doF (W.shift "mail"),
    resource  =? "scratchcmd" --> (doRectFloat $ W.RationalRect 0.1 0.1 0.8 0.8),
    isFullscreen              --> doFullFloat]
    where isIM = className =? "Gajim" <||> className =? "Psi" <||> className =? "Pidgin"
          isMail = className =? "Thunderbird"

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

data TopicItem = TI { topicName :: Topic   -- (22b)
                    , topicDir  :: Dir
                    , topicAction :: X ()
                    }

myTopics :: [TopicItem]
myTopics =
    [ ti "NSP"   "~"
    , ti "c1"    "/home/komar"
    , ti "d1"    "/home/komar"
    , ti "c2"    "~"
    , ti "d2"    "~"
    , ti "c3"    "~"
    , ti "d3"    "~"
    , ti "sys1"  "~"
    , ti "ds1"   "~"
    , ti "sys2"  "~"
    , ti "ds2"   "~"
    , TI "web1"  "~/Pobrania"
        (spawnHere browser)
    , TI "web2"  "~/Pobrania"
        (spawnHere browser)
    , TI "pdf1"  "~/Pobrania"
        (runLastPdf "pdf1")
    , TI "pdf2"  "~/Pobrania"
        (runLastPdf "pdf2")
    , TI "pdf3"  "~/Pobrania"
        (runLastPdf "pdf3")
    , ti "im"    "~"
    , TI "irc"   "~" (shellRemote "kserver" "screen -x irssi")
    , TI "kserver" "~" (shellRemote "kserver" "bash")
    , ti "temp"  "~/temp"
    , ti "stats" "~"
    , ti "mail"  "~"
    , ti "vm1"  "~/VMs"
    , ti "vm2"  "~/VMs"
    , TI "vnc1"  "~"
        (spawnHere "vncviewer")
    , TI "vnc2"  "~"
        (spawnHere "vncviewer")
    ]
    where
        ti t d = TI t d shell
        shell = spawnHere "urxvt"
        runLastPdf w = spawnHere $ "~/.xmonad/run_pdf.sh " ++ w
        shellRemote host cmd = spawnHere $ "urxvt -e ssh " ++ host ++ " -t " ++ cmd

myTopicNames :: [Topic]
myTopicNames = map topicName myTopics

myTopicConfig :: TopicConfig
myTopicConfig = defaultTopicConfig
    { topicDirs = M.fromList $ map (\(TI n d _) -> (n,d)) myTopics
    , defaultTopicAction = const (return ())
    , defaultTopic = "web1"
    , maxTopicHistory = 10
    , topicActions = M.fromList $ map (\(TI n _ a) -> (n,a)) myTopics
    }

myConf xmproc = defaultConfig {
    startupHook = setWMName "LG3D",
    manageHook = manageSpawn <+> myManageHook <+> dynamicMasterHook,
    layoutHook = myLayoutHook,
    logHook = myLogHook xmproc,
    focusFollowsMouse = False,
    modMask = mod4Mask,
    normalBorderColor = "#000000",
    focusedBorderColor = "#3465a4",
    terminal = "urxvt",
    workspaces = myTopicNames,
    clickJustFocuses = True
} `additionalKeysP` (myKeys xmproc) `additionalKeys` myKeysMulti

-- Better idea to run dzen with blinker
--myDzenWithArgs :: String -> [String] -> Int -> X ()
--myDzenWithArgs str args timeout = io $ runProcessWithInputAndWait "~/.xmonad/dzenblink.sh" args (unchomp str) timeout
--  -- dzen seems to require the input to terminate with exactly one newline.
--  where unchomp s@['\n'] = s
--        unchomp []       = ['\n']
--        unchomp (c:cs)   = c : unchomp cs

data MyDzenUrgencyHook = MyDzenUrgencyHook {
                             duration :: Int,
                             args :: [String]
                         }
    deriving (Read, Show)

instance UrgencyHook MyDzenUrgencyHook where
    urgencyHook MyDzenUrgencyHook { Main.duration = d, Main.args = a } w = do
        name <- getName w
        ws <- gets windowset
        whenJust (W.findTag w ws) (flash name)
      where flash name index =
                  dzenWithArgs (dzenColor "#a53333" "" index ++ dzenColor "#444444" "" ": " ++ dzenColor "#5d728d" "" (show name)) a d

myDzenUrgencyHook :: MyDzenUrgencyHook
myDzenUrgencyHook = MyDzenUrgencyHook {Main.duration = seconds 1, Main.args = [
    "-bg", "black",
    "-xs", "2",
    "-ta", "r",
    "-fn", "-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*",
    "-x", "830"
]}

myBlinkUrgencyHook :: SpawnUrgencyHook
myBlinkUrgencyHook = SpawnUrgencyHook "~/.xmonad/blink.sh "

main = do
    checkTopicConfig myTopicNames myTopicConfig
    xmproc <- spawnPipe $ "bash ~/.xmonad/xmonad_pipe.sh"
    xmonad
        $ withUrgencyHookC myDzenUrgencyHook urgencyConfig {remindWhen = Every 2}
        $ withUrgencyHook myBlinkUrgencyHook
        $ myConf xmproc

workspaceKeys = ["", "M-1", "M-<F1>", "M-2", "M-<F2>", "M-3", "M-<F3>", "M-4", "M-<F4>", "M-5", "M-<F5>",
    "M-6", "M-7", "M-8", "M-9", "M-0", "M--", "M-i", "M-o", "M-=", "M-\\", "M-u", "M-<F9>", "M-<F10>", "M-<F11>", "M-<F12>"]
workspaceSKeys = map ("S-"++) workspaceKeys

-- Workaround for toggle + scratchpad
myToggle = windows $ W.view =<< W.tag . head . Prelude.filter ((\x -> x /= "NSP" && x /= "SP") . W.tag) . W.hidden

scratchCmd :: String -> X ()
scratchCmd c = spawnHere $ "urxvt -name scratchcmd -e " ++ c

scratchCmdPrompt = inputPrompt xpconfig "scratch" ?+ scratchCmd

myKeys xmproc = [
    ("M-S-f",             spawn ("~/.xmonad/fix_noppoo.sh")),
    ("M-`",               workspacePrompt xpconfig (windows . W.view)),
    ("M-S-`",             workspacePrompt xpconfig (windows . W.shift)),
    ("M-p",               shellPromptHere xpconfig),
    ("M-s",               namedScratchpadAction scratchpads "urxvt"),
    ("M-a",               namedScratchpadAction scratchpads "alsamixer"),
    ("M-x",               namedScratchpadAction scratchpads "bc"),
    ("M-d",               changeDir xpconfig),
    ("M-S-z",             selectSearchBrowser browser mySearchEngine),
    ("M-z",               promptSearchBrowser xpconfig browser mySearchEngine),
    ("M-;",               sendMessage R.MirrorShrink),
    ("M-'",               sendMessage R.MirrorExpand),
    ("M-n",               scratchCmdPrompt),
    ("M-<Esc>",           goToSelected defaultGSConfig),
    ("M-<Return>",        promote),
    ("M-g n",             promptWSGroupAdd xpconfig "name group: "),
    ("M-g g",             promptWSGroupView xpconfig "go to group: "),
    ("M-g d",             promptWSGroupForget xpconfig "drop group: "),
    ("M-S-<Backspace>",   do
                              focusUrgent
                              spawnHere "~/.xmonad/noblink.sh"
                              ),
    ("M-S-<Return>",      currentTopicAction myTopicConfig),
    ("M-<Backspace>",     myToggle)]
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
    ((0,                    xK_XF86AudioMute        ), spawn ("amixer -q set Master\\ Front toggle")),
    ((0,                    xK_XF86AudioLowerVolume ), spawn ("amixer set Master\\ Front 2dB-")),
    ((0,                    xK_XF86AudioRaiseVolume ), spawn ("amixer set Master\\ Front 2dB+"))]

xK_XF86AudioLowerVolume = 0x1008ff11
xK_XF86AudioMute = 0x1008ff12
xK_XF86AudioRaiseVolume = 0x1008ff13
xK_XF86AudioStop = 0x1008ff15
xK_XF86AudioPlay = 0x1008ff14
xK_XF86AudioPrev = 0x1008ff16
xK_XF86AudioNext = 0x1008ff17
