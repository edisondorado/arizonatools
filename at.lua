script_name('Arizona Tools by Alan Butler')
script_version('1.0')
script_author('Alan_Butler') -- vk.com/alanbutler

require 'lib.sampfuncs'
require 'lib.moonloader'

local sampev = require 'lib.samp.events'
local keys = require "vkeys"
local rkeys = require 'rkeys'
local inicfg = require "inicfg"
local imgui = require 'mimgui'
-- local wm = require 'windows.message'
local ffi = require 'ffi'
ffi.cdef [[
  bool SetCursorPos(int X, int Y);
]]
ffi.cdef [[
    typedef int BOOL;
    typedef unsigned long HANDLE;
    typedef HANDLE HWND;
    typedef int bInvert;
 
    HWND GetActiveWindow(void);

    BOOL FlashWindow(HWND hWnd, BOOL bInvert);
]]
local fa = require("fAwesome5")
local addons = require "ADDONS"
local base64 = require('base64')
local wm = require 'windows.message'
local vector = require "vector3d"
local memory = require("memory")
local effil = require"effil"
local cjson = require"cjson"
local dlstatus = require('moonloader').download_status
local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Arial', 10, font_flag.BOLD + font_flag.BORDER)
local font = renderCreateFont('Arial',20,1) 


imgui.HotKey = require('mimgui_addons').HotKey


local Matrix3X3 = require "matrix3x3"
local Vector3D = require "vector3d"


local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local sizeX, sizeY = getScreenResolution()

local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
sw, sh 	= getScreenResolution()

local amenu = new.bool()
local report_window = new.bool()
local gps_window = new.bool()
local lvl_window = new.bool()
local cmd_window = new.bool()
local color_window = new.bool()
local question_window = new.bool()
local fastmenuwindow = new.bool()
local recon_window = new.bool()
local getip_window = new.bool()
local reconinfo_window = new.bool()
local stats_window = new.bool()
local online_window = new.bool()
local amember_window = new.bool()
local tp_window = new.bool()


local col = imgui.new.float[4](1, 0, 0, 1)

local state = false 
local cam = {}
local nearCars = {}
fractp = false


--                      ИниКфг

local dirIni = "..\\Arizona Tools\\settings.ini"
local dirIniChecker = "..\\Arizona Tools\\checker.ini"

fracsAmember = {
	"Полиция ЛС",
	"RCSD",
	"FBI",
	"Полиция СФ",
	"Больница LS",
	"Правительство LS",
	"Тюрьма строгого режима LV",
	"Больница СФ",
	"Инструкторы",
	"TV студия",
	"Grove Street",
	"Los Santos Vagos",
	"East Side Ballas",
	"Varrios Los Aztecas",
	"The Rifa",
	"Russian Mafia",
	"Yakuza",
	"La Cosa Nostra",
	"Warlock MC",
	"Армия ЛС",
	"Центральный Банк",
	"Больница LV",
	"LVPD",
	"TV студия LV",
	"Night Wolves",
	"TV студия SF",
	"Армия SF",
	"Темное братство"
}

local ini = inicfg.load({
    main = {
        lvl_adm = "0",
        auto_az = false,
        pass_acc = "",
        pass_adm = "",
        is_clickwarp=false,
        is_gm=false,
        flood_ot=true,
        speed_airbrake = "0.3",
        control_afk=false,
        max_afk = "300",
        limitmax_afk="50",
        ischecker=true,
        delay_checker="10",
        posX = 30,
        posY = (sh / 2) - 100,
        maxAfk = 300,
        maxActive = 120,
        traicers = false,
        whcar = true,
        whdist = 50,
        getipwindow = false,
        statswindow = false,
        statsx = 2000,
        statsy = 60,
        onlinsession = true,
        fullonlineses = true,
        afkses = true,
        onlineday = true,
        fullonlineday = true,
        afkday = true,
        onlineweek = true,
        fullonlineweek = true,
        afkweek = true,
        rep=true,
        repses=true,
        repday=true,
        repweek=true,
        cdacceprform = 5,
        autoprefix=false,
        logcon = false,
        logreg = false,
        logconposx = 500,
        logconposy = 500,
        logconlimit = 5,
        limitreg = 5,
        logregposx = 500,
        logregposy = 500,
    },
    font = {
    	name = 'Arial',
    	size = 9,
    	flag = 5,
    	offset = 19,
    },
    level = {
    	[1] = true,
    	[2] = true,
    	[3] = true,
    	[4] = true,
    	[5] = true,
    	[6] = true,
      [7] = true,
      [8] = true
    },
    forms = {
        tag="// ",
        slap=false,
        flip=false,
        freeze=false,
        unfreeze=false,
        pm=false,
        spplayer=false,
        spcar=false,
        cure=false,
        weap=false,
        unjail=false,
        jail=false,
        unmute=false,
        kick=false,
        mute=false,
        adeldesc=false,
        apunish=false,
        plveh=false,
        bail=false,
        unwarn=false,
        ban=false,
        warn=false,
        accepttrade=false,
        givegun=false,
        trspawn=false,
        destroytrees=false,
        removetune=false,
        clearafklabel=false,
        setfamgz=false,
        delhname=false,
        delbname=false,
        warnoff=false,
        unban=false,
        afkkick=false,
        aparkcar=false,
        setgangzone=false,
        setbizmafia=false,
        cleardemorgane=false,
        sban=false,
        banip=false,
        unbanip=false,
        jailoff=false,
        muteoff=false,
        skick=false,
        setskin=false,
        uval=false,
        ao =false,
        unapunishoff=false,
        unjailoff=false,
        unmuteoff=false,
        unwarnoff=false,
        bizlock=false,
        bizopen=false,
        cinemaunrent=false,
        banipoff=false,
        banoff=false,
        agl=false,
        clearad=false,
        autoslap=false,
        autoflip=false,
        autofreeze=false,
        autounfreeze=false,
        autopm=false,
        autospplayer=false,
        autospcar=false,
        autocure=false,
        autoweap=false,
        autounjail=false,
        autojail=false,
        autounmute=false,
        autokick=false,
        automute=false,
        autoadeldesc=false,
        autoapunish=false,
        autoplveh=false,
        autobail=false,
        autounwarn=false,
        autoban=false,
        autowarn=false,
        autoaccepttrade=false,
        autogivegun=false,
        autotrspawn=false,
        autodestroytrees=false,
        autoremovetune=false,
        autoclearafklabel=false,
        autosetfamgz=false,
        autodelhname=false,
        autodelbname=false,
        autowarnoff=false,
        autounban=false,
        autoafkkick=false,
        autoaparkcar=false,
        autosetgangzone=false,
        autosetbizmafia=false,
        autocleardemorgane=false,
        autosban=false,
        autobanip=false,
        autounbanip=false,
        autojailoff=false,
        automuteoff=false,
        autoskick=false,
        autosetskin=false,
        autouval=false,
        autoao=false,
        autounapunishoff=false,
        autounjailoff=false,
        autounmuteoff=false,
        autounwarnoff=false,
        autobizlock=false,
        autobizopen=false,
        autocinemaunrent=false,
        autobanipoff=false,
        autobanoff=false,
        autoagl=false,
        autoclearad=false,
    },
    binds = {
        reoff="F2",
        last_rep="F2",
        bind_ot="F2",
        acceptform = "F2",
    },
    style = {
      color = 0xFF3333AA,
      text = 0xFFFFFFFF,
      logcon_d = 0xFF0000FF,
      logreg = 0xFFFFFFFF,
      rounding = 15,
    },
    show = {
    	id = true,
    	level = false,
    	afk = true,
    	recon = true,
    	reputate = false,
    	active = true,
    	selfMark = false,
    },
    recon = {
      x = 1600,
      y = 650,
      funcx = 600,
      funcy = 900,
    },
    onDay = {
      today = os.date("%a"),
      online = 0,
      afk = 0,
      full = 0,
    },
    onWeek = {
      week = 1,
      online = 0,
      afk = 0,
      full = 0,
    },
    myWeekOnline = {
        [0] = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
    },
    onDayReport = {
      todat = os.date("%a"),
      report = 0,
    },
    onWeekReport = {
      week = 1,
      report = 0,
    },
    myWeekReport = {
      [0] = 0,
      [1] = 0,
      [2] = 0,
      [3] = 0,
      [4] = 0,
      [5] = 0,
      [6] = 0,
    },
    color = {
    	[1] = 0xFFBBBD2E,
    	[2] = 0xFFBD920B,
    	[3] = 0xFF3EA3DF,
    	[4] = 0xFF1DB052,
    	[5] = 0xFF7900FF,
    	[6] = 0xFF24AD0A,
      [7] = 0xFF24AD01,
      [8] = 0xFF2F0000,
    	['afk'] 		= 0xFF95FF00,
    	['recon'] 		= 0xFF00C3FF,
    	['reputate'] 	= 0xFFFF8D00,
    	['active'] 		= 0xFF44E300,
    	['note']		= 0xFFAEAEAE,
    },
    notes = {},
    kurators = {},
    zga = {},
    ga = {},
    customcolor = {},
    customcolor_status = {},
    special = {
    	'Conor',
    	'Sam_Mason'
    }
}, dirIni)
inicfg.save(ini, dirIni)
inicfg.load(ini, dirIni)

local nowTime = os.date("%H:%M:%S", os.time())

local ActiveClockMenu = {
  v = {ini.binds.reoff}
}


local lastrep = {
  v = {ini.binds.last_rep}
}

local bindot = {
  v = {ini.binds.bind_ot}
}

local acceptform = {
  v = {ini.binds.acceptform}
}

local bindID = 0
notesAdmin = new.char[256]()

mc = imgui.ColorConvertU32ToFloat4(ini.style.color)
tc = imgui.ColorConvertU32ToFloat4(ini.style.text)
cd = imgui.ColorConvertU32ToFloat4(ini.style.logcon_d)
rc = imgui.ColorConvertU32ToFloat4(ini.style.logreg)

rdata = {}

mode = true

local sesOnline = 0
local sesAfk = 0
local sesFull = 0
local sesreport = 0
local dayFull = ini.onDay.full
local weekFull = ini.onWeek.full
isfrac = false


local quitReason = { 
	"Crash",
	"/q",
	"Server Kicked"
}

formsIni = {
  ['slap']            = new.bool(ini.forms.slap),
  ['flip']            = new.bool(ini.forms.flip),
  ['freeze']          = new.bool(ini.forms.freeze),
  ['unfreeze']        = new.bool(ini.forms.unfreeze),
  ['pm']              = new.bool(ini.forms.pm), 
  ['spplayer']        = new.bool(ini.forms.spplayer),
  ['spcar']           = new.bool(ini.forms.spcar),
  ['cure']            = new.bool(ini.forms.cure),
  ['weap']            = new.bool(ini.forms.weap),
  ['unjail']          = new.bool(ini.forms.unjail),
  ['jail']            = new.bool(ini.forms.jail),
  ['unmute']          = new.bool(ini.forms.unmute),
  ['kick']            = new.bool(ini.forms.kick),
  ['mute']            = new.bool(ini.forms.mute),
  ['adeldesc']        = new.bool(ini.forms.adeldesc),
  ['apunish']         = new.bool(ini.forms.apunish),
  ['plveh']           = new.bool(ini.forms.plveh),
  ['bail']            = new.bool(ini.forms.bail),
  ['unwarn']          = new.bool(ini.forms.unwarn),
  ['ban']             = new.bool(ini.forms.ban),
  ['warn']            = new.bool(ini.forms.warn),
  ['accepttrade']     = new.bool(ini.forms.accepttrade),
  ['givegun']         = new.bool(ini.forms.givegun),
  ['trspawn']         = new.bool(ini.forms.trspawn),
  ['destroytrees']    = new.bool(ini.forms.destroytrees),
  ['removetune']      = new.bool(ini.forms.removetune),
  ['clearafklabel']   = new.bool(ini.forms.clearafklabel),
  ['setfamgz']        = new.bool(ini.forms.setfamgz),
  ['delhname']        = new.bool(ini.forms.delhname),
  ['delbname']        = new.bool(ini.forms.delbname),
  ['warnoff']         = new.bool(ini.forms.warnoff),
  ['unban']           = new.bool(ini.forms.unban),
  ['afkkick']         = new.bool(ini.forms.afkkick),
  ['aparkcar']        = new.bool(ini.forms.aparkcar),
  ['setgangzone']     = new.bool(ini.forms.setgangzone),
  ['setbizmafia']     = new.bool(ini.forms.setbizmafia),
  ['cleardemorgane']  = new.bool(ini.forms.cleardemorgane),
  ['sban']            = new.bool(ini.forms.sban),
  ['banip']           = new.bool(ini.forms.banip),
  ['unbanip']         = new.bool(ini.forms.unbanip),
  ['jailoff']         = new.bool(ini.forms.jailoff),
  ['muteoff']         = new.bool(ini.forms.muteoff),
  ['skick']           = new.bool(ini.forms.skick),
  ['setskin']         = new.bool(ini.forms.setskin),
  ['uval']            = new.bool(ini.forms.uval),
  ['ao']              = new.bool(ini.forms.ao),
  ['unapunishoff']    = new.bool(ini.forms.unapunishoff),
  ['unjailoff']       = new.bool(ini.forms.unjailoff),
  ['unmuteoff']       = new.bool(ini.forms.unmuteoff),
  ['unwarnoff']       = new.bool(ini.forms.unwarnoff),
  ['bizlock']         = new.bool(ini.forms.bizlock),
  ['bizopen']         = new.bool(ini.forms.bizopen),
  ['cinemaunrent']    = new.bool(ini.forms.cinemaunrent),
  ['banipoff']        = new.bool(ini.forms.banipoff),
  ['banoff']          = new.bool(ini.forms.banoff),
  ['agl']             = new.bool(ini.forms.agl),
  ['clearad']         = new.bool(ini.forms.clearad)
}

AutoformsIni = {
  ['slap']            = new.bool(ini.forms.autoslap),
  ['flip']            = new.bool(ini.forms.autoflip),
  ['freeze']          = new.bool(ini.forms.autofreeze),
  ['unfreeze']        = new.bool(ini.forms.autounfreeze),
  ['pm']              = new.bool(ini.forms.autopm), 
  ['spplayer']        = new.bool(ini.forms.autospplayer),
  ['spcar']           = new.bool(ini.forms.autospcar),
  ['cure']            = new.bool(ini.forms.autocure),
  ['weap']            = new.bool(ini.forms.autoweap),
  ['unjail']          = new.bool(ini.forms.autounjail),
  ['jail']            = new.bool(ini.forms.autojail),
  ['unmute']          = new.bool(ini.forms.autounmute),
  ['kick']            = new.bool(ini.forms.autokick),
  ['mute']            = new.bool(ini.forms.automute),
  ['adeldesc']        = new.bool(ini.forms.autoadeldesc),
  ['apunish']         = new.bool(ini.forms.autoapunish),
  ['plveh']           = new.bool(ini.forms.autoplveh),
  ['bail']            = new.bool(ini.forms.autobail),
  ['unwarn']          = new.bool(ini.forms.autounwarn),
  ['ban']             = new.bool(ini.forms.autoban),
  ['warn']            = new.bool(ini.forms.autowarn),
  ['accepttrade']     = new.bool(ini.forms.autoaccepttrade),
  ['givegun']         = new.bool(ini.forms.autogivegun),
  ['trspawn']         = new.bool(ini.forms.autotrspawn),
  ['destroytrees']    = new.bool(ini.forms.autodestroytrees),
  ['removetune']      = new.bool(ini.forms.autoremovetune),
  ['clearafklabel']   = new.bool(ini.forms.autoclearafklabel),
  ['setfamgz']        = new.bool(ini.forms.autosetfamgz),
  ['delhname']        = new.bool(ini.forms.autodelhname),
  ['delbname']        = new.bool(ini.forms.autodelbname),
  ['warnoff']         = new.bool(ini.forms.autowarnoff),
  ['unban']           = new.bool(ini.forms.autounban),
  ['afkkick']         = new.bool(ini.forms.autoafkkick),
  ['aparkcar']        = new.bool(ini.forms.autoaparkcar),
  ['setgangzone']     = new.bool(ini.forms.autosetgangzone),
  ['setbizmafia']     = new.bool(ini.forms.autosetbizmafia),
  ['cleardemorgane']  = new.bool(ini.forms.autocleardemorgane),
  ['sban']            = new.bool(ini.forms.autosban),
  ['banip']           = new.bool(ini.forms.autobanip),
  ['unbanip']         = new.bool(ini.forms.autounbanip),
  ['jailoff']         = new.bool(ini.forms.autojailoff),
  ['muteoff']         = new.bool(ini.forms.automuteoff),
  ['skick']           = new.bool(ini.forms.autoskick),
  ['setskin']         = new.bool(ini.forms.autosetskin),
  ['uval']            = new.bool(ini.forms.autouval),
  ['ao']              = new.bool(ini.forms.autoao),
  ['unapunishoff']    = new.bool(ini.forms.autounapunishoff),
  ['unjailoff']       = new.bool(ini.forms.autounjailoff),
  ['unmuteoff']       = new.bool(ini.forms.autounmuteoff),
  ['unwarnoff']       = new.bool(ini.forms.autounwarnoff),
  ['bizlock']         = new.bool(ini.forms.autobizlock),
  ['bizopen']         = new.bool(ini.forms.autobizopen),
  ['cinemaunrent']    = new.bool(ini.forms.autocinemaunrent),
  ['banipoff']        = new.bool(ini.forms.autobanipoff),
  ['banoff']          = new.bool(ini.forms.autobanoff),
  ['agl']             = new.bool(ini.forms.autoagl),
  ['clearad']         = new.bool(ini.forms.autoclearad)
}

forms = {
  "slap",
  "flip",
  "freeze",
  "unfreeze",
  "pm",
  "spplayer",
  "spcar",
  "cure",
  "weap",
  "unjail",
  "jail",
  "unmute",
  "kick",
  "mute",
  "adeldesc",
  "apunish",
  "plveh",
  "bail",
  "unwarn",
  "ban",
  "warn",
  "clearad",
  "accepttrade",
  "givegun",
  "trspawn",
  "destroytrees",
  "removetune",
  "clearafklabel",
  "setfamgz",
  "delhname",
  "delbname",
  "warnoff",
  "unban",
  "afkkick",
  "aparkcar",
  "setgangzone",
  "setbizmafia",
  "cleardemorgane",
  "sban",
  "banip",
  "unbanip",
  "jailoff",
  "muteoff",
  "skick",
  "setskin",
  "uval",
  "ao",
  "unapunishoff",
  "unjailoff",
  "unmuteoff",
  "unwarnoff",
  "bizlock",
  "bizopen",
  "cinemaunrent",
  "banipoff",
  "agl",
  "banoff",
}

formsFunc = {
  "slap",
  "flip",
  "freeze",
  "unfreeze",
  "pm",
  "spplayer",
  "spcar",
  "cure",
  "weap",
  "unjail",
  "jail",
  "unmute",
  "kick",
  "mute",
  "adeldesc",
  "apunish",
  "plveh",
  "bail",
  "unwarn",
  "ban",
  "warn",
  "accepttrade",
  "givegun",
  "trspawn",
  "destroytrees",
  "removetune",
  "clearafklabel",
  "setfamgz",
  "delhname",
  "delbname",
  "warnoff",
  "unban",
  "afkkick",
  "aparkcar",
  "setgangzone",
  "setbizmafia",
  "cleardemorgane",
  "sban",
  "banip",
  "unbanip",
  "jailoff",
  "muteoff",
  "skick",
  "setskin",
  "uval",
  "ao",
  "unapunishoff",
  "unjailoff",
  "unmuteoff",
  "unwarnoff",
  "bizlock",
  "bizopen",
  "cinemaunrent",
  "banipoff",
  "agl",
  "clearad",
}

autoforms = {
  "autoslap",
  "autoflip",
  "autofreeze",
  "autounfreeze",
  "autopm",
  "autospplayer",
  "autospcar",
  "autocure",
  "autoweap",
  "autounjail",
  "autojail",
  "autounmute",
  "autokick",
  "automute",
  "autoadeldesc",
  "autoapunish",
  "autoplveh",
  "autobail",
  "autounwarn",
  "autoban",
  "autowarn",
  "autoaccepttrade",
  "autogivegun",
  "autotrspawn",
  "autodestroytrees",
  "autoremovetune",
  "autoclearafklabel",
  "autosetfamgz",
  "autodelhname",
  "autodelbname",
  "autowarnoff",
  "autounban",
  "autoafkkick",
  "autoaparkcar",
  "autosetgangzone",
  "autosetbizmafia",
  "autocleardemorgane",
  "autosban",
  "autobanip",
  "autounbanip",
  "autojailoff",
  "automuteoff",
  "autoskick",
  "autosetskin",
  "autouval",
  "autoao ",
  "autounapunishoff",
  "autounjailoff",
  "autounmuteoff",
  "autounwarnoff",
  "autobizlock",
  "autobizopen",
  "autocinemaunrent",
  "autobanipoff",
  "autobanoff",
  "autoagl",
  "autoclearad",
}


function setPermission()
  if ini.main.lvl_adm == 1 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = false
    formsIni['weap'][0]            = false
    formsIni['unjail'][0]          = false
    formsIni['jail'][0]            = false
    formsIni['unmute'][0]          = false
    formsIni['kick'][0]            = false
    formsIni['mute'][0]            = false
    formsIni['adeldesc'][0]        = false
    formsIni['apunish'][0]         = false
    formsIni['plveh'][0]           = false
    formsIni['bail'][0]            = false
    formsIni['clearad'][0]         = false
    formsIni['unwarn'][0]          = false
    formsIni['ban'][0]             = false
    formsIni['warn'][0]            = false
    formsIni['accepttrade'][0]     = false
    formsIni['givegun'][0]         = false
    formsIni['trspawn'][0]         = false
    formsIni['destroytrees'][0]    = false
    formsIni['removetune'][0]      = false
    formsIni['clearafklabel'][0]   = false
    formsIni['setfamgz'][0]        = false
    formsIni['delhname'][0]        = false
    formsIni['delbname'][0]        = false
    formsIni['warnoff'][0]         = false
    formsIni['unban'][0]           = false
    formsIni['afkkick'][0]         = false
    formsIni['aparkcar'][0]        = false
    formsIni['setgangzone'][0]     = false
    formsIni['setbizmafia'][0]     = false
    formsIni['cleardemorgane'][0]  = false
    formsIni['sban'][0]            = false
    formsIni['banip'][0]           = false
    formsIni['unbanip'][0]         = false
    formsIni['jailoff'][0]         = false
    formsIni['muteoff'][0]         = false
    formsIni['skick'][0]           = false
    formsIni['setskin'][0]         = false
    formsIni['uval'][0]            = false
    formsIni['ao'][0]              = false
    formsIni['unapunishoff'][0]    = false
    formsIni['unjailoff'][0]       = false
    formsIni['unmuteoff'][0]       = false
    formsIni['unwarnoff'][0]       = false
    formsIni['bizlock'][0]         = false
    formsIni['bizopen'][0]         = false
    formsIni['cinemaunrent'][0]    = false
    formsIni['banipoff'][0]        = false
    formsIni['banoff'][0]          = false
    formsIni['agl'][0]             = false
    
    
  elseif ini.main.lvl_adm == 2 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = true
    formsIni['weap'][0]            = true
    formsIni['unjail'][0]          = true
    formsIni['jail'][0]            = true
    formsIni['unmute'][0]          = true
    formsIni['kick'][0]            = true
    formsIni['mute'][0]            = true
    formsIni['adeldesc'][0]        = true
    formsIni['apunish'][0]         = false
    formsIni['plveh'][0]           = false
    formsIni['bail'][0]            = false
    formsIni['clearad'][0]         = false
    formsIni['unwarn'][0]          = false
    formsIni['ban'][0]             = false
    formsIni['warn'][0]            = false
    formsIni['accepttrade'][0]     = false
    formsIni['givegun'][0]         = false
    formsIni['trspawn'][0]         = false
    formsIni['destroytrees'][0]    = false
    formsIni['removetune'][0]      = false
    formsIni['clearafklabel'][0]   = false
    formsIni['setfamgz'][0]        = false
    formsIni['delhname'][0]        = false
    formsIni['delbname'][0]        = false
    formsIni['warnoff'][0]         = false
    formsIni['unban'][0]           = false
    formsIni['afkkick'][0]         = false
    formsIni['aparkcar'][0]        = false
    formsIni['setgangzone'][0]     = false
    formsIni['setbizmafia'][0]     = false
    formsIni['cleardemorgane'][0]  = false
    formsIni['sban'][0]            = false
    formsIni['banip'][0]           = false
    formsIni['unbanip'][0]         = false
    formsIni['jailoff'][0]         = false
    formsIni['muteoff'][0]         = false
    formsIni['skick'][0]           = false
    formsIni['setskin'][0]         = false
    formsIni['uval'][0]            = false
    formsIni['ao'][0]              = false
    formsIni['unapunishoff'][0]    = false
    formsIni['unjailoff'][0]       = false
    formsIni['unmuteoff'][0]       = false
    formsIni['unwarnoff'][0]       = false
    formsIni['bizlock'][0]         = false
    formsIni['bizopen'][0]         = false
    formsIni['cinemaunrent'][0]    = false
    formsIni['banipoff'][0]        = false
    formsIni['banoff'][0]          = false
    formsIni['agl'][0]             = false
  elseif ini.main.lvl_adm == 3 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = true
    formsIni['weap'][0]            = true
    formsIni['unjail'][0]          = true
    formsIni['jail'][0]            = true
    formsIni['unmute'][0]          = true
    formsIni['kick'][0]            = true
    formsIni['mute'][0]            = true
    formsIni['adeldesc'][0]        = true
    formsIni['apunish'][0]         = true
    formsIni['plveh'][0]           = true
    formsIni['bail'][0]            = true
    formsIni['clearad'][0]         = true
    formsIni['unwarn'][0]          = true
    formsIni['ban'][0]             = true
    formsIni['warn'][0]            = true
    formsIni['accepttrade'][0]     = true
    formsIni['givegun'][0]         = true
    formsIni['trspawn'][0]         = true
    formsIni['destroytrees'][0]    = true
    formsIni['removetune'][0]      = true
    formsIni['clearafklabel'][0]   = true
    formsIni['setfamgz'][0]        = false
    formsIni['delhname'][0]        = false
    formsIni['delbname'][0]        = false
    formsIni['warnoff'][0]         = false
    formsIni['unban'][0]           = false
    formsIni['afkkick'][0]         = false
    formsIni['aparkcar'][0]        = false
    formsIni['setgangzone'][0]     = false
    formsIni['setbizmafia'][0]     = false
    formsIni['cleardemorgane'][0]  = false
    formsIni['sban'][0]            = false
    formsIni['banip'][0]           = false
    formsIni['unbanip'][0]         = false
    formsIni['jailoff'][0]         = false
    formsIni['muteoff'][0]         = false
    formsIni['skick'][0]           = false
    formsIni['setskin'][0]         = false
    formsIni['uval'][0]            = false
    formsIni['ao'][0]              = false
    formsIni['unapunishoff'][0]    = false
    formsIni['unjailoff'][0]       = false
    formsIni['unmuteoff'][0]       = false
    formsIni['unwarnoff'][0]       = false
    formsIni['bizlock'][0]         = false
    formsIni['bizopen'][0]         = false
    formsIni['cinemaunrent'][0]    = false
    formsIni['banipoff'][0]        = false
    formsIni['banoff'][0]          = false
    formsIni['agl'][0]             = false
  elseif ini.main.lvl_adm == 4 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = true
    formsIni['weap'][0]            = true
    formsIni['unjail'][0]          = true
    formsIni['jail'][0]            = true
    formsIni['unmute'][0]          = true
    formsIni['kick'][0]            = true
    formsIni['mute'][0]            = true
    formsIni['adeldesc'][0]        = true
    formsIni['apunish'][0]         = true
    formsIni['plveh'][0]           = true
    formsIni['bail'][0]            = true
    formsIni['clearad'][0]         = true
    formsIni['unwarn'][0]          = true
    formsIni['ban'][0]             = true
    formsIni['warn'][0]            = true
    formsIni['accepttrade'][0]     = true
    formsIni['givegun'][0]         = true
    formsIni['trspawn'][0]         = true
    formsIni['destroytrees'][0]    = true
    formsIni['removetune'][0]      = true
    formsIni['clearafklabel'][0]   = true
    formsIni['setfamgz'][0]        = true
    formsIni['delhname'][0]        = true
    formsIni['delbname'][0]        = true
    formsIni['warnoff'][0]         = true
    formsIni['unban'][0]           = true
    formsIni['afkkick'][0]         = true
    formsIni['aparkcar'][0]        = true
    formsIni['setgangzone'][0]     = true
    formsIni['setbizmafia'][0]     = true
    formsIni['cleardemorgane'][0]  = true
    formsIni['sban'][0]            = true
    formsIni['banip'][0]           = true
    formsIni['unbanip'][0]         = true
    formsIni['jailoff'][0]         = true
    formsIni['muteoff'][0]         = true
    formsIni['skick'][0]           = true
    formsIni['setskin'][0]         = true
    formsIni['uval'][0]            = true
    formsIni['ao'][0]              = true
    formsIni['unapunishoff'][0]    = true
    formsIni['unjailoff'][0]       = true
    formsIni['unmuteoff'][0]       = true
    formsIni['unwarnoff'][0]       = true
    formsIni['bizlock'][0]         = true
    formsIni['bizopen'][0]         = true
    formsIni['cinemaunrent'][0]    = true
    formsIni['banipoff'][0]        = false
    formsIni['banoff'][0]          = false
    formsIni['agl'][0]             = false
  elseif ini.main.lvl_adm >= 5 then
    formsIni['slap'][0]            = true
    formsIni['flip'][0]            = true
    formsIni['freeze'][0]          = true
    formsIni['unfreeze'][0]        = true
    formsIni['pm'][0]              = true 
    formsIni['spplayer'][0]        = true
    formsIni['spcar'][0]           = true
    formsIni['cure'][0]            = true
    formsIni['weap'][0]            = true
    formsIni['unjail'][0]          = true
    formsIni['jail'][0]            = true
    formsIni['unmute'][0]          = true
    formsIni['kick'][0]            = true
    formsIni['mute'][0]            = true
    formsIni['adeldesc'][0]        = true
    formsIni['apunish'][0]         = true
    formsIni['plveh'][0]           = true
    formsIni['bail'][0]            = true
    formsIni['clearad'][0]         = true
    formsIni['unwarn'][0]          = true
    formsIni['ban'][0]             = true
    formsIni['warn'][0]            = true
    formsIni['accepttrade'][0]     = true
    formsIni['givegun'][0]         = true
    formsIni['trspawn'][0]         = true
    formsIni['destroytrees'][0]    = true
    formsIni['removetune'][0]      = true
    formsIni['clearafklabel'][0]   = true
    formsIni['setfamgz'][0]        = true
    formsIni['delhname'][0]        = true
    formsIni['delbname'][0]        = true
    formsIni['warnoff'][0]         = true
    formsIni['unban'][0]           = true
    formsIni['afkkick'][0]         = true
    formsIni['aparkcar'][0]        = true
    formsIni['setgangzone'][0]     = true
    formsIni['setbizmafia'][0]     = true
    formsIni['cleardemorgane'][0]  = true
    formsIni['sban'][0]            = true
    formsIni['banip'][0]           = true
    formsIni['unbanip'][0]         = true
    formsIni['jailoff'][0]         = true
    formsIni['muteoff'][0]         = true
    formsIni['skick'][0]           = true
    formsIni['setskin'][0]         = true
    formsIni['uval'][0]            = true
    formsIni['ao'][0]              = true
    formsIni['unapunishoff'][0]    = true
    formsIni['unjailoff'][0]       = true
    formsIni['unmuteoff'][0]       = true
    formsIni['unwarnoff'][0]       = true
    formsIni['bizlock'][0]         = true
    formsIni['bizopen'][0]         = true
    formsIni['cinemaunrent'][0]    = true
    formsIni['banipoff'][0]        = true
    formsIni['banoff'][0]          = true
    formsIni['agl'][0]             = true
  end
end

-----------------------------------------------------

      inputs = {
        ['report_window_answer'] = new.char[256](""),
        ['finding_question'] = new.char[256](""),
        ['finding_cmd'] = new.char[256](""),
        ['finding_gps'] = new.char[256](""),
        ['delay_checker'] = new.int(ini.main.delay_checker),
			  ['maxAfk'] = new.int(ini.main.maxAfk),
        ['maxActive'] = new.int(ini.main.maxActive),
        ['bufAdd5'] = new.char[256](""),
        ['bufAdd6'] = new.char[256](""),
        ['bufAdd7'] = new.char[256](""),
        ['bufAdd8'] = new.char[256](""),
        ['cdacceptform'] = new.int(ini.main.cdacceprform),
        ['rounding'] = new.int(ini.style.rounding),
        ['logconlimit'] = new.int(ini.main.logconlimit),
        ['limitreg'] = new.int(ini.main.limitreg)
      }

      sliders = {
        ['whdistance'] = new.int(ini.main.whdist)
      }

      toggles = {
        ['floodot'] = new.bool(ini.main.flood_ot),
        ['autoaz'] = new.bool(ini.main.auto_az),
        ['isgm'] = new.bool(ini.main.is_gm),
        ['isclickwarp'] = new.bool(ini.main.is_clickwarp),
        ['checkeradm'] = new.bool(ini.main.ischecker),
        ['customcolorstatus'] = new.bool(),
        ['traicers'] = new.bool(ini.main.traicers),
        ['whcar'] = new.bool(ini.main.whcar),
        ['getipwindow'] = new.bool(ini.main.getipwindow),
        ['statswindow'] = new.bool(ini.main.statswindow),
        ['onlinsession'] = new.bool(ini.main.onlinsession),
        ['fullonlineses'] = new.bool(ini.main.fullonlineses),
        ['afkses'] = new.bool(ini.main.afkses),
        ['onlineday'] = new.bool(ini.main.onlineday),
        ['fullonlineday'] = new.bool(ini.main.fullonlineday),
        ['afkday'] = new.bool(ini.main.afkday),
        ['onlineweek'] = new.bool(ini.main.onlineweek),
        ['fullonlineweek'] = new.bool(ini.main.fullonlineweek),
        ['afkweek'] = new.bool(ini.main.afkweek),
        ['rep'] = new.bool(ini.main.rep),
        ['repses'] = new.bool(ini.main.repses),
        ['repday'] = new.bool(ini.main.repday),
        ['repweek'] = new.bool(ini.main.repweek),
        ['autoprefix'] = new.bool(ini.main.autoprefix),
        ['logcon'] = new.bool(ini.main.logcon),
        ['logreg'] = new.bool(ini.main.logreg),
      }



      navigation = { 
        ['selected'] = 'Основное',
        ['buttons'] = {
          {'Основное', fa.ICON_FA_COG},
          {'Читы', fa.ICON_FA_CUBE}, 
          {'Цвета', fa.ICON_FA_IMAGE},
          {'Назначение клавиш', fa.ICON_FA_TOGGLE_ON},
          {'Формы', fa.ICON_FA_CROSSHAIRS},
          {'Рекон', fa.ICON_FA_USER_SECRET},
          {'Репорт',fa.ICON_FA_BULLHORN},
          {'Контроль AFK', fa.ICON_FA_BED},
          {'Чекер', fa.ICON_FA_LIST_UL}
        }
      }

      checkers = {
        ['selected'] = 1,
        ['clicked'] = {
          ['last'] = nil,
          ['time'] = nil
        },
        ['buttons'] = {
          'Чекер администрации',
          'Чекер лидеров/замов',
          'Чекер игроков',
          'Лог отключения',
          'Лог регистраций'
        }
      }

      local tWeekdays = {
        [0] = 'Воскресенье:',
        [1] = 'Понедельник:', 
        [2] = 'Вторник:', 
        [3] = 'Среда:', 
        [4] = 'Четверг:', 
        [5] = 'Пятница:', 
        [6] = 'Суббота:'
      }
      
checker_font = renderCreateFont(ini.font.name, ini.font.size, ini.font.flag)
local BulletSync = {lastId = 0, maxLines = 15}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = false, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end

      admins = {
        ['forms'] = {
          ['tag'] = new.char[256](""..ini.forms.tag),
          ['ban'] = ini.forms.ban,
        },
        ['profile'] = {
          ['passacc'] = new.char[256](""..base64.decode(ini.main.pass_acc)),
          ['passadm'] = new.char[256](""..ini.main.pass_adm),
        },
        ['checker'] = {
          ['amountOnline'] = 0,
          ['amountAfk'] = 0,
        },
        ['showLvl'] = {
          [1] = new.bool(ini.level[1]),
            [2] = new.bool(ini.level[2]),
            [3] = new.bool(ini.level[3]),
            [4] = new.bool(ini.level[4]),
            [5] = new.bool(ini.level[5]),
            [6] = new.bool(ini.level[6]),
            [7] = new.bool(ini.level[7]),
            [8] = new.bool(ini.level[8])
        },
        ['colors'] = {
          lvl = {
            [1] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[1]).x, imgui.ColorConvertU32ToFloat4(ini.color[1]).y, imgui.ColorConvertU32ToFloat4(ini.color[1]).z, imgui.ColorConvertU32ToFloat4(ini.color[1]).w),
              [2] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[2]).x, imgui.ColorConvertU32ToFloat4(ini.color[2]).y, imgui.ColorConvertU32ToFloat4(ini.color[2]).z, imgui.ColorConvertU32ToFloat4(ini.color[2]).w),
              [3] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[3]).x, imgui.ColorConvertU32ToFloat4(ini.color[3]).y, imgui.ColorConvertU32ToFloat4(ini.color[3]).z, imgui.ColorConvertU32ToFloat4(ini.color[3]).w),
              [4] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[4]).x, imgui.ColorConvertU32ToFloat4(ini.color[4]).y, imgui.ColorConvertU32ToFloat4(ini.color[4]).z, imgui.ColorConvertU32ToFloat4(ini.color[4]).w),
              [5] = imgui.new.float[5](imgui.ColorConvertU32ToFloat4(ini.color[5]).x, imgui.ColorConvertU32ToFloat4(ini.color[5]).y, imgui.ColorConvertU32ToFloat4(ini.color[5]).z, imgui.ColorConvertU32ToFloat4(ini.color[5]).w),
              [6] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[6]).x, imgui.ColorConvertU32ToFloat4(ini.color[6]).y, imgui.ColorConvertU32ToFloat4(ini.color[6]).z, imgui.ColorConvertU32ToFloat4(ini.color[6]).w),
              [7] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[7]).x, imgui.ColorConvertU32ToFloat4(ini.color[7]).y, imgui.ColorConvertU32ToFloat4(ini.color[7]).z, imgui.ColorConvertU32ToFloat4(ini.color[7]).w),
              [8] = imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color[8]).x, imgui.ColorConvertU32ToFloat4(ini.color[8]).y, imgui.ColorConvertU32ToFloat4(ini.color[8]).z, imgui.ColorConvertU32ToFloat4(ini.color[8]).w),
          },
          content = {
		    		['afk'] 		= {'AFK', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['afk']).x, imgui.ColorConvertU32ToFloat4(ini.color['afk']).y, imgui.ColorConvertU32ToFloat4(ini.color['afk']).z, imgui.ColorConvertU32ToFloat4(ini.color['afk']).w)},
			    	['recon'] 		= {'Слежка', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['recon']).x, imgui.ColorConvertU32ToFloat4(ini.color['recon']).y, imgui.ColorConvertU32ToFloat4(ini.color['recon']).z, imgui.ColorConvertU32ToFloat4(ini.color['recon']).w)},
			    	['reputate'] 	= {'Репутация', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['reputate']).x, imgui.ColorConvertU32ToFloat4(ini.color['reputate']).y, imgui.ColorConvertU32ToFloat4(ini.color['reputate']).z, imgui.ColorConvertU32ToFloat4(ini.color['reputate']).w)},
			    	['active'] 		= {'Актив', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['active']).x, imgui.ColorConvertU32ToFloat4(ini.color['active']).y, imgui.ColorConvertU32ToFloat4(ini.color['active']).z, imgui.ColorConvertU32ToFloat4(ini.color['active']).w)},
			    	['note']		= {'Заметки', imgui.new.float[4](imgui.ColorConvertU32ToFloat4(ini.color['note']).x, imgui.ColorConvertU32ToFloat4(ini.color['note']).y, imgui.ColorConvertU32ToFloat4(ini.color['note']).z, imgui.ColorConvertU32ToFloat4(ini.color['note']).w)},
		    	},
        },
        ['showInfo'] = {
            id 			= new.bool(ini.show.id),
            level 		= new.bool(ini.show.level),
            afk 		= new.bool(ini.show.afk),
            recon 		= new.bool(ini.show.recon),
            reputate 	= new.bool(ini.show.reputate),
            active 		= new.bool(ini.show.active),
            selfMark 	= new.bool(ini.show.selfMark),
        },
        ['pos'] = imgui.ImVec2(ini.main.posX, ini.main.posY),
        ['posstatsrecon'] = imgui.ImVec2(ini.recon.x, ini.recon.y),
        ['poslogdisc'] = imgui.ImVec2(ini.main.logconposx, ini.main.logconposy),
        ['poslogreg'] = imgui.ImVec2(ini.main.logregposx, ini.main.logregposy),
        ['posrecon'] = imgui.ImVec2(ini.recon.funcx, ini.recon.funcy),
        ['posstats'] = imgui.ImVec2(ini.main.statsx, ini.main.statsy),
        ['online'] = nil,
        ['afk'] = nil,
        ['list'] = {},
        ['active'] = {}
      }
      
      fonts = {
        ['input'] = imgui.new.char[256](u8(ini.font.name)),
        ['size'] = imgui.new.int(ini.font.size),
        ['flag'] = imgui.new.int(ini.font.flag),
        ['offset'] = imgui.new.int(ini.font.offset),
      }

      admNames = {
        'Мл. Модератор',
        'Модератор',
        'Ст. Модератор',
        'Администратор',
        'Куратор',
        'Заместитель ГА',
        'Главный администратор',
        'Спец. Администратор'
      }

      rInfo = {
        ['id'] = "-1",
        ['carid'] = "-1",
        ['iscar'] = false,
        ['status'] = false,
        ['name'] = nil,
        ['org'] = "Неизвестно",
        ['rank'] = "-1",
        ['client'] = "Неизвестно",
        ['iskamen'] = false,
        ['lasttp'] = false,
      }

      settingsChecker = {}

      editColors = {
        ['mc'] = new.float[4](mc.x, mc.y, mc.z, mc.w),
        ['tc'] = new.float[4](tc.x, tc.y, tc.z, tc.w),
        ['cd'] = new.float[4](cd.x, cd.y, cd.z, cd.w),
        ['rc'] = new.float[4](rc.x, rc.y, rc.z, rc.w)
      }

      cars = {
        "Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus", "Voodoo", "Pony",
        "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
        "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit",
        "Romero", "Packer", "Monster Truck", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee",
        "Caddy", "Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot",
        "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer",
        "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville",
        "Benson", "Mesa", "RC Goblin", "Hotring Racer", "Hotring Racer", "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle",
        "Cropdust", "Stunt", "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
        "Fortune", "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex",
        "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
        "Yosemite", "Windsor", "Monster Truck", "Monster Truck", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma",
        "Savanna", "Bandito", "Freight", "Trailer", "Kart", "Mower", "Duneride", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
        "Newsvan", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "Trailer", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LS)",
        "Police Car (SF)", "Police Car (LV)", "Police Ranger", "Picador", "S.W.A.T. Van", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer", "Luggage Trailer",
        "Stair Trailer", "Boxville", "Farm Plow", "Utility Trailer"
        } -- 1203 - Volvo XC90

      special_cars = {
        [612] = "Mercedes GT63 AMG",
        [613] = "Mercedes G63 AMG",
        [614] = "Audi RS6",
        [662] = "BMW X5m",
        [663] = "Chevrolet Corvette",
        [665] = "Chevrolet Cruze",
        [666] = "Lexus LX 570",
        [667] = "Porsche 911",
        [668] = "Porsche Cayenne S",
        [699] = "Bentley",
        [793] = "BMW M8",
        [794] = "Mercedes E63",
        [909] = "Mercedes S63 AMG Coupe A",
        [965] = "Volkswagen Touareg", 
        [1194] = "Lamborgini Urus",
        [1195] = "Audi Q8",
        [1196] = "Dodge Challenger SRT",
        [1197] = "Acura NSX",
        [1198] = "Volvo V60",
        [1199] = "Range Rover Evoque",
        [1200] = "Honda Civic Type-R", 
        [1201] = "Lexus Sport-S",
        [1202] = "Ford Mustang GT",
        [1203] = "Volvo XC90",
        [1204] = "Jaguar F-pace",
        [1205] = "Kia Optima",
        [3155] = "BMW Z4 40i",
        [3156] = "Mercedes-Benz S600 W124",
        [3157] = "BMW X5 ES3",
        [3158] = "Nissan Skyline R34",
        [3194] = "Ducati Diavel",
        [3195] = "Ducati Panlgale",
        [3196] = "Ducati Ducnaked",
        [3197] = "Kawasaki Ninja ZX-10RR",
        [3198] = "Western",
        [3199] = "Rolls-Royce Cullinan",
        [3200] = "Volkswagen Beetle",
        [3201] = "Bugatti Divo Sport",
        [3202] = "Bugati Chiron",
        [3203] = "Fiat 500",
        [3204] = "Mercedes GLS 2020",
        [3205] = "Mercedes-AMG G65 AMG",
        [3206] = "Lamborghini Aventador SVJ",
        [3207] = "Range Rover SVA",
        [3208] = "BMW 530I E39",
        [3209] = "Mercedes-Benz S600 W220",
        [3210] = "Tesla Model X",
        [3211] = "Nissan LEAF",
        [3212] = "Nissan Silvia S15",
        [3213] = "Subary Forest XT",
        [3215] = "Subaru Legacy 1989",
        [3216] = "Hyundai Sonata",
        [3217] = "BMW 750I E38",
        [3218] = "Mercedes-Benz E 55 AMG",
        [3219] = "Mercedes-Benz E500",
        [3220] = "Storm",
        [3222] = "Makvin",
        [3223] = "Mater",
        [3224] = "Buckingham",
        [3232] = "Infiniti FX 50",
        [3233] = "Lexus RX 450H",
        [3234] = "Kia Sportage",
        [3235] = "Volkswagen Golf R",
        [3236] = "Audi R8",
        [3237] = "Toyota Camry XV40",
        [3238] = "Toyota Camry XV70",
        [3239] = "BMW M5 E60",
        [3240] = "BMW M5 F90",
        [3245] = "Mercedes Maybach S 650",
        [3247] = "Mercedes-Benz AMG GT",
        [3248] = "Porsche Panamera Turbo",
        [3251] = "Volkswagen Passat",
        [3254] = "Chevrole Corvette",
        [3266] = "Dodge Ram",
        [3348] = "Ford Mustang Shelby GT500",
        [3974] = "Aston Martin DB5",
        [4542] = "BMW M3 GTR",
        [4543] = "Chevrolete Camaro",
        [4544] = "Mazda RX7 Veilside FD",
        [4545] = "Mazda RX8",
        [4546] = "Mitsubishi Eclipse",
        [4547] = "Ford Mustang 289",
        [4548] = "Nissan 350Z",
        [4774] = "BMW 760li",
        [4775] = "Aston Martin One-77",
        [4776] = "Bentley Bacalar",
        [4777] = "Bentley Bentyaga",
        [4778] = "BMW M4 G82",
        [4779] = "BMW I8",
        [4780] = "Genesis G90",
        [4781] = "Honda Integra Type-R",
        [4782] = "BMW M3 G20",
        [4783] = "Mercedes-Benz S500 4Matic",
        [4784] = "Ford Raptor F150",
        [4785] = "Ferrari J50",
        [4786] = "Mercedes-Benz SLR McLaren",
        [4787] = "Subaru BRZ",
        [4788] = "Lada Vesta SW Cross",
        [4789] = "Porsche Taycan",
        [4790] = "Ferrari Enzo",
        [4791] = "UAZ Patriot",
        [4792] = "Volga",
        [4793] = "Mercedes-Benz X Class", --
        [4794] = "Jaguar XF",
        [4795] = "RC Shuttle",
        [4796] = "Dodge Grand Caravan",
        [4797] = "Dodge Charger",
        [4798] = "Ford Exploler",
        [4799] = "Ford F150",
        [4800] = "Deltaplan",
        [4801] = "Gidrocycle",
        [4802] = "Lamborgini Cantenario",
        [4803] = "Ferrari 612 Superfast",
        [6604] = "Audi A6",
        [6605] = "Audi Q7",
        [6606] = "BMW M6 2020",
        [6607] = "BMW M6 1990",
        [6608] = "Mercedes-Benz CLA 45 AMG", 
        [6609] = "Mercedes-Benz CLS 63 AMG",
        [6610] = "Haval H6 2.0 GDIT",
        [6611] = "Toyota Land Cruiser VXR V8 4",
        [6612] = "Lincol Continental",
        [6613] = "Porsche Macan Turbo",
        [6614] = "Daewoo Matiz",
        [6615] = "Mercedes-AMG G63 6x6",
        [6616] = "Mercedes-Benz E-63 AMG",
        [6617] = "Monster Mutt",
        [6618] = "Monster Indonesia", --
        [6619] = "Monster El Toro",
        [6620] = "Monster Grave Digger",
        [6621] = "Toyota Land Cruiser Prado",
        [6622] = "Toyota RAV4",
        [6623] = "Toyota Supra A90",
        [6624] = "UAZ",
        [6625] = "Volvo XC90 2012",
        [12713] = "Mercedes-Benz GLE 63",
        [12714] = "Renault Laguna",
        [12715] = "Mercedes-Benz CLS 53",
        [12716] = "Audi RS5",
        [12717] = "Cadilac Escalade 2020",
        [12718] = "Cyber Truck",
        [12719] = "Tesla Model C",
        [12720] = "Ford GT",
        [12721] = "Dodge Viper",
        [12722] = "Volkswagen Polo",
        [12723] = "Mitsubishi Lancer Old",
        [12724] = "Audi TT RS",
        [12725] = "Mercedes-Benz Actros",
        [12726] = "Audi S4",
        [12727] = "BMW 4-Series",
        [12728] = "Cadillac Escalade 2007",
        [12729] = "Toyota Chaser",
        [12730] = "Dacia 1300",
        [12731] = "Mitsubishi Lancer",
        [12732] = "Impala 64",
        [12733] = "Impala 67",
        [12736] = "McLaren MP4",
        [12737] = "Ford Mustang Mach 1",
        [12738] = "Rolls-Royce Phantom",
        [12739] = "Pickup truck",
        [12740] = "Volvo Truck",
        [12741] = "Subaru WRX",
        [12742] = "Sherp",
        [14124] = "Nissan GTR 2017", 
        [14767] = "Mercedes-AMG Project One R50",
        [14769] = "Chevrolet Aveo",
        [14857] = "BUGATTI Bolide",
        [14884] = "Yacota K5",
        [14899] = "Renault DUSTER",
        [14904] = "Ferrari Monza SP2",
        [14905] = "Mercedes-AMG G63",
        [14906] = "HotWheels",
        [14907] = "Hummer HX",
        [14908] = "Ferrari F70",
        [14909] = "BMW M5 CS",
        [14910] = "LADA Priora",
        [14911] = "Quadra Turbo-R V-Tech",
        [14913] = "Mercedes-Benz VISION AVTR",
        [14914] = "Specialized Stumpjumper",
        [14915] = "Santa Cruz Tallboy",
        [14916] = "Spooky Metalhead",
        [14917] = "Turner Burner",
        [14918] = "Holding Bus Company",
        [14919] = "Los-Santos Inter Bus C.",
      }
--399
----------------------------------------------------

--                      Теги

local tag_err = "{ff0000}[Arizona-Tools]{FFFFFF}: "
local tag_q =  "{ffff00}[Arizona-Tools]{FFFFFF}: "
local tag = "{00FF00}[Arizona-Tools]{FFFFFF}: "

local spying_report = "Уважаемый игрок, начинаю работать по вашей жалобе."
local helping_report = "Уважаемый игрок, сейчас попробую вам помочь."
local send_report = "Уважаемый игрок, передал ваш репорт."

--                     Фигня всякая

pass_acc_see = false
pass_acc_see_adm = false
keyToggle = VK_MBUTTON
keyApply = VK_LBUTTON
repId = "-1"
lost_report = false
statuscheckafk=true
workchecker=false
adminsOnline = 0
adminsAfk = 0
selfrep = 0
lvladmplayer = "0"
local idt = -1
local y = 600
workingChecker = false
statsforma = true
formastop = false
afktest = false
enAirBrake = false
fastmenu_id = -1
fastmenu_lvl = -1
ableclickwarp = false
logcon = {}
logreg = {}

function gpsbutton(arg)
  if report_window[0] then
    imgui.StrCopy(inputs['report_window_answer'], gpsInfo[arg])
    gps_window[0] = false
  else
    lua_thread.create(function()
      sampSetChatInputEnabled(true)
      wait(1)
      sampSetChatInputText(u8:decode(gpsInfo[arg]))
      gps_window[0] = false
    end)
  end
end

function cmdbutton(arg)
  if report_window[0] then
    imgui.StrCopy(inputs['report_window_answer'], cmdInfo[arg])
    cmd_window[0] = false
  else
    lua_thread.create(function()
      sampSetChatInputEnabled(true)
      wait(1)
      sampSetChatInputText(u8:decode(cmdInfo[arg]))
      cmd_window[0] = false
    end)
  end
end

function questionbutton(arg)
  if report_window[0] then
    imgui.StrCopy(inputs['report_window_answer'], questionInfo[arg])
    question_window[0] = false
  else
    lua_thread.create(function()
      sampSetChatInputEnabled(true)
      wait(1)
      sampSetChatInputText(u8:decode(questionInfo[arg]))
      question_window[0] = false
    end)
  end
end

--------------------------------------------

local thisScript = script.this

function main()
    if not isSampLoaded()  then return end
    while  not isSampAvailable() do wait(100) end
    window = ffi.C.GetActiveWindow()
    sampSendChat("/reoff")
    initializeRender()
    local ip, port = sampGetCurrentServerAddress()
    if ip ~= "80.66.82.168" then
        sampAddChatMessage(tag_err.."Скрипт работает только на сервере Arizona RP - Page ", -1)
        thisScript:unload()        
    end
    sampAddChatMessage(tag..'Запущен успешно!', -1)
    gpsDw()
    setCharCanBeKnockedOffBike(PLAYER_PED, true)
    addEventHandler('onWindowMessage', function(msg, wparam, lparam)
      if msg == 0x100 or msg == 0x101 then
        if wparam == VK_RETURN and report_window[0] and not isPauseMenuActive() then
          consumeWindowMessage(true, false)
          if msg == 0x101 then
            if #str(inputs['report_window_answer']) < 4 then
              sampAddChatMessage(tag_err..'Длина ответа менее 4х символов!', -1)
            else
              sampSendDialogResponse(1334, 1, 0, u8:decode(str(inputs['report_window_answer'])))
              infoReport(u8:decode(str(inputs['report_window_answer'])))
              enableDialog(true)
              imgui.StrCopy(inputs['report_window_answer'], "")
              sampCloseCurrentDialogWithButton(0)
              report_window[0] = false
              addreport()
            end
          end
          
        end
      elseif wparam == VK_SPACE and not sampIsDialogActive() and not sampIsChatInputActive() and rInfo['id'] ~= "-1" then
        sampSendChat("/re "..rInfo['id'])
        local bool = sampIsCursorActive()
        ableclickwarp = false
        showCursor(not bool)
        printStringNow("Updated",2000)
      elseif wparam == VK_RBUTTON and not sampIsDialogActive() and not sampIsChatInputActive() and rInfo['id'] ~= "-1" then
        sampSendChat("/re "..rInfo['id'])
        local bool = sampIsCursorActive()
        ableclickwarp = false
        showCursor(not bool)
        printStringNow("Updated",2000)
      end
    end)
    autoupdate("https://github.com/edisondorado/arizonatools/raw/main/infoupdate", '['..string.upper(thisScript().name)..']: ', "https://vk.com/tools19")
    --            Команды
    sampRegisterChatCommand('amenu', function() amenu[0] = not amenu[0] end)
    sampRegisterChatCommand('hgps', function() gps_window[0] = not gps_window[0] end)
    sampRegisterChatCommand('hlvl', function() lvl_window[0] = not lvl_window[0] end)
    sampRegisterChatCommand('hcmd', function() cmd_window[0] = not cmd_window[0] end)
    sampRegisterChatCommand('hcolor', function() color_window[0] = not color_window[0] end)
    sampRegisterChatCommand('hquestion', function() question_window[0] = not question_window[0] end)
    sampRegisterChatCommand('online', function() online_window[0] = not online_window[0] end)
    sampRegisterChatCommand('tpr', cmd_tpr)
    sampRegisterChatCommand('test', cmd_test)
    sampRegisterChatCommand('admins', CMD_admins)
    sampRegisterChatCommand('amember', cmd_amember)
    sampRegisterChatCommand('tp', cmd_tp)

    if ini.onDay.today ~= os.date("%a") then 
      ini.onDay.today = os.date("%a")
      ini.onDay.online = 0
       ini.onDay.full = 0
       ini.onDay.afk = 0
         dayFull = 0
         save()
    end

    if ini.onWeek.week ~= number_week() then
      ini.onWeek.week = number_week()
        ini.onWeek.online = 0
        ini.onWeek.full = 0
        ini.onWeek.afk = 0
          weekFull = 0
          for _, v in pairs(ini.myWeekOnline) do v = 0 end            
          save()
    end

    if ini.onDayReport.today ~= os.date("%a") then
      ini.onDayReport.today = os.date("%a")
      ini.onDayReport.report = 0
      save()
    end

    if ini.onWeekReport.week ~= number_week() then
      ini.onWeekReport.week = number_week()
      ini.onWeekReport.report = 0
      for _, v in pairs(ini.myWeekOnline) do v = 0 end
      save()
    end
    lua_thread.create(flooder)
    lua_thread.create(time)
    lua_thread.create(autoSave)
    
    if ini.main.statswindow then
      stats_window[0] = true
    else
      stats_window[0] = false
    end
    afkstatus = false
    ---------------------------------------------
    while true do
      id = select(2, sampGetPlayerIdByCharHandle(playerPed))
      selfid = select(2, sampGetPlayerIdByCharHandle(playerPed))
        self = {
          nick = sampGetPlayerNickname(id),
          score = sampGetPlayerScore(id),
          color = sampGetPlayerColor(id),
          ping = sampGetPlayerPing(id),
          gameState = sampGetGamestate()
        }
        if isGamePaused() or afkstatus and not afktest then
          lua_thread.create(function ()
            afktest = true
    
            while isGamePaused() or afkstatus do
              wait(0)
            end
    
            wait(1500)
    
            afktest = false
          end)
        end
        while isPauseMenuActive() do
          if cursorEnabled then
            showCursor(false)
          end
          wait(100)
        end
        local oTime = os.time()
        if ini.main.traicers then
          for i = 1, BulletSync.maxLines do
            if BulletSync[i].enable == true and oTime <= BulletSync[i].time then
              local o, t = BulletSync[i].o, BulletSync[i].t
              if isPointOnScreen(o.x, o.y, o.z) and
                isPointOnScreen(t.x, t.y, t.z) then
                local sx, sy = convert3DCoordsToScreen(o.x, o.y, o.z)
                local fx, fy = convert3DCoordsToScreen(t.x, t.y, t.z)
                renderDrawLine(sx, sy, fx, fy, 1, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
                renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, BulletSync[i].tType == 0 and 0xFFFFFFFF or 0xFFFFC700)
              end
            end
          end
        end
        
        if ini.main.whcar then
          veh = getAllVehicles()
          for k, v in ipairs(veh) do
            if isCarOnScreen(v) then
              if getCarModel(v) - 399 > #cars then
                for ya, zn in pairs(special_cars) do
                  if getCarModel(v) == ya then
                    model = zn..' (' .. tostring(select(2, sampGetVehicleIdByCarHandle(v))) .. ')'
                  end
                end
              else
                model = cars[getCarModel(v) - 399] .. ' (' .. tostring(select(2, sampGetVehicleIdByCarHandle(v))) .. ')' --1493 - Ford Mustang GT
              end
              ---------------------------------------------------------------------------------------------------
              clr, _ = getCarColours(v)
              local cx, cy, cz = getCarCoordinates(v)
              local px, py, pz = getCharCoordinates(PLAYER_PED)
              local x, y = convert3DCoordsToScreen(cx, cy, cz)
              local lenght = renderGetFontDrawTextLength(font, model, true)
              local height = renderGetFontDrawHeight(font)
              local hpModel = getCarHealth(v)
              local dist = getDistanceBetweenCoords3d(cx, cy, cz, px, py, pz)
              if dist <= ini.main.whdist then
                renderFontDrawText(checker_font, model, x - (lenght) / 2, y - (height+50) / 2, 0xFFFFFFFF, true) -- 1203
                renderFontDrawText(checker_font, "HP: "..hpModel, x - (lenght) / 2, y - (height+20) / 2, 0xFFFFFFFF, true) -- 1203
              end
            end
          end
        end
        if isKeyJustPressed(ini.binds.acceptform) then
          prinalforma = true
        end
        yRender = ini.main.posY
        if ChangePosReconStats then
          local cx, cy = getCursorPos()
          renderDrawBox(cx,cy,400,400,0xAAFFFFFF)
        end
        if ini.main.logcon then
          local X = ini.main.logconposx
          local Y = ini.main.logconposy
          renderFontDrawText(my_font, "Лог отключения:", ini.main.logconposx, ini.main.logconposy-20, 0xFFFFFFFF)
          for k, v in pairs(logcon) do
            renderFontDrawText(my_font, v, X, Y, 0xFFAFAFAF)
            Y = Y + 20 -- это будет смещать стрку после предыдущей строки
          end
        end
        if ini.main.logreg then
          local X = ini.main.logregposx
          local Y = ini.main.logregposy
          renderFontDrawText(my_font, "Лог регистраций:", ini.main.logregposx, ini.main.logregposy-20, 0xFFFFFFFF)
          for k, v in pairs(logreg) do
            renderFontDrawText(my_font, v, X, Y, 0xFFAFAFAF)
            Y = Y + 20 -- это будет смещать стрку после предыдущей строки
          end
        end
        if ChangePosRecon then
          local cx, cy = getCursorPos()
          renderDrawBox(cx, cy, 550, 88, 0xAAFFFFFF)
        end
        if ChangePosLogDisc then
          toggles['logcon'][0] = true
          ini.main.logcon = true
          save()
        end
        if ChangePosLogReg then
          toggles['logreg'][0] = true
          ini.main.logreg = true
          save()
        end
        drawClickableText(true, checker_font, (string.format('{1ECC00}Администрация онлайн [%s | AFK: %s]:', admins['online'] or 0, admins['afk'] or 0)), ini.main.posX, yRender-ini.font.offset, 0xFFFFFFFF, 0xFFFFFFFF, ini.font.align, false)
        if #admins['list'] > 0 then
          local getActive = function(target)
          if ini.show.active and tonumber(admins['active'][target]) then
            local timer = os.time() - admins['active'][target]
            local color = ABGRtoStringRGB(ini.color['active'])
            local text = color .. ' - Актив: '
            local cmdString = timer >= tonumber(ini.main.maxActive) and text .. '{FF0000}' .. timer or text .. timer
            return cmdString
          end
          return ''
        end
        if ini.main.statswindow then
          stats_window[0] = true
        else
          stats_window[0] = false
        end
        local getAfk = function(target, count)
          if ini.show.afk and tonumber(count) then
            local color = ABGRtoStringRGB(ini.color['afk'])
            local text = color .. ' - AFK: '
            local cmdString = count >= tonumber(ini.main.maxAfk) and text .. '{FF0000}' .. count or text .. count
            return cmdString
          end
          return ''
        end

        local getLvlColor = function(id, rb, lvl, name)
          local myId = select(2, sampGetPlayerIdByCharHandle(playerPed))
          if id == myId and rb then
            return ARGBtoStringRGB(rainbow(2))
          elseif ini.customcolor[name] ~= nil then
            return ABGRtoStringRGB(ini.customcolor[name])
          else
            return ABGRtoStringRGB(ini.color[lvl])
          end
        end
        if #admins['list'] > 0 then
            for lvl = 8, 1, -1 do
              local block = admins['list'][lvl]
              if ini.level[lvl] then
                for i, admin in ipairs(block) do
                  local nick 		= admin[1]
                  local id 		= ini.show.id and ('(%s)'):format(admin[2]) or ''
                  local level 	= ini.show.level and (lvl >= 6 and ('%s+: '):format(lvl) or ('%s: '):format(lvl)) or ''
                  local afk  		= getAfk(nick, admin[3])
                  if tonumber(admin[4]) == selfid then
                    recon = admin[4] and (ini.show.recon and ABGRtoStringRGB(ini.color['recon']) .. (admin[4] >= 0 and (' - /re ЗА ВАМИ') or '') or '') 			or ''
                  else
                    recon = admin[4] and (ini.show.recon and ABGRtoStringRGB(ini.color['recon']) .. (admin[4] >= 0 and (' - /re %s'):format(admin[4]) or '') or '') 			or ''
                  end    
                  local reputate 	= admin[5] and (ini.show.reputate and ABGRtoStringRGB(ini.color['reputate']) .. (' - Rep: %s'):format(admin[5]) or '') 								or ''
                  local active 	= getActive(nick)
                  local note 		= ini.notes[admin[1]] and ABGRtoStringRGB(ini.color['note']) .. (' // %s'):format(ini.notes[admin[1]]:gsub('\n.*', ' ...')) or ''
                  local cmdString = ('%s%s%s%s%s%s%s%s'):format(level, nick, id, afk, recon, reputate, active, note)
                  local lvlColor 	= getLvlColor(admin[2], admins['showInfo'].selfMark[0], lvl, nick)
                  if nick == self.nick then
                    selfrep = admin[5]
                    ini.main.lvl_adm = lvl
                  end
                  if drawClickableText(true, checker_font, lvlColor .. cmdString, ini.main.posX, yRender, 0xFFFFFFFF, 0xFFFF0000, ini.font.align, false) and isKeyDown(VK_MENU) then
                    fastmenuwindow[0] = true
                    fastmenu_id = ini.show.id and ('%s'):format(admin[2]) or ''
                    fastmenu_lvl = (lvl >= 6 and ('%s+'):format(lvl) or ('%s'):format(lvl)) or ''
                    if ini.customcolor_status[sampGetPlayerNickname(fastmenu_id)] == nil then
                      toggle_newcustomcolor = new.bool(false)
                    else
                      toggle_newcustomcolor = new.bool(ini.customcolor_status[sampGetPlayerNickname(fastmenu_id)])

                    end
                    
                    if ini.customcolor[sampGetPlayerNickname(fastmenu_id)] ~= nil then
                      local nc = imgui.ColorConvertU32ToFloat4(ini.customcolor[sampGetPlayerNickname(fastmenu_id)])
                      fc = new.float[4](nc.x, nc.y, nc.z, nc.w)
                    else
                      ini.customcolor[sampGetPlayerNickname(fastmenu_id)] = ini.color[lvl]
                      local nc = imgui.ColorConvertU32ToFloat4(ini.customcolor[sampGetPlayerNickname(fastmenu_id)])
                      fc = new.float[4](nc.x, nc.y, nc.z, nc.w)
                    end
                    
                  end
                  yRender=yRender+ini.font.offset
                end
              end
            end
          end
        end
        maincolor = ABGRtoStringRGB(ini.style.color)
        if isKeyJustPressed(keyToggle) then
          ableclickwarp = true
          cursorEnabled = not cursorEnabled
          showCursor(cursorEnabled)
        end
        if cursorEnabled and ableclickwarp and not amenu[0] and not report_window[0] and not gps_window[0] and not lvl_window[0] and not cmd_window[0] and not color_window[0] and not question_window[0] and not fastmenuwindow[0] and not ChangePos and not ChangePosReconStats and not ChangePosRecon and not ChangePosStats and not ChangePosLogDisc and not getip_window[0] and not online_window[0] and ini.main.is_clickwarp then
          local mode = sampGetCursorMode()
          if mode == 0 then
            showCursor(true)
          end
          local sx, sy = getCursorPos()
          local sw, sh = getScreenResolution()
          -- is cursor in game window bounds?
          if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
            local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
            local camX, camY, camZ = getActiveCameraCoordinates()
            -- search for the collision point
            local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
            if result and colpoint.entity ~= 0 then
              local normal = colpoint.normal
              local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
              local zOffset = 300
              if normal[3] >= 0.5 then zOffset = 1 end
              -- search for the ground position vertically down
              local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
                true, true, false, true, false, false, false)
              if result then
                pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)
    
                local curX, curY, curZ  = getCharCoordinates(playerPed)
                local dist              = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
                local hoffs             = renderGetFontDrawHeight(font)
    
                sy = sy - 2
                sx = sx - 2
                renderFontDrawText(font, string.format("%0.2fm", dist), sx, sy - hoffs, 0xEEEEEEEE)
    
                local tpIntoCar = nil
                if colpoint.entityType == 2 then
                  local car = getVehiclePointerHandle(colpoint.entity)
                  if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
                    displayVehicleName(sx, sy - hoffs * 2, getNameOfVehicleModel(getCarModel(car)))
                    local color = 0xAAFFFFFF
                    if isKeyDown(VK_RBUTTON) and rInfo['id'] == "-1" then
                      tpIntoCar = car
                      color = 0xFFFFFFFF
                    end
                    renderFontDrawText(font2, "Зажмите правую кнопку мыши, чтобы сесть в транспорт", sx, sy - hoffs * 3, color)
                  end
                end
    
                createPointMarker(pos.x, pos.y, pos.z)
    
                -- teleport!
                if isKeyDown(keyApply) then
                  if tpIntoCar then
                    if not jumpIntoCar(tpIntoCar) then
                      -- teleport to the car if there is no free seats
                      if rInfo['id'] ~= "-1" then
                        sampSendChat("/plpos "..rInfo['id'].." "..pos.x.." "..pos.y.." "..pos.z)
                        ableclickwarp = not ableclickwarp
                      elseif rInfo['id'] == "-1" then
                        teleportPlayer(pos.x, pos.y, pos.z)
                        ableclickwarp = not ableclickwarp
                      end
                    end
                  else
                    if isCharInAnyCar(playerPed) then
                      local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
                      local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
                      rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
                      pos = pos - norm * 1.8
                      pos.z = pos.z - 0.8
                    end
                    if rInfo['id'] ~= "-1" then
                      sampSendChat("/plpos "..rInfo['id'].." "..pos.x.." "..pos.y.." "..pos.z)
                      ableclickwarp = not ableclickwarp
                    elseif rInfo['id'] == "-1" then
                      teleportPlayer(pos.x, pos.y, pos.z)
                      ableclickwarp = not ableclickwarp
                    end
                  end
                  removePointMarker()
                  showCursor(false)
                end
              end
            end
          end
        end
        wait(0)
        
        if not sampIsDialogActive() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampTextdrawIsExists(idt) and not sampIsCursorActive() and not isPauseMenuActive() and window == 1 then --not amenu[0] and not report_window[0] and not clickwarp_working then
          ffi.C.SetCursorPos(sizeX/2, sizeY/2)
        end
        removePointMarker()
        if isKeyJustPressed(VK_RSHIFT) and not sampIsChatInputActive() then
            enAirBrake = not enAirBrake
            if enAirBrake then
                local posX, posY, posZ = getCharCoordinates(playerPed)
                airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
            end
        end
        if string.match(ini.binds.reoff, ",") then
          local b1, b2 = string.match(ini.binds.reoff, "(%d+),(%d+)")
          if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
            sampSendChat("/reoff")
            showCursor(false)
          end
        end
        if isKeyJustPressed(ini.binds.reoff) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
          sampSendChat("/reoff")
          showCursor(false)
        end

        if string.match(ini.binds.last_rep, ",") then
          local b1, b2 = string.match(ini.binds.last_rep, "(%d+),(%d+)")
          if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
            lua_thread.create(function()
              sampSetChatInputEnabled(true)
              wait(1)
              sampSetChatInputText("/pm "..repId.." 0 ")
            end)
          end
        end
        if isKeyJustPressed(ini.binds.last_rep) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
          lua_thread.create(function()
            sampSetChatInputEnabled(true)
            wait(1)
            sampSetChatInputText("/pm "..repId.." 0 ")
          end)
        end
        if string.match(ini.binds.bind_ot, ",") then
          local b1, b2 = string.match(ini.binds.bind_ot, "(%d+),(%d+)")
          if isKeyDown(b1) and isKeyDown(b2) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
            sampSendChat("/ot")
          end
        end
        if isKeyJustPressed(ini.binds.bind_ot) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
          sampSendChat("/ot")
        end
        if enAirBrake then
            local cx, cy, _ = getActiveCameraCoordinates()
            local px, py, _ = getActiveCameraPointAt()
            local camDirection = math.atan2( (px-cx), (py-cy) ) * 180 / math.pi
            renderFontDrawText(my_font, 'AirBreak - '..ini.main.speed_airbrake, sizeX / 1.2, sizeY / 1.03, 0xFFFFFFFF)
            if isCharInAnyCar(playerPed) then 
              heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
              setCarHeading(storeCarCharIsInNoSave(playerPed), - camDirection)
            else 
              heading = getCharHeading(playerPed) 
              setCharHeading(PLAYER_PED, - camDirection)
            end
            local angle = getHeadingFromVector2d(px - cx, py - cy)
            if isCharInAnyCar(playerPed) then difference = 0.79 else difference = 1.0 end
            setCharCoordinates(playerPed, airBrkCoords[1], airBrkCoords[2], airBrkCoords[3] - difference)
            if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
                if isKeyDown(VK_W) then
                airBrkCoords[1] = airBrkCoords[1] + ini.main.speed_airbrake * math.sin(-math.rad(angle))
                airBrkCoords[2] = airBrkCoords[2] + ini.main.speed_airbrake * math.cos(-math.rad(angle))
                if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle) else setCarHeading(storeCarCharIsInNoSave(playerPed), angle) end
                elseif isKeyDown(VK_S) then
                    airBrkCoords[1] = airBrkCoords[1] - ini.main.speed_airbrake * math.sin(-math.rad(heading))
                    airBrkCoords[2] = airBrkCoords[2] - ini.main.speed_airbrake * math.cos(-math.rad(heading))
                end
                if isKeyDown(VK_A) then
                    airBrkCoords[1] = airBrkCoords[1] - ini.main.speed_airbrake * math.sin(-math.rad(heading - 90))
                    airBrkCoords[2] = airBrkCoords[2] - ini.main.speed_airbrake * math.cos(-math.rad(heading - 90))
                elseif isKeyDown(VK_D) then
                    airBrkCoords[1] = airBrkCoords[1] - ini.main.speed_airbrake * math.sin(-math.rad(heading + 90))
                    airBrkCoords[2] = airBrkCoords[2] - ini.main.speed_airbrake * math.cos(-math.rad(heading + 90))
                end
                if isKeyDown(VK_SPACE) then airBrkCoords[3] = airBrkCoords[3] + ini.main.speed_airbrake / 2.0 end
                if isKeyDown(VK_LSHIFT) and airBrkCoords[3] > -95.0 then airBrkCoords[3] = airBrkCoords[3] - ini.main.speed_airbrake / 2.0 end
                save()
            end
        end
        if ini.main.is_gm then
          setCharProofs(playerPed, true, true, true, true, true)
          
          writeMemory(0x96916E, 1, 1, false)
          if isCharInAnyCar(PLAYER_PED) then
            setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
          end
        else
          setCharProofs(playerPed, false, false, false, false, false)
          writeMemory(0x96916E, 1, 0, false)
        if isCharInAnyCar(PLAYER_PED) then
          setCarProofs(veh, false, false, false, false, false)
        end
      end
    end
end

function flooder()
  if ini.main.ischecker then
    while true do wait(0)
      sampSendChat('/admins')
      wait(ini.main.delay_checker * 1000)
    end
  end
end

function cmd_test()
  for l=1, 8 do
    for i, v in ipairs(admins['list'][l]) do
      sampAddChatMessage(v[4], -1)
    end
  end
end

function time()
	startTime = os.time()                                               -- "Точка отсчёта"
    connectingTime = 0
    while true do
        wait(1000)
        nowTime = os.date("%H:%M:%S", os.time())
        if sampGetGamestate() == 3 then 								-- Игровой статус равен "Подключён к серверу" (Что бы онлайн считало только, когда, мы подключены к серверу)
	        sesOnline = sesOnline + 1 								-- Онлайн за сессию без учёта АФК
	        sesFull = os.time() - startTime 							-- Общий онлайн за сессию
	        sesAfk = sesFull - sesOnline							-- АФК за сессию

	        ini.onDay.online = ini.onDay.online + 1 					-- Онлайн за день без учёта АФК
	        ini.onDay.full = dayFull + sesFull 						-- Общий онлайн за день
	        ini.onDay.afk = ini.onDay.full - ini.onDay.online			-- АФК за день

	        ini.onWeek.online = ini.onWeek.online + 1 					-- Онлайн за неделю без учёта АФК
	        ini.onWeek.full = weekFull + sesFull 					-- Общий онлайн за неделю
	        ini.onWeek.afk = ini.onWeek.full - ini.onWeek.online		-- АФК за неделю

          local today = tonumber(os.date('%w', os.time()))
          ini.myWeekOnline[today] = ini.onDay.full

          connectingTime = 0
	    else
        connectingTime = connectingTime + 1                         -- Вермя подключения к серверу
	    	startTime = startTime + 1									-- Смещение начала отсчета таймеров
	    end
    end
end

function autoSave()
	while true do 
		wait(60000) -- сохранение каждые 60 секунд
		save()
	end
end

function addreport()
  sesreport = sesreport + 1
  ini.onDayReport.report = ini.onDayReport.report + 1
  ini.onWeekReport.report = ini.onWeekReport.report + 1
  local today = tonumber(os.date('%w', os.time()))
  ini.myWeekReport[today] = ini.onDayReport.report
  save()
end


--                  Имгуи Окна

  local newFrame = imgui.OnFrame(
      function() return amenu[0] end,
      function(player)
          imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
          imgui.SetNextWindowSize(imgui.ImVec2(1100, 640), imgui.Cond.FirstUseEver)

          imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
          imgui.Begin('##MainMenu', amenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar)

          imgui.SetCursorPos( imgui.ImVec2(15, 10) ) 
          imgui.BeginChild('##Title', imgui.ImVec2(900, 40), false)
            imgui.PushFont(imFont[25])
            imgui.TextColored(mc, u8('Arizona Tools'))
            imgui.SameLine()
            imgui.Text(u8('| '..navigation['selected']))
            imgui.PopFont()
          imgui.End()

        imgui.SetCursorPos( imgui.ImVec2(1070, 25) )
        imgui.CloseButton(6, amenu)

        imgui.SetCursorPos( imgui.ImVec2(0, 100) )
        imgui.BeginChild('##Buttons', imgui.ImVec2(250, 450), false)
        imgui.PushFont(imFont[18])
        imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.0, 0.5))
          for _, info in ipairs(navigation['buttons']) do
            if imgui.NavigateButton(navigation['selected'] == info[1], info[2], u8(info[1]) ) then 
              navigation['selected'] = info[1]
            end
          end
        imgui.PopStyleVar()
        imgui.PopFont()
        imgui.End()

        imgui.SetCursorPos( imgui.ImVec2(220, 50) )
        local p = imgui.GetCursorScreenPos()
        imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 880, p.y + 550), 0xFF202020, 15, 9)
        imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 880, p.y + 550), imgui.ColorConvertFloat4ToU32(mc), 15, 9, 1)
        imgui.SetCursorPos( imgui.ImVec2(235, 65) )
        imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
        imgui.BeginChild('##WorkSpace', imgui.ImVec2(850, 530), false, imgui.WindowFlags.NoBackground, imgui.WindowFlags.NoScrollbar)
          getContentMenu(navigation['selected'])
            imgui.End()
            imgui.PopStyleVar()
        imgui.End()
        imgui.PopStyleVar()
      end
  )

  local report = imgui.OnFrame(
      function() return report_window[0] end,
      function(player)
          imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
          imgui.SetNextWindowSize(imgui.ImVec2(500, 255), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_FA_PAPER_PLANE..u8" Ответ на репорт ", nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
          imgui.Text(u8'Репорт от: '..repNick..'['..repId..']')
          imgui.SameLine()
          imgui.TextDisabled(u8'<< Следить')
          if imgui.IsItemClicked() then
              imgui.BeginTooltip();
              sampSendChat("/re "..repId)
              imgui.EndTooltip();
          end
          if imgui.IsItemHovered() then
            imgui.BeginTooltip();
            imgui.TextUnformatted(u8"Нажмите для слежки");
            imgui.EndTooltip();
          end
          imgui.Separator()
          --repText
          local firstline = {}
          local secondline = {}
          local thirdline = {}

          for i = 0, #repText + 1, 1 do
            firstline[i] = repText:sub(i, i)
          end

          zz = 0

          for i, v in pairs(firstline) do
            if zz >= 70 or i == #firstline then
              table.insert(secondline, table.concat(thirdline, ""))

              thirdline = {}
              zz = 0
            end

            zz = zz + 1

            table.insert(thirdline, v)
          end

          for i, v in pairs(secondline) do
            if i == #secondline then
              tiretext = ""
            else
              tiretext = "-"
            end

            imgui.Text(u8(v .. tiretext))
	        end


          imgui.Separator()
          imgui.Text(u8'Тут будет сохранение репорта')
          imgui.Separator()
          imgui.PushItemWidth(490)
          imgui.InputText('##report_window_answer', inputs['report_window_answer'], 85)
          imgui.PopItemWidth()
          imgui.Separator() -- кнопки
          if imgui.Button(fa.ICON_FA_ROBOT..u8" Слежка за наруш",imgui.ImVec2(160,25)) then
            if string.match(repText, "%d+") then
              if lost_report then
                lua_thread.create(function()
                  wait(100)
                  sampSendChat("/pm "..repId.." 1 "..spying_report)
                  lost_report = false
                  enableDialog(true)
                  imgui.StrCopy(inputs['report_window_answer'], "")
                  sampCloseCurrentDialogWithButton(0)
                  sampSendChat("/re "..string.match(repText, "%d+"))
                  infoReport(spying_report)
                  addreport()
                end)
                report_window[0] = false
              else
                lua_thread.create(function()
                  wait(100)
                  sampSendDialogResponse(1334, 1, 0, spying_report)
                  enableDialog(true)
                  imgui.StrCopy(inputs['report_window_answer'], "")
                  sampCloseCurrentDialogWithButton(0)
                  sampSendChat("/re "..string.match(repText, "%d+"))
                  infoReport(spying_report)
                  addreport()
                end)
                report_window[0] = false
              end
            else
              sampAddChatMessage(tag_err.."ID не найден в тексте репорта!", -1)
            end
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_PEOPLE_CARRY..u8" Помочь автору",imgui.ImVec2(160,25)) then
            if lost_report then
              lua_thread.create(function()
                wait(100)
                sampSendChat("/pm "..repId.." 1 "..helping_report)
                lost_report = false
                enableDialog(true)
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                sampSendChat("/re "..repId)
                infoReport(helping_report)
                addreport()
              end)
              report_window[0] = false
            else
              lua_thread.create(function()
                wait(100)
                sampSendDialogResponse(1334, 1, 0, helping_report)
                enableDialog(true)
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                sampSendChat("/re "..repId)
                rInfo['id'] = repId
                infoReport(helping_report)
                addreport()
              end)
              report_window[0] = false
            end
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_COMMENTS..u8" Переслать в /a чат",imgui.ImVec2(160,25)) then
            local text = ("/a [Репорт] "..repNick.."["..repId.."]: "..repText)
            if (51 + text:len()) > 143 then
              sampAddChatMessage(tag_err..'Размер сообщений больше допустимого.', -1)
              return false
            else
              sampSendChat(text)
            end
          end
          if imgui.Button(fa.ICON_FA_MAP_MARKED..u8" Помощь по GPS",imgui.ImVec2(160,25)) then
            gps_window[0] = true
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_ADDRESS_BOOK..u8" LVL'a по работ",imgui.ImVec2(160,25)) then
            lvl_window[0] = true
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_STICKY_NOTE..u8" Список команд",imgui.ImVec2(160,25)) then
            cmd_window[0] = true
          end
          
          if imgui.Button(fa.ICON_FA_PALETTE..u8" Таблица цветов",imgui.ImVec2(160,25)) then
            color_window[0] = true
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_BOOK_OPEN..u8" Частые вопросы",imgui.ImVec2(160,25)) then
            question_window[0] = true
          end
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_HANDSHAKE..u8" Передать адм реп",imgui.ImVec2(160,25)) then
            if lost_report then
              lua_thread.create(function()
                wait(100)
                sampSendChat("/pm "..repId.." 1 "..send_report)
                lost_report = false
                enableDialog(true)
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                infoReport(send_report)
                sampSendChat("/a [Репорт] "..repNick.."["..repId.."]: "..repText)
                addreport()
              end)
              report_window[0] = false
            else
              lua_thread.create(function()
                wait(100)
                sampSendDialogResponse(1334, 1, 0, send_report)
                enableDialog(true)
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                infoReport(send_report)
                sampSendChat("/a [Репорт] "..repNick.."["..repId.."]: "..repText)
                addreport()
              end)
              report_window[0] = false
            end
          end

          if imgui.ButtonWithSettings(u8'Отправить', {rounding = 5, color = imgui.ImVec4(1, 0.3, 0.3, 1)}, imgui.ImVec2(160, 25)) then
            if #str(inputs['report_window_answer']) < 4 then
              sampAddChatMessage(tag_err..'Длина ответа менее 4х символов!', -1)
              return false
            end
            if lost_report then
              lua_thread.create(function()
                wait(100)
                sampSendChat("/pm "..repId.." 1 "..u8:decode(str(inputs['report_window_answer'])))
                infoReport(u8:decode(str(inputs['report_window_answer'])))
                lost_report = false
                enableDialog(true)
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                addreport()
              end)
              report_window[0] = false
            else
              lua_thread.create(function()
                wait(100)
                sampSendDialogResponse(1334, 1, 0, u8:decode(str(inputs['report_window_answer'])))
                infoReport(u8:decode(str(inputs['report_window_answer'])))
                enableDialog(true)
                imgui.StrCopy(inputs['report_window_answer'], "")
                sampCloseCurrentDialogWithButton(0)
                addreport()
              end)
              report_window[0] = false
            end
          end
          
          imgui.SameLine(335)
          if imgui.ButtonWithSettings(u8'Закрыть', {rounding = 5, color = imgui.ImVec4(1, 0.3, 0.3, 1)}, imgui.ImVec2(160, 25)) then
            lua_thread.create(function()
              wait(100)
              sampSendDialogResponse(1334, 0, 0, "")
              enableDialog(true)
              imgui.StrCopy(inputs['report_window_answer'], "")
              sampCloseCurrentDialogWithButton(0)
            end)
            lost_report = false
            report_window[0] = false
          end
          imgui.End()
      end
  )

  local gpsWindow = imgui.OnFrame(
    function() return gps_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(600, 600), imgui.Cond.FirstUseEver)
      imgui.Begin(fa.ICON_FA_MAP_MARKED..u8" Помощь по GPS ", gps_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
      imgui.PushItemWidth(590)
      imgui.NewInputText('##SearchBar', inputs['finding_gps'], 590, u8'Поиск по списку', 2)
      imgui.PopItemWidth()
      for i = 1, #gpsInfo do
        if #str(inputs['finding_gps']) == 0 or #str(inputs['finding_gps']) > 0 and gpsInfo[i]:find(str(inputs['finding_gps']), nil, true) then
          if imgui.Button(gpsInfo[i], imgui.ImVec2(590, 25)) then
            gpsbutton(i)
          end
        end
      end
      imgui.End()
    end
  )

  local lvlWindow = imgui.OnFrame(
    function() return lvl_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(220, 429), imgui.Cond.FirstUseEver)
      imgui.Begin(fa.ICON_FA_ADDRESS_BOOK..u8" Помощь по GPS ", lvl_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
      imgui.Text(u8"Таксист - 1 LVL")
      imgui.Text(u8"Водитель автобуса - 2 LVL")
      imgui.Text(u8"Механик - 3 LVL")
      imgui.Text(u8"Мусорщик - 3 LVL")
      imgui.Text(u8"Пожарныйы - 3 LVL")
      imgui.Text(u8"Металлоломщик - 4 LVL")
      imgui.Text(u8"Развозчик продуктов - 4 LVL")
      imgui.Text(u8"Машинист крана - 5 LVL")
      imgui.Text(u8"Дальнобойщик - 5 LVL")
      imgui.Text(u8"Продавец хот-догов - 5 LVL")
      imgui.Text(u8"Инкассатор - 6 LVL")
      imgui.Text(u8"Адвокат - 7 LVL")
      imgui.Text(u8"Водитель трамвая - 8 LVL")
      imgui.Text(u8"Работник налоговой - 10 LVL")
      imgui.Text(u8"Ремонтник дорог - 10 LVL")
      imgui.Text(u8"Нефтевышка - 10 LVL")
      imgui.Text(u8"Главный фермер - 15 LVL")
      imgui.Text(u8"Руководитель грузчиков - 15 LVL")
      imgui.Text(u8"Руководитель завода - 15 LVL")
      imgui.Text(u8"Машинист поезда - 15 LVL")
      imgui.Text(u8"Пилот - 19 LVL")
      imgui.End()
    end
  )

  local cmdWindow = imgui.OnFrame(
    function() return cmd_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(600,600), imgui.Cond.FirstUseEver)
      imgui.Begin(fa.ICON_FA_STICKY_NOTE..u8" Список команд ", cmd_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
      imgui.PushItemWidth(590)
      imgui.NewInputText('##SearchBarCmd', inputs['finding_cmd'], 590, u8'Поиск по списку', 2)
      imgui.PopItemWidth()
      for i = 1, #cmdInfo do
        if #str(inputs['finding_cmd']) == 0 or #str(inputs['finding_cmd']) > 0 and cmdInfo[i]:find(str(inputs['finding_cmd']), nil, true) then
          if imgui.Button(cmdInfo[i], imgui.ImVec2(590, 25)) then
            cmdbutton(i)
          end
        end
      end
      imgui.End()
    end
  )

  local colorWindow = imgui.OnFrame(
    function() return color_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(1510,736), imgui.Cond.FirstUseEver)
      imgui.Begin(fa.ICON_FA_PALETTE..u8" Таблица цветов ", color_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
      imgui.Image(img, imgui.ImVec2(1500,700))
      imgui.End()
    end
  )

  local questionWindow = imgui.OnFrame(
    function() return question_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(800,600), imgui.Cond.FirstUseEver)
      imgui.Begin(fa.ICON_FA_BOOK_OPEN..u8" Частые вопросы", question_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
      imgui.NewInputText('##SearchBarQuestion', inputs['finding_question'], 790, u8'Поиск по списку', 2)
      for i = 1, #questionInfo do
        if #str(inputs['finding_question']) == 0 or #str(inputs['finding_question']) > 0 and questionInfo[i]:find(str(inputs['finding_question']), nil, true) then
          if imgui.Button(questionInfo[i], imgui.ImVec2(790, 25)) then
            questionbutton(i)
          end
        end
      end
      imgui.End()
    end
  )

  local fastmenuWindow = imgui.OnFrame(
    function() return fastmenuwindow[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 1.5, sizeY / 1.5), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
      imgui.Begin("##fasfdffgfmenu", fastmenuwindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)
      local c = imgui.ImVec4(fc[0], fc[1], fc[2], fc[3]) 
      ini.customcolor[sampGetPlayerNickname(fastmenu_id)] = imgui.ColorConvertFloat4ToU32(c)
      save()
      imgui.SetCursorPos( imgui.ImVec2(15, 10) ) 
      imgui.BeginChild('##TitleFastmenu', imgui.ImVec2(240, 40), false)
        imgui.PushFont(imFont[16])
        imgui.TextColored(mc, u8('Быстрое меню'))
        imgui.SameLine()
        imgui.Text(u8('| '..sampGetPlayerNickname(fastmenu_id)))
        imgui.PopFont()
      imgui.End()
      imgui.SetCursorPos( imgui.ImVec2(280, 20) )
      imgui.CloseButton(7, fastmenuwindow)
      imgui.SetCursorPos(imgui.ImVec2(10,20))
      imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(8, 8))
      
      imgui.BeginChild('##WorkSpaceFastmenu', imgui.ImVec2(290, 400), false, imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
        imgui.NewLine()
        if imgui.Button(u8"Следить", imgui.ImVec2(280,30)) then
          sampSendChat("/re "..fastmenu_id)
          fastmenuwindow[0] = false
        end
        if imgui.Button(u8"Написать в PM", imgui.ImVec2(280,30)) then
          lua_thread.create(function()
            fastmenuwindow[0] = false
            sampSetChatInputEnabled(true)
            wait(1)
            sampSetChatInputText("/pm "..fastmenu_id.." 1 ")
          end)
        end
        if imgui.Button(u8"Слапнуть", imgui.ImVec2(280,30)) then
          sampSendChat("/slap "..fastmenu_id.." 1")
          fastmenuwindow[0] = false
        end
        if imgui.Button(u8"Репорт", imgui.ImVec2(280,30)) then
          sampSendChat("/pm "..fastmenu_id.." 1 ОТВЕЧАЕМ НА РЕПОРТ!!!")
          fastmenuwindow[0] = false
        end
        imgui.Text(u8'Цвет админа: ')
        imgui.SameLine()
        addons.ToggleButton("##sdfjun", toggle_newcustomcolor)
        imgui.SameLine()
        if toggle_newcustomcolor[0] then
          imgui.ColorEdit4("##customcolornick", fc, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha)
        else
          ini.customcolor[sampGetPlayerNickname(fastmenu_id)] = ini.color[fastmenu_lvl]
          save()
        end
        ini.customcolor_status[sampGetPlayerNickname(fastmenu_id)] = toggle_newcustomcolor[0]
        save()
        imgui.NewLine()
        imgui.Separator()
        imgui.NewLine()
        if ini.notes[sampGetPlayerNickname(fastmenu_id)] then
          imgui.StrCopy(notesAdmin, u8(ini.notes[sampGetPlayerNickname(fastmenu_id)]))
        else
          imgui.StrCopy(notesAdmin, '')
        end
        if #str(notesAdmin) == 0 then
          ini.notes[sampGetPlayerNickname(fastmenu_id)] = nil
          save()
        end
        imgui.PushItemWidth(280)
        if imgui.InputTextWithHint("##notesAdmin", u8"Заметки", notesAdmin, sizeof(notesAdmin)) then
          ini.notes[sampGetPlayerNickname(fastmenu_id)] = u8:decode(str(notesAdmin))
          save()
        end
        imgui.CenterTextColored(imgui.ImVec4(71, 71, 71, 0.5), u8"очистить")
        if imgui.IsItemClicked() then
          imgui.BeginTooltip()
          ini.notes[sampGetPlayerNickname(fastmenu_id)] = ""
          save()
          imgui.EndTooltip()
        end
      imgui.End()
      imgui.PopStyleVar()
    end
  )

  local getipWindow = imgui.OnFrame(
    function() return getip_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(600, 130), imgui.Cond.FirstUseEver)
      imgui.Begin(fa.ICON_FA_ADDRESS_CARD..u8" Проверка IP ##", getip_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
      imgui.CenterTextColoredSameLine(mc, u8"[Ник] ")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), string.format("%s |", ipnick)) 
      imgui.CenterTextColoredSameLine(mc, u8"R-IP ")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), string.format("[%s] ", rdata[1]["query"]))
      imgui.CenterTextColoredSameLine(mc, u8"A-IP ")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), string.format("[%s] ", getipip2))
      imgui.CenterTextColoredSameLine(mc, u8"L-IP ")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), string.format("[%s] ", rdata[2]["query"]))
      imgui.NewLine()
      imgui.CenterTextColoredSameLine(mc, u8"[Страна] REG -")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), u8(string.format("%s |", rdata[1]["country"])))
      imgui.CenterTextColoredSameLine(mc, u8"Last -")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), u8(string.format("%s", rdata[2]["country"])))
      imgui.NewLine()
      imgui.CenterTextColoredSameLine(mc, u8"[Город] REG -")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), u8(string.format("%s |", rdata[1]["city"])))
      imgui.CenterTextColoredSameLine(mc, u8"Last - ")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), u8(string.format("%s", rdata[2]["city"])))
      imgui.NewLine()
      imgui.CenterTextColoredSameLine(mc, u8"[Провайдер] REG -")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), u8(string.format("%s |", rdata[1]["isp"])))
      imgui.CenterTextColoredSameLine(mc, u8"Last -")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), u8(string.format("%s", rdata[2]["isp"])))
      imgui.NewLine()
      imgui.CenterTextColoredSameLine(mc, u8"Расстояние между городами:")
      imgui.CenterTextColoredSameLine(imgui.ImVec4(255,255,255,1), u8(string.format("[~%s]", math.ceil(distances))))
      imgui.CenterTextColoredSameLine(mc, u8"км.")
      imgui.End()
    end
  )

  local onlineWindow = imgui.OnFrame(
    function() return online_window[0] end,
    function(player)
      imgui.SetNextWindowSize(imgui.ImVec2(400, 230), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8'#WeekOnline', nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
      imgui.SetCursorPos(imgui.ImVec2(15, 10))
      imgui.CenterTextColored(mc, u8'Онлайн за неделю: ')
      imgui.CenterTextColored(imgui.ImVec4(255,255,255,1), get_clock(ini.onWeek.full))
      imgui.CenterTextColored(mc, u8'Репорт за неделю: ')
      imgui.CenterTextColored(imgui.ImVec4(255,255,255,1), tostring(ini.onWeekReport.report))
      imgui.NewLine()
      for day = 1, 6 do -- ПН -> СБ
          imgui.Text(u8(tWeekdays[day])); imgui.SameLine(150)
          imgui.Text(get_clock(ini.myWeekOnline[day]))
          imgui.SameLine()
          imgui.Text("[R]:"..tostring(ini.myWeekReport[day]))
      end 
      --> ВС
      imgui.Text(u8(tWeekdays[0])); imgui.SameLine(150)
      imgui.Text(get_clock(ini.myWeekOnline[0]))
      imgui.SameLine()
      imgui.Text("[R]:"..tostring(ini.myWeekReport[0]))

      imgui.NewLine()
      imgui.SetCursorPosX((imgui.GetWindowWidth() - 200) / 2)
      if imgui.Button(u8'Закрыть', imgui.ImVec2(200, 25)) then online_window[0] = false end
      imgui.End()
    end
  )
  
  imgui.OnFrame( function () return reconinfo_window[0] and not isGamePaused() end,
    function()
      imgui.SetNextWindowPos(imgui.ImVec2(admins['posstatsrecon'].x, admins['posstatsrecon'].y)) 
      imgui.SetNextWindowSize(imgui.ImVec2(400, 355), imgui.Cond.FirstUseEver)
      imgui.Begin("##reconstatswdfindow", nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoFocusOnAppearing)
      imgui.CenterTextColored(mc, rInfo['name'].."["..rInfo['id'].."]")
      imgui.Hint("copynick_recon", u8"Нажмите для копирования")
      if imgui.IsItemClicked() then
        imgui.BeginTooltip()
        setClipboardText(rInfo['name'])
        sampAddChatMessage(tag.."Ник успешно скопирован.", -1)
        imgui.EndTooltip()
      end
      if rInfo['lvl'] and rInfo['ping'] and rInfo['hp'] and rInfo['exp'] and rInfo['afk'] and rInfo['arm'] and rInfo['shot'] and rInfo['ammo'] and rInfo['warn'] and rInfo['tshot'] and rInfo['speed'] then
        imgui.Columns(4, "ReconStats", true)
        imgui.Separator()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Уровень") 
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        rInfo['lvl'] = sampGetPlayerScore(rInfo['id'])
        imgui.Text(tostring(rInfo['lvl'])) 
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Опыт") 
        imgui.NextColumn() 
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['exp'])
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Пинг")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['ping'])
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"АФК")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(tostring(rInfo['afk']) or "loading..")
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Здоровье")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['hp'])
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Бронь")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['arm'])
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Оружие/ПТ")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['ammo'])
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Shot общее")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['shot'])
        imgui.NextColumn()
        imgui.Separator()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text("Warns")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8(rInfo['warn']))
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Shot в /re")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['tshot'])
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Фракция")
        imgui.NextColumn()
        
        imgui.SetColumnWidth(-1, 100)
        if rInfo['org'] then
          fracr = rInfo['org']
          isfrac = true
        elseif rInfo['org'] == "Без фракции" then
          fracr = "НЕТ"
        else
          fracr = "Неизвестно"
        end
        local firstline = {}
        local secondline = {}
        local thirdline = {}

        for i = 0, #fracr + 1, 1 do
          firstline[i] = fracr:sub(i, i)
        end

        zz = 0

        for i, v in pairs(firstline) do
          if zz >= 13 or i == #firstline then
            table.insert(secondline, table.concat(thirdline, ""))

            thirdline = {}
            zz = 0
          end

          zz = zz + 1

          table.insert(thirdline, v)
        end

        for i, v in pairs(secondline) do
          if i == #secondline then
            tiretext = ""
          else
            tiretext = "-"
          end
          if rInfo['org'] == "Неизвестно" then
            imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8(v .. tiretext))
          elseif fracr == "Без фракции" then
            imgui.TextColored(imgui.ImVec4(255, 255, 0, 1), u8(v .. tiretext))
          else
            imgui.TextColored(imgui.ImVec4(0, 255, 0, 1), u8(v .. tiretext))
            if imgui.IsItemClicked() then
              imgui.BeginTooltip()
              sampSendChat("/members")
              imgui.EndTooltip()
            end
          end
        end
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Ранг")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8(rInfo['rank']:match("%d+") or "0"))
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Separator()
        imgui.Text(u8"Скорость")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8(rInfo['speed']))
        imgui.NextColumn()
        local skin = sampGetPlayerSkin(rInfo['id'])
        if not skin then
          skin = "-1"
        end
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Скин")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(tostring(skin))
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Игра")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        if rInfo['client'] == "Неизвестно" then
          imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8(rInfo['client']))
        else
          imgui.TextColored(imgui.ImVec4(0, 255, 0, 1), u8(rInfo['client']))
        end
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Защита")
        imgui.SameLine()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['protect'] or "0")
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Регенерация")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['regen'] or "0")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Урон")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(rInfo['force'] or "0")
        imgui.Separator()
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Камень TP")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        if rInfo['lasttp'] then
          checkertp = "Использовал"
          imgui.TextColored(imgui.ImVec4(85, 255, 0, 1), u8(checkertp))
        else
          checkertp = "Не использ."
          imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8(checkertp))
        end
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        imgui.Text(u8"Камень GM")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 100)
        if rInfo['iskamen'] then
          checkerkamen = "Использовал"
          imgui.TextColored(imgui.ImVec4(85, 255, 0, 1), u8(checkerkamen))
        else
          checkerkamen = "Не использ."
          imgui.TextColored(imgui.ImVec4(255, 0, 0, 1), u8(checkerkamen))
        end
        imgui.Columns(1)
        imgui.Separator()
      else
        rInfo['lvl'] = "-"
				rInfo['ping'] = "-"
				rInfo['hp'] = "-"
				rInfo['exp'] = "-"
				rInfo['afk'] = 0
				rInfo['arm'] = "-"
				rInfo['shot'] = "-"
				rInfo['ammo'] = "-"
				rInfo['warn'] = "-"
				rInfo['tshot'] = "-"
				rInfo['speed'] = "-"
      end

      local result, handleRec = sampGetCharHandleBySampPlayerId(rInfo['id'])

			if rInfo['cars'] and tonumber(rInfo['afk']) < 2 and result and isCharInAnyCar(handleRec) then
				carHundle = storeCarCharIsInNoSave(handleRec)
        if getCarModel(carHundle) > 400 and getCarModel(carHundle) < 611 then
          carName = cars[getCarModel(carHundle)-399]
        elseif getCarModel(carHundle) > 611 then
          carName = special_cars[getCarModel(carHundle)]
        end
      
				imgui.NewLine()
				imgui.SameLine(115)
				imgui.CenterTextColored(mc, u8("[" .. carName .. "]"))
				imgui.Columns(4)
				imgui.Separator()
				imgui.SetColumnWidth(-1, 75)
				imgui.Text(u8("ХП Т/С"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 80)
				imgui.Text(u8(rInfo['carhp']))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 80)
				imgui.Text(u8("Двигатель"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 80)
				imgui.Text(u8(rInfo['engine'] or "-"))
				imgui.NextColumn()
				imgui.Separator()
				imgui.SetColumnWidth(-1, 75)
				imgui.Text(u8("TwinTurbo"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 80)
				imgui.Text(u8(rInfo['twint'] or "-"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 80)
				imgui.Text(u8("ИД Т/С"))
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 80)
				imgui.Text(u8(rInfo['carid'] or "-1"))
				imgui.Columns(1)
        imgui.Separator()
			end
      imgui.End()
    end
  ).HideCursor = true

  imgui.OnFrame(function() return recon_window[0] and not isGamePaused() end,
    function()
      imgui.SetNextWindowPos(imgui.ImVec2(admins['posrecon'].x, admins['posrecon'].y)) 
      imgui.SetNextWindowSize(imgui.ImVec2(550, 88), imgui.Cond.FirstUseEver)
      imgui.Begin("##reconwinddofdwff", nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoFocusOnAppearing)
	    imgui.SetCursorPos(imgui.ImVec2(5, 33))
      
      if imgui.Button(u8("<< Back"), imgui.ImVec2(60, 21)) then
        if rInfo['id'] == "0" then
          sampAddChatMessage(tag_err.."Невозможно! Достигнут минимальный ID", -1)
        else
          rInfo['id'] = rInfo['id'] - 1
          sampSendChat('/re '..rInfo['id'])
        end
      end
    
      imgui.SetCursorPos(imgui.ImVec2(70, 6))
    
      if imgui.Button(u8("Stats")) then
        sampSendChat("/check " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Реги")) then
        sampSendChat("/getip " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Спавн")) then
        sampSendChat("/spplayer " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("UP"), imgui.ImVec2(30, 21)) then
        sampSendChat("/Slap " .. rInfo['id'] .. " 1")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("DOWN")) then
        sampSendChat("/Slap " .. rInfo['id'] .. " 2")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Разморозить")) then
        sampSendChat("/unfreeze " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Заморозить")) then
        sampSendChat("/freeze " .. rInfo['id'])
      end
    
      imgui.SetCursorPos(imgui.ImVec2(70, 33))
    
      if imgui.Button(u8("ТП к себе")) then
        lua_thread.create(function ()
          lastid = rInfo['id']
          sampSendChat('/reoff')
          wait(500)
          sampSendChat('/gethere '..lastid)
        end)
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Выдать HP")) then
        sampSetChatInputEnabled(true)
        sampSetChatInputText("/sethp " .. rInfo['id'] .. "  100")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/weap")) then
        sampSetChatInputEnabled(true)
        sampSetChatInputText("/weap " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Наказания")) then
        sampSendChat("/checkpunish " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Skill gun")) then
        sampSendChat("/checkskills " .. rInfo['id'] .. " 1")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/iwep"), imgui.ImVec2(50, 21)) then
        sampSendChat("/iwep " .. rInfo['id'])
      end
    
      imgui.SetCursorPos(imgui.ImVec2(70, 60))
    
      if imgui.Button(u8("Вы тут?")) then
        sampSendChat("/pm " .. rInfo['id'] .. " 1 " .. rInfo['name'] .. "[" .. rInfo['id'] .. "] Вы тут????")
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/plveh")) then
        sampSetChatInputEnabled(true)
    
        local cursorotstup = 8
    
        if tonumber(rInfo['id']) < 10 then
          cursorotstup = cursorotstup + 1
        elseif tonumber(rInfo['id']) < 100 and tonumber(rInfo['id']) >= 10 then
          cursorotstup = cursorotstup + 2
        elseif tonumber(rInfo['id']) < 1000 and tonumber(rInfo['id']) >= 100 then
          cursorotstup = cursorotstup + 3
        end
    
        sampSetChatInputText("/plveh " .. rInfo['id'] .. "  1")
        sampSetChatInputCursor(cursorotstup, cursorotstup)
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/pgetip ")) then
        sampSendChat("/pgetip " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Флип"), imgui.ImVec2(50, 21)) then
        sampSendChat("/flip " .. rInfo['id'])
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("ТП к игроку")) then
        lua_thread.create(function ()
          lastid = rInfo['id']
          sampSendChat("/reoff")
          wait(500)
          sampSendChat("/goto "..lastid)
        end)
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("/az")) then
        lua_thread.create(function ()
          lastid = rInfo['id']
          sampSendChat("/reoff")
          wait(500)
          sampSendChat("/az "..lastid)
          sampAddChatMessage("ID: " .. lastid .. " телепортирован в админ комнату.", 16711680)
        end)
      end
    
      imgui.SameLine()
    
      if imgui.Button(u8("Выйти")) then
        sampSendChat("/reoff")
      end
    
      imgui.SameLine()
      imgui.SetCursorPos(imgui.ImVec2(480, 33))
    
      if imgui.Button(u8("Next >>")) then
        if rInfo['id'] == "999" then
          sampAddChatMessage(tag_err.."Невозможно! Достигнут максимальный ID", -1)
        else
          rInfo['id'] = rInfo['id'] + 1
          sampSendChat("/re "..rInfo['id'])
        end
      end
      imgui.End()
    end
  ).HideCursor = true

  imgui.OnFrame(function() return stats_window[0] and not isGamePaused() end,
    function()
      imgui.SetNextWindowPos(imgui.ImVec2(admins['posstats'].x, admins['posstats'].y+5)) 
      imgui.SetNextWindowSize(imgui.ImVec2(550, 88), imgui.Cond.FirstUseEver)
      imgui.Begin("##Statswindow", nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoFocusOnAppearing)
      if ini.main.rep then
        imgui.TextColored(mc, u8"Ваша репутация: ")
        imgui.SameLine()
        imgui.Text(tostring(selfrep)) 
      end
      if ini.main.repses then
        imgui.TextColored(mc, u8"Репорт за сессию: ")
        imgui.SameLine()
        imgui.Text(tostring(sesreport))
      end
      if ini.main.repday then
        imgui.TextColored(mc, u8"Репорт за день: ")
        imgui.SameLine()
        imgui.Text(tostring(ini.onDayReport.report))
      end
      if ini.main.repweek then
        imgui.TextColored(mc, u8"Репорт за неделю: ")
        imgui.SameLine()
        imgui.Text(tostring(ini.onWeekReport.report)) 
      end
      if ini.main.onlinsession then
        imgui.TextColored(mc, u8"Онлайн за сессию: ")
        imgui.SameLine()
        imgui.Text(tostring(get_clock(sesOnline)))
      end
      if ini.main.fullonlineses then
        imgui.TextColored(mc, u8"Общий за сессию: ")
        imgui.SameLine()
        imgui.Text(tostring(get_clock(sesFull)))
      end
      if ini.main.afkses then 
        imgui.TextColored(mc, u8"АФК за сессию: ")
        imgui.SameLine()
        imgui.Text(tostring(get_clock(sesAfk)))
      end
      if ini.main.onlineday then
        imgui.TextColored(mc, u8"Онлайн за день ")
        imgui.SameLine()
        imgui.Text(tostring(get_clock(ini.onDay.online)))
      end
      if ini.main.fullonlineday then
        imgui.TextColored(mc, u8"Общий за день ")
        imgui.SameLine()
        imgui.Text(tostring(get_clock(ini.onDay.full)))
      end
      if ini.main.afkday then
        imgui.TextColored(mc, u8"АФК за день ")
        imgui.SameLine()
        imgui.Text(tostring(get_clock(ini.onDay.afk)))
      end
      if ini.main.onlineweek then
        imgui.TextColored(mc, u8"Онлайн за неделю ")
        imgui.SameLine()
        imgui.Text(tostring(get_clock(ini.onWeek.online)))
      end
      if ini.main.fullonlineweek then
        imgui.TextColored(mc, u8"Общий за неделю ")
        imgui.SameLine()
        imgui.Text(tostring(get_clock(ini.onWeek.full)))
      end
      if ini.main.afkweek then
        imgui.TextColored(mc, u8"АФК за неделю ")
        imgui.SameLine()
        imgui.Text(tostring(get_clock(ini.onWeek.afk)))
      end
      imgui.End()
    end
  ).HideCursor = true
  
  local amemberWindow = imgui.OnFrame(
    function() return amember_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(400, 400), imgui.Cond.FirstUseEver)
      imgui.Begin(u8("Выберите организацию"), amember_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoSavedSettings)

      for k, v in pairs(fracsAmember) do
        if imgui.Button(u8("Вступить во фракцию - [" .. k .. "] " .. v), imgui.ImVec2(397, 20)) then
          sampSendChat("/amember " .. k .. " 9")
        end
      end
    end
  )

  local tpWindow = imgui.OnFrame(
    function() return tp_window[0] end,
    function(player)
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.SetNextWindowSize(imgui.ImVec2(533, 407), imgui.Cond.FirstUseEver)
      imgui.Begin(u8("TP MENU##ter"), tp_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoSavedSettings)
      imgui.BeginChild("##cr", imgui.ImVec2(133, 370), false, imgui.WindowFlags.NoScrollbar)

      if imgui.Button(u8("Фракции"), imgui.ImVec2(125, 20)) then
        fractp = true
      end

      if imgui.Button(u8("Свои поизиции"), imgui.ImVec2(125, 20)) then

      end

      if imgui.Button(u8("Тп по метке"), imgui.ImVec2(125, 20)) then
        local result, bx, by, bz = getTargetBlipCoordinatesFixed()

        if result then
          sendClickMap(bx, by, bz)

          tp_window[0] = false

          printStringNow("TP MAP", 1000)
        else
          sampAddChatMessage(tag_err..'Метка не найдена!', -1)
        end
      end

      imgui.EndChild()
      imgui.SameLine()
      imgui.BeginChild("##crf", imgui.ImVec2(387, 370), false)

      if fractp then
        for k, v in pairs(fracsAmember) do
          if imgui.Button(u8("[" .. k .. "] ТП на спавн " .. v), imgui.ImVec2(370,20)) then
            sampSendChat("/tp " .. k)
            printStringNow("TP Fraction", 1000)

            tp_window[0] = false
          end
        end
      end

      imgui.EndChild()
      imgui.End()
    end
  )

  imgui.OnInitialize(function()
    imFont = {}
    local config = imgui.ImFontConfig()
    config.MergeMode, config.PixelSnapH = true, true
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local iconRanges = new.ImWchar[3](fa.min_range, fa.max_range, 0)
    local mainFont = getFolderPath(0x14) .. '\\trebucbd.ttf'
    local iconFont = getWorkingDirectory() .. '\\Arizona Tools\\fonts\\fa-solid-900.ttf'
    img = imgui.CreateTextureFromFile(getGameDirectory() .. '\\moonloader\\Arizona Tools\\images\\color.jpg') 
   	imgui.GetIO().Fonts:Clear()
   	imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 15.0, nil, glyph_ranges)
   	imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 15.0, config, iconRanges)

   	imFont[11] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 11.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 11.0, config, iconRanges)

    imFont[16] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 16.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 16.0, config, iconRanges)

    imFont[18] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 18.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 18.0, config, iconRanges)

    imFont[25] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 25.0, nil, glyph_ranges)
    imgui.GetIO().Fonts:AddFontFromFileTTF(iconFont, 25.0, config, iconRanges)
    
    imFont[50] = imgui.GetIO().Fonts:AddFontFromFileTTF(mainFont, 50.0, nil, glyph_ranges)

    theme()
  end)

  function getContentMenu(section)
    if section == navigation['buttons'][1][1] then -- Основное
      ini.forms.tag = str(admins['forms']['tag'])
      ini.main.pass_acc = base64.encode(str(admins['profile']['passacc']))
      ini.main.pass_adm = str(admins['profile']['passadm'])
      ini.main.auto_az = toggles['autoaz'][0]
      ini.main.flood_ot = toggles['floodot'][0]
      ini.main.getipwindow = toggles['getipwindow'][0]
      ini.main.statswindow = toggles['statswindow'][0]
      ini.main.onlinsession = toggles['onlinsession'][0]
      ini.main.fullonlineses = toggles['fullonlineses'][0]
      ini.main.afkses = toggles['afkses'][0]
      ini.main.onlineday = toggles['onlineday'][0]
      ini.main.fullonlineday = toggles['fullonlineday'][0]
      ini.main.afkday = toggles['afkday'][0]
      ini.main.onlineweek = toggles['onlineweek'][0]
      ini.main.fullonlineweek = toggles['fullonlineweek'][0]
      ini.main.afkweek = toggles['afkweek'][0]
      ini.main.rep = toggles['rep'][0]
      ini.main.repses = toggles['repses'][0]
      ini.main.repday = toggles['repday'][0]
      ini.main.repweek = toggles['repweek'][0]
      ini.main.autoprefix = toggles['autoprefix'][0]
      save()
      imgui.BeginGroup() -- Левая колонка

      imgui.SubTitle(u8"Информация:")
      local strCol = ABGRtoStringRGB(ini.style.color)
      imgui.TextColoredRGB(u8(('Ваш аккаунт: %s%s[%s]'):format(strCol, self.nick, self.gameState == 3 and id or 'OFF')))
      imgui.TextColoredRGB(u8(('Уровень: %s%s[%s]'):format(strCol, admNames[tonumber(ini.main.lvl_adm)], ini.main.lvl_adm)))
      imgui.Hint("lvldada", u8"В случае ошибочного отображения уровня, введите /admins")
      imgui.Text(u8'Ваш тег: ')
      imgui.SameLine()
      imgui.PushItemWidth(75)
      imgui.InputText('##tag_adm', admins['forms']['tag'], sizeof(admins['forms']['tag']))
      imgui.PopItemWidth()
      imgui.Text(u8'Пример: Чит '..str(admins['forms']['tag']))
      imgui.NewLine()
      imgui.SubTitle(u8"Пароли:")
      imgui.TextColored(mc, ">> ")
      imgui.SameLine()
      imgui.Text(u8"Пароль от аккаунта: ")
      
      imgui.PushItemWidth(150)
      if pass_acc_see then
          imgui.InputTextWithHint('##pass_acc', u8"По желанию", admins['profile']['passacc'], sizeof(admins['profile']['passacc']))
      else
          imgui.InputTextWithHint('##pass_acc', u8"По желанию", admins['profile']['passacc'], sizeof(admins['profile']['passacc']), imgui.InputTextFlags.Password)
      end
      imgui.PopItemWidth()
      imgui.SameLine()
      imgui.Text(fa.ICON_FA_EYE..'')
      if imgui.IsItemClicked() then
          imgui.BeginTooltip();
          pass_acc_see = not pass_acc_see
          imgui.EndTooltip();
      end
      imgui.Hint("passsee", u8"Отображение пароля в окне ввода")
      imgui.TextColored(mc, ">> ")
      imgui.SameLine()
      imgui.Text(u8"Админ пароль: ")
      imgui.PushItemWidth(150)
      if pass_acc_see_adm then
          imgui.InputTextWithHint('##pass_adm', u8"По желанию", admins['profile']['passadm'], sizeof(admins['profile']['passadm']))
      else
          imgui.InputTextWithHint('##pass_adm', u8"По желанию", admins['profile']['passadm'], sizeof(admins['profile']['passadm']), imgui.InputTextFlags.Password)
      end
      imgui.PopItemWidth()
      imgui.SameLine()
      imgui.Text(fa.ICON_FA_EYE..'')
      if imgui.IsItemClicked() then
          imgui.BeginTooltip();
          pass_acc_see_adm = not pass_acc_see_adm
          imgui.EndTooltip();
      end
      imgui.Hint("passseesad", u8"Отображение пароля в окне ввода")
      imgui.NewLine()
      
      imgui.EndGroup()
      imgui.SameLine(400)
      imgui.BeginGroup() -- Правая колонка
      imgui.SubTitle(u8"Настройки:")
      imgui.Text(u8'Авто /az: ')
      imgui.SameLine()
      addons.ToggleButton("##4523", toggles['autoaz'])
      
      imgui.Text(u8"Отключить флуд репорта: ")
      imgui.SameLine()
      addons.ToggleButton("##turnofffloodbyot", toggles['floodot'])
      imgui.SameLine()
      imgui.Question("passseesdf", u8"Удаляет из чата строки по типу:\n[Ошибка] Сейчас нет вопросов в репорт!")
      
      
      imgui.Text(u8"/getip в окне: ")
      imgui.SameLine()
      addons.ToggleButton("##getipwindow", toggles['getipwindow'])
      imgui.Text(u8"Окно статистики: ")
      imgui.SameLine()
      addons.ToggleButton("##statswindow", toggles['statswindow'])
      if toggles['statswindow'] then
        imgui.SameLine()
        imgui.TextDisabled(fa.ICON_FA_COG)
        if imgui.IsItemClicked() then
          imgui.OpenPopup(u8'Настройки статистики')
        end
        if imgui.BeginPopupModal(u8'Настройки статистики') then
          imgui.SetNextWindowSize(imgui.ImVec2(200,200))
          imgui.Text(u8'Местоположение окна статистики: ')
          imgui.SameLine()
            if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##statsPosition', imgui.ImVec2(33, 20)) then
              lua_thread.create(function()
                local backup = {
                  ['x'] = ini.main.statsx,
                  ['y'] = ini.main.statsy
                }
                ChangePosStats = true
                showCursor(true)
                amenu[0] = false
                sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
                if not sampIsChatInputActive() then
                  while not sampIsChatInputActive() and ChangePosStats do
                    showCursor(true)
                      wait(0)
                      showCursor(true)
                      ini.main.statsx, ini.main.statsy = getCursorPos()
                      local cX, cY = getCursorPos()
                      admins['posstats'].x = cX
                      admins['posstats'].y = cY
                      if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                        showCursor(false)
                        ChangePosStats = false
                        sampAddChatMessage(tag..'Позиция сохранена!', -1)
                      elseif isKeyJustPressed(VK_ESCAPE) then
                        ChangePosStats = false
                        showCursor(false)
                        admins['posstats'].x = backup['x']
                        admins['posstats'].y = backup['y']
                        sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                      end
                  end
                end
                ini.main.statsx = admins['posstats'].x
                ini.main.statsy = admins['posstats'].y 
                showCursor(false)
                ChangePosStats = false
                amenu[0] = true
                end)
              end
          imgui.NewLine()
          imgui.Text(u8"Количество репутации: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##rep", toggles['rep'])
          imgui.Text(u8"Репорт за сессию: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##repses", toggles['repses'])
          imgui.Text(u8"Репорт за день: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##repday", toggles['repday'])
          imgui.Text(u8"Репорт за неделю: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##repweek", toggles['repweek'])
          imgui.Separator()
          imgui.Text(u8"Онлайн за сессию: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##onlinsession", toggles['onlinsession'])
          imgui.Text(u8"Общий онлайн за сессию(с АФК): ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##fullonlineses", toggles['fullonlineses'])
          imgui.Text(u8"АФК за сессию: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##afkses", toggles['afkses'])
          imgui.Text(u8"Онлайн за день: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##onlineday", toggles['onlineday'])
          imgui.Text(u8"Общий онлайн за день(с АФК): ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##fullonlineday", toggles['fullonlineday'])
          imgui.Text(u8"АФК за день: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##afkday", toggles['afkday'])
          imgui.Text(u8"Онлайн за неделю: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##onlineweek", toggles['onlineweek'])
          imgui.Text(u8"Общий онлайн за неделю(с АФК): ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##fullonlineweek", toggles['fullonlineweek'])
          imgui.Text(u8"АФК за неделю: ")
          imgui.SameLine()
          imgui.SetCursorPosX(250)
          addons.ToggleButton("##afkweek", toggles['afkweek'])
          if imgui.Button(u8' Закрыть', imgui.ImVec2(270, 20)) then
              imgui.CloseCurrentPopup()
          end
          imgui.EndPopup()
        end
      end
      imgui.Text(u8"Авто префикс: ")
      imgui.SameLine()
      addons.ToggleButton("##autoprefix", toggles['autoprefix'])

      -- imgui.Text(u8"Скин при авторизации: ")
      -- imgui.SameLine()
      -- imgui.PushItemWidth(100)
      -- imgui.InputInt("##")
      imgui.PopItemWidth()
      imgui.EndGroup()
    elseif section == navigation['buttons'][2][1] then -- Читы
      ini.main.traicers = toggles['traicers'][0]
      ini.main.whcar = toggles['whcar'][0]
      ini.main.is_clickwarp = toggles['isclickwarp'][0]
      ini.main.is_gm = toggles['isgm'][0]
      save()
      imgui.Text(u8'ClickWarp: ')
      imgui.SameLine()
      addons.ToggleButton("##clickwarp", toggles['isclickwarp'])
      imgui.Text(u8'GM: ')
      imgui.SameLine()
      addons.ToggleButton("##godmode", toggles['isgm'])
      imgui.Text(u8"Вх на кары: ")
      imgui.SameLine()
      addons.ToggleButton("##whcars", toggles['whcar'])
      if toggles['whcar'][0] then
        imgui.SameLine()
        imgui.TextDisabled(fa.ICON_FA_COG)
        if imgui.IsItemClicked() then
          imgui.OpenPopup(u8'Настройки ВХ')
        end
        if imgui.BeginPopupModal(u8'Настройки ВХ') then
          imgui.SetNextWindowSize(imgui.ImVec2(200,200))
          imgui.Text(u8"Дистанция прорисовки ВХ:")
          imgui.PushItemWidth(200)
          if imgui.SliderInt("##wallhackdistance", sliders['whdistance'], 10, 150, u8"%d") then
            ini.main.whdist = sliders['whdistance'][0]
            save()
          end
          imgui.PopItemWidth()
          imgui.NewLine()
          if imgui.Button(u8' Закрыть', imgui.ImVec2(200, 20)) then
              imgui.CloseCurrentPopup()
          end
          imgui.EndPopup()
        end
      end
      imgui.Text(u8"Трейсера пуль: ")
      imgui.SameLine()
      addons.ToggleButton("##traicersofbullets", toggles['traicers'])
    elseif section == navigation['buttons'][3][1] then -- Цвета
      imgui.SubTitle(u8"Интерфейс:")
      if imgui.ColorEdit4('##MainColor', editColors['mc'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
        mc = imgui.ImVec4(editColors['mc'][0], editColors['mc'][1], editColors['mc'][2], editColors['mc'][3])
        local u32 = imgui.ColorConvertFloat4ToU32(mc)
        ini.style.color = u32
        theme()
      end
      imgui.SameLine()
      imgui.Text(u8'Цвет интерфейса')

      if imgui.ColorEdit4('##TextColor', editColors['tc'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
        tc = imgui.ImVec4(editColors['tc'][0], editColors['tc'][1], editColors['tc'][2], editColors['tc'][3])
        local u32 = imgui.ColorConvertFloat4ToU32(tc)
        ini.style.text = u32
        theme()
      end
      imgui.SameLine()
      imgui.Text(u8'Цвет текста')

      imgui.Text(u8"Закругление окна: ")
      imgui.SameLine()
      imgui.PushItemWidth(100)
      if imgui.InputInt("##rounding", inputs['rounding'], 1) then
        if inputs['rounding'][0] < 1 then inputs['rounding'][0] = 1 end
        if inputs['rounding'][0] > 30 then inputs['rounding'][0] = 30 end
        ini.style.rounding = inputs['rounding'][0]
        theme()
      end
      imgui.PopItemWidth()
      imgui.NewLine()
      imgui.SubTitle(u8"Логи:")
      if imgui.ColorEdit4('##colordisconnect', editColors['cd'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
        cd = imgui.ImVec4(editColors['cd'][0], editColors['cd'][1], editColors['cd'][2], editColors['cd'][3])
        local u32 = imgui.ColorConvertFloat4ToU32(cd)
        ini.style.logcon_d = u32
      end
      imgui.SameLine()
      imgui.Text(u8'Дисконнект - [Q]')
      imgui.Question("disconnect", u8"Меняет цвет надписи [Q] в логах дисконнекта")
      if imgui.ColorEdit4('##colorreg', editColors['rc'], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
        rc = imgui.ImVec4(editColors['rc'][0], editColors['rc'][1], editColors['rc'][2], editColors['rc'][3])
        local u32 = imgui.ColorConvertFloat4ToU32(rc)
        ini.style.logreg = u32
      end
      imgui.SameLine()
      imgui.Text(u8'Регистрация')
      save()
    elseif section == navigation['buttons'][4][1] then -- Назначение клавиш
        ActiveClockMenu.v = mysplit(ini.binds.reoff, ",")
        lastrep.v = mysplit(ini.binds.last_rep, ",")
        bindot.v = mysplit(ini.binds.bind_ot, ",")
        imgui.Text(u8'Выйти из рекона: ')
        imgui.SameLine()
        if imgui.HotKey("##21312", ActiveClockMenu, 70, 25) then
            ini.binds.reoff = table.concat((ActiveClockMenu.v), ",")
            save()
            sampAddChatMessage(tag.."Успешно!", -1)
        end
        imgui.Text(u8"Ответь автору последнего репорта: ")
        imgui.SameLine()
        if imgui.HotKey("##lastrep", lastrep, 70, 25) then
          ini.binds.last_rep = table.concat((lastrep.v), ",")
          save()
          sampAddChatMessage(tag.."Успешно!", -1)
        end
        imgui.Text(u8"Открыть репорт(/ot): ")
        imgui.SameLine()
        if imgui.HotKey("##bindot", bindot, 70, 25) then
          ini.binds.bind_ot = table.concat((bindot.v), ",")
          save()
          sampAddChatMessage(tag.."Успешно!", -1)
        end
    elseif section == navigation['buttons'][5][1] then -- Формы
      ini.forms.slap = formsIni['slap'][0]
      ini.forms.flip = formsIni['flip'][0]
      ini.forms.freeze = formsIni['freeze'][0]
      ini.forms.unfreeze = formsIni['unfreeze'][0]
      ini.forms.pm = formsIni['pm'][0]
      ini.forms.spplayer = formsIni['spplayer'][0]
      ini.forms.spcar = formsIni['spcar'][0]
      ini.forms.cure = formsIni['cure'][0]
      ini.forms.weap = formsIni['weap'][0]
      ini.forms.unjail = formsIni['unjail'][0]
      ini.forms.jail = formsIni['jail'][0]
      ini.forms.unmute = formsIni['unmute'][0]
      ini.forms.kick = formsIni['kick'][0]
      ini.forms.mute = formsIni['mute'][0]
      ini.forms.adeldesc = formsIni['adeldesc'][0]
      ini.forms.apunish = formsIni['apunish'][0]
      ini.forms.plveh = formsIni['plveh'][0]
      ini.forms.bail = formsIni['bail'][0]
      ini.forms.unwarn = formsIni['unwarn'][0]
      ini.forms.ban = formsIni['ban'][0]
      ini.forms.warn = formsIni['warn'][0]
      ini.forms.accepttrade = formsIni['accepttrade'][0]
      ini.forms.givegun = formsIni['givegun'][0]
      ini.forms.trspawn = formsIni['trspawn'][0]
      ini.forms.destroytrees = formsIni['destroytrees'][0]
      ini.forms.removetune = formsIni['removetune'][0]
      ini.forms.clearafklabel = formsIni['clearafklabel'][0]
      ini.forms.setfamgz = formsIni['setfamgz'][0]
      ini.forms.delhname = formsIni['delhname'][0]
      ini.forms.delbname = formsIni['delbname'][0]
      ini.forms.warnoff = formsIni['warnoff'][0]
      ini.forms.unban = formsIni['unban'][0]
      ini.forms.afkkick = formsIni['afkkick'][0]
      ini.forms.aparkcar = formsIni['aparkcar'][0]
      ini.forms.setgangzone = formsIni['setgangzone'][0]
      ini.forms.setbizmafia = formsIni['setbizmafia'][0]
      ini.forms.cleardemorgane = formsIni['cleardemorgane'][0]
      ini.forms.sban = formsIni['sban'][0]
      ini.forms.banip = formsIni['banip'][0]
      ini.forms.unbanip = formsIni['unbanip'][0]
      ini.forms.jailoff = formsIni['jailoff'][0]
      ini.forms.muteoff = formsIni['muteoff'][0]
      ini.forms.skick = formsIni['skick'][0]
      ini.forms.setskin = formsIni['setskin'][0]
      ini.forms.uval = formsIni['uval'][0]
      ini.forms.ao = formsIni['ao'][0]
      ini.forms.unapunishoff = formsIni['unapunishoff'][0]
      ini.forms.unjailoff = formsIni['unjailoff'][0]
      ini.forms.unmuteoff = formsIni['unmuteoff'][0]
      ini.forms.unwarnoff = formsIni['unwarnoff'][0]
      ini.forms.bizlock = formsIni['bizlock'][0]
      ini.forms.bizopen = formsIni['bizopen'][0]
      ini.forms.cinemaunrent = formsIni['cinemaunrent'][0]
      ini.forms.banipoff = formsIni['banipoff'][0]
      ini.forms.banoff = formsIni['banoff'][0]
      ini.forms.agl = formsIni['agl'][0]

      ini.forms.autoslap = AutoformsIni['slap'][0]
      ini.forms.autoflip = AutoformsIni['flip'][0]
      ini.forms.autofreeze = AutoformsIni['freeze'][0]
      ini.forms.autounfreeze = AutoformsIni['unfreeze'][0]
      ini.forms.autopm = AutoformsIni['pm'][0]
      ini.forms.autospplayer = AutoformsIni['spplayer'][0]
      ini.forms.autospcar = AutoformsIni['spcar'][0]
      ini.forms.autocure = AutoformsIni['cure'][0]
      ini.forms.autoweap = AutoformsIni['weap'][0]
      ini.forms.autounjail = AutoformsIni['unjail'][0]
      ini.forms.autojail = AutoformsIni['jail'][0]
      ini.forms.autounmute = AutoformsIni['unmute'][0]
      ini.forms.autokick = AutoformsIni['kick'][0]
      ini.forms.automute = AutoformsIni['mute'][0]
      ini.forms.autoadeldesc = AutoformsIni['adeldesc'][0]
      ini.forms.autoapunish = AutoformsIni['apunish'][0]
      ini.forms.autoplveh = AutoformsIni['plveh'][0]
      ini.forms.autobail = AutoformsIni['bail'][0]
      ini.forms.autounwarn = AutoformsIni['unwarn'][0]
      ini.forms.autoban = AutoformsIni['ban'][0]
      ini.forms.autowarn = AutoformsIni['warn'][0]
      ini.forms.autoaccepttrade = AutoformsIni['accepttrade'][0]
      ini.forms.autogivegun = AutoformsIni['givegun'][0]
      ini.forms.autotrspawn = AutoformsIni['trspawn'][0]
      ini.forms.autodestroytrees = AutoformsIni['destroytrees'][0]
      ini.forms.autoremovetune = AutoformsIni['removetune'][0]
      ini.forms.autoclearafklabel = AutoformsIni['clearafklabel'][0]
      ini.forms.autosetfamgz = AutoformsIni['setfamgz'][0]
      ini.forms.autodelhname = AutoformsIni['delhname'][0]
      ini.forms.autodelbname = AutoformsIni['delbname'][0]
      ini.forms.autowarnoff = AutoformsIni['warnoff'][0]
      ini.forms.autounban = AutoformsIni['unban'][0]
      ini.forms.autoafkkick = AutoformsIni['afkkick'][0]
      ini.forms.autoaparkcar = AutoformsIni['aparkcar'][0]
      ini.forms.autosetgangzone = AutoformsIni['setgangzone'][0]
      ini.forms.autosetbizmafia = AutoformsIni['setbizmafia'][0]
      ini.forms.autocleardemorgane = AutoformsIni['cleardemorgane'][0]
      ini.forms.autosban = AutoformsIni['sban'][0]
      ini.forms.autobanip = AutoformsIni['banip'][0]
      ini.forms.autounbanip = AutoformsIni['unbanip'][0]
      ini.forms.autojailoff = AutoformsIni['jailoff'][0]
      ini.forms.automuteoff = AutoformsIni['muteoff'][0]
      ini.forms.autoskick = AutoformsIni['skick'][0]
      ini.forms.autosetskin = AutoformsIni['setskin'][0]
      ini.forms.autouval = AutoformsIni['uval'][0]
      ini.forms.autoao = AutoformsIni['ao'][0]
      ini.forms.autounapunishoff = AutoformsIni['unapunishoff'][0]
      ini.forms.autounjailoff = AutoformsIni['unjailoff'][0]
      ini.forms.autounmuteoff = AutoformsIni['unmuteoff'][0]
      ini.forms.autounwarnoff = AutoformsIni['unwarnoff'][0]
      ini.forms.autobizlock = AutoformsIni['bizlock'][0]
      ini.forms.autobizopen = AutoformsIni['bizopen'][0]
      ini.forms.autocinemaunrent = AutoformsIni['cinemaunrent'][0]
      ini.forms.autobanipoff = AutoformsIni['banipoff'][0]
      ini.forms.autobanoff = AutoformsIni['banoff'][0]
      ini.forms.autoagl = AutoformsIni['agl'][0]

      save()
      acceptform.v = mysplit(ini.binds.acceptform, ",")
      imgui.Text(u8'Бинд принятия: ')
      imgui.SameLine()
      if imgui.HotKey("##acceptform", acceptform, 70, 25) then
          ini.binds.acceptform = table.concat((acceptform.v), ",")
          save()
          sampAddChatMessage(tag.."Успешно!", -1)
      end
      imgui.SameLine()
      imgui.Question("##bindacceptform", u8"При нажатии на данную клавишу, вы сможете принять форму из админ чата")
      imgui.Text(u8"Время ожидания принятия формы: ")
      imgui.SameLine()
      imgui.PushItemWidth(20)
      if imgui.InputInt("##cdacceptform", inputs['cdacceptform'], 0) then
        if inputs['cdacceptform'][0] < 5 then inputs['cdacceptform'][0] = 5 end
        if inputs['cdacceptform'][0] > 30 then inputs['cdacceptform'][0] = 30 end
        ini.main.cdacceptform = inputs['cdacceptform'][0]
      end
      imgui.PopItemWidth()
      if imgui.Button(u8"Автоматическая настройка под уровень", imgui.ImVec2(300,20)) then setPermission() end
      imgui.NewLine()
      imgui.Separator()
      imgui.Columns(3, "commandsform", true)
      imgui.PushFont(imFont[18])
      imgui.TextColored(mc, u8"Команда")
      imgui.NextColumn()
      imgui.TextColored(mc, u8"Принимать вручную")
      imgui.NextColumn()
      imgui.TextColored(mc, u8"Автопринятие")
      imgui.PopFont()
      imgui.NextColumn()
      imgui.Separator()
      for i, v in pairs(forms) do
        imgui.Button(u8("/" .. v), imgui.ImVec2(270, 20))
        imgui.NextColumn()
        imgui.Checkbox(u8"##6546g" .. i, formsIni[v])
        imgui.NextColumn()
        imgui.Checkbox(u8"##656g" .. i, AutoformsIni[v])
        imgui.NextColumn()
        imgui.Separator()
      end
      save()
      imgui.Columns(1)
    elseif section == navigation['buttons'][6][1] then -- Рекон
      imgui.Text(u8'Местоположение окна статистики рекона: ')
      imgui.SameLine()
        if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##statsreconPosition', imgui.ImVec2(33, 20)) then
          lua_thread.create(function()
            local backup = {
              ['x'] = ini.recon.x,
              ['y'] = ini.recon.y
            }
            ChangePosReconStats = true
            showCursor(true)
            amenu[0] = false
            sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
            if not sampIsChatInputActive() then
              while not sampIsChatInputActive() and ChangePosReconStats do
                showCursor(true)
                  wait(0)
                  showCursor(true)
                  ini.recon.x, ini.recon.y = getCursorPos()
                  local cX, cY = getCursorPos()
                  admins['posstatsrecon'].x = cX
                  admins['posstatsrecon'].y = cY
                  if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                    showCursor(false)
                    ChangePosReconStats = false
                    sampAddChatMessage(tag..'Позиция сохранена!', -1)
                  elseif isKeyJustPressed(VK_ESCAPE) then
                    ChangePosReconStats = false
                    showCursor(false)
                    admins['posstatsrecon'].x = backup['x']
                    admins['posstatsrecon'].y = backup['y']
                    sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                  end
              end
            end
            ini.recon.x = admins['posstatsrecon'].x
            ini.recon.y = admins['posstatsrecon'].y 
            showCursor(false)
            ChangePosReconStats = false
            amenu[0] = true
            end)
          end
      imgui.Text(u8'Местоположение окна рекона: ')
      imgui.SameLine()
        if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##statsrecon', imgui.ImVec2(33, 20)) then
          lua_thread.create(function()
            local backup = {
              ['x'] = ini.recon.funcx,
              ['y'] = ini.recon.funcy
            }
            ChangePosRecon = true
            showCursor(true)
            amenu[0] = false
            sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
            if not sampIsChatInputActive() then
              while not sampIsChatInputActive() and ChangePosRecon do
                showCursor(true)
                  wait(0)
                  showCursor(true)
                  ini.recon.funcx, ini.recon.funcy = getCursorPos()
                  local cX, cY = getCursorPos()
                  admins['posrecon'].x = cX
                  admins['posrecon'].y = cY
                  if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                    showCursor(false)
                    ChangePosRecon = false
                    sampAddChatMessage(tag..'Позиция сохранена!', -1)
                  elseif isKeyJustPressed(VK_ESCAPE) then
                    ChangePosRecon = false
                    showCursor(false)
                    admins['posrecon'].x = backup['x']
                    admins['posrecon'].y = backup['y']
                    sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                  end
              end
            end
            ini.recon.funcx = admins['posrecon'].x
            ini.recon.funcy = admins['posrecon'].y 
            showCursor(false)
            ChangePosRecon = false
            amenu[0] = true
            end)
          end
      save()
    elseif section == navigation['buttons'][7][1] then -- Репорт
      imgui.Text(u8"Report")
    elseif section == navigation['buttons'][8][1] then -- Контроль AFK
    elseif section == navigation['buttons'][9][1] then -- Чекер
      imgui.CustomBarCheckers()
      imgui.SetCursorPosY(80)
      if checkers['selected'] == 1 --[[ Чекер администрации ]] then
        ini.main.ischecker = toggles['checkeradm'][0]
        save()
        imgui.BeginGroup()
          imgui.SubTitle(u8"Основные настройки:")
          imgui.Text(u8"Включить чекер администрации: ")
          imgui.SameLine()
          addons.ToggleButton("##toggleschecker", toggles['checkeradm'])
          imgui.Text(u8"Частота обновления: ")
          imgui.SameLine()
          imgui.PushItemWidth(30)
          if imgui.InputInt("##delay", inputs['delay_checker'], 0) then
            if inputs['delay_checker'][0] < 5 then inputs['delay_checker'][0] = 5 end
						if inputs['delay_checker'][0] > 60 then inputs['delay_checker'][0] = 60 end
						ini.main.delay_checker = inputs['delay_checker'][0]
          end
          imgui.PopItemWidth()
          imgui.Text(u8'Местоположение')
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##adminsPosition', imgui.ImVec2(33, 20)) then
            lua_thread.create(function()
              local backup = {
                ['x'] = ini.main.posX,
                ['y'] = ini.main.posY
              }
              ChangePos = true
              showCursor(true)
              amenu[0] = false
              sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
              if not sampIsChatInputActive() then
                  while not sampIsChatInputActive() and ChangePos do
                    showCursor(true)
                      wait(0)
                      showCursor(true)
                      ini.main.posX, ini.main.posY = getCursorPos()
                      local cX, cY = getCursorPos()
                      admins['pos'].x = cX
                      admins['pos'].y = cY
                      if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                          showCursor(false)
                          ChangePos = false
                          sampAddChatMessage(tag..'Позиция сохранена!', -1)
                      elseif isKeyJustPressed(VK_ESCAPE) then
                          ChangePos = false
                          showCursor(false)
                          admins['pos'].x = backup['x']
                          admins['pos'].y = backup['y']
                          sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                      end
                  end
              end
              ini.main.posX = admins['pos'].x
              ini.main.posY = admins['pos'].y 
              showCursor(false)
              ChangePos = false
              amenu[0] = true
            end)
          end;

          imgui.SubTitle(u8'Отображение уровней:')
          for i = 1, 8 do
            local aname = admNames[i] .. ' (' .. i .. ')'
            imgui.Text(u8(aname))
            imgui.SameLine()
            imgui.SetCursorPosX(180)
            if addons.ToggleButton(u8("##"..aname), admins['showLvl'][i]) then 
              ini.level[i] = admins['showLvl'][i][0]
            end
          end

          imgui.SubTitle(u8'Отображение информации:')
          imgui.Text(u8'ID Админа'); imgui.SameLine(80)
          imgui.TextColoredRGB(u8(admins['showInfo'].id[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
          if imgui.IsItemClicked() then
            admins['showInfo'].id[0] = not admins['showInfo'].id[0]
            ini.show.id = admins['showInfo'].id[0]
          end
          imgui.Text(u8'Уровень'); imgui.SameLine(80)
          imgui.TextColoredRGB(u8(admins['showInfo'].level[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
          if imgui.IsItemClicked() then
            admins['showInfo'].level[0] = not admins['showInfo'].level[0]
            ini.show.level = admins['showInfo'].level[0]
          end
          imgui.Text(u8'AFK'); imgui.SameLine(80)
          imgui.TextColoredRGB(u8(admins['showInfo'].afk[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
          if imgui.IsItemClicked() then
            admins['showInfo'].afk[0] = not admins['showInfo'].afk[0]
            ini.show.afk = admins['showInfo'].afk[0]
          end
          imgui.Text(u8'Слежка'); imgui.SameLine(80)
          imgui.TextColoredRGB(u8(admins['showInfo'].recon[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
          if imgui.IsItemClicked() then
            admins['showInfo'].recon[0] = not admins['showInfo'].recon[0]
            ini.show.recon = admins['showInfo'].recon[0]
          end
          imgui.Text(u8'Репутация'); imgui.SameLine(80)
          imgui.TextColoredRGB(u8(admins['showInfo'].reputate[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
          if imgui.IsItemClicked() then
            admins['showInfo'].reputate[0] = not admins['showInfo'].reputate[0]
            ini.show.reputate = admins['showInfo'].reputate[0]
          end
          imgui.Text(u8'Актив'); imgui.SameLine(80)
          imgui.TextColoredRGB(u8(admins['showInfo'].active[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
          if imgui.IsItemClicked() then
            admins['showInfo'].active[0] = not admins['showInfo'].active[0]
            ini.show.active = admins['showInfo'].active[0]
          end
          imgui.Question('active', u8('Актив показывает время (в секундах)\nпосле последнего ответа на репорт'))
          imgui.Text(u8'Это я'); imgui.SameLine(80)
          imgui.TextColoredRGB(u8(admins['showInfo'].selfMark[0] and '{33AA33}Отображать' or '{505050}Скрывать'))
          if imgui.IsItemClicked() then
            admins['showInfo'].selfMark[0] = not admins['showInfo'].selfMark[0]
            ini.show.selfMark = admins['showInfo'].selfMark[0]
          end
          imgui.Question('itsMe', u8( string.format('Ваш ник в чекере будет %sпереливаться', ARGBtoStringRGB(rainbow(2)) )))
        imgui.EndGroup()
		  	imgui.SameLine()
        imgui.SetCursorPosX(imgui.GetCursorPos().x + 100)
        imgui.BeginGroup()
          imgui.SubTitle(u8"Настройка цветов:")
          for lvl, col in ipairs(admins['colors'].lvl) do
            if imgui.ColorEdit4('##CheckerAdminColor'..lvl, col, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              local c = imgui.ImVec4(col[0], col[1], col[2], col[3]) 
              ini.color[lvl] = imgui.ColorConvertFloat4ToU32(c)
            end; imgui.SameLine()
            local aname = admNames[lvl] .. ' (' .. lvl .. ')'
            imgui.Text(u8(aname))
          end
          imgui.NewLine()
          for name, info in pairs(admins['colors'].content) do
            if imgui.ColorEdit4('##CheckerContentColor'..name, info[2], imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
              local c = imgui.ImVec4(info[2][0], info[2][1], info[2][2], info[2][3]) 
              ini.color[name] = imgui.ColorConvertFloat4ToU32(c)
            end; imgui.SameLine()
            imgui.Text(u8(info[1]))
          end
          imgui.NewLine()
          imgui.SubTitle(u8"Лимиты:")

          imgui.PushItemWidth(40)
          if imgui.InputInt(u8'Лимит АФК##adminsAfkMax', inputs['maxAfk'], 0) then
            if inputs['maxAfk'][0] < 60 then inputs['maxAfk'][0] = 60 end
						if inputs['maxAfk'][0] > 3599 then inputs['maxAfk'][0] = 3599 end
						ini.main.limitmax_afk = inputs['maxAfk'][0]
          end
          imgui.PopItemWidth()
          imgui.Question('maxAfk', u8('При привышении '..ini.main.maxAfk..' секунд, счётчик\nбудет подсвечен {FF0000}красным'))

          imgui.PushItemWidth(40)
          if imgui.InputInt(u8'Лимит актива##adminsActiveMax', inputs['maxActive'], 0) then
            if inputs['maxActive'][0] < 60 then inputs['maxActive'][0] = 60 end
						if inputs['maxActive'][0] > 3599 then inputs['maxActive'][0] = 3599 end
						ini.main.maxActive = inputs['maxActive'][0]
          end
          imgui.PopItemWidth()
          imgui.Question('maxActive', u8('При привышении '..ini.main.maxActive..' секунд, счётчик\nбудет подсвечен {FF0000}красным'))
        imgui.EndGroup()
        imgui.SameLine()
        imgui.SetCursorPosX(imgui.GetCursorPos().x + 60)
        imgui.BeginGroup()
        imgui.SubTitle(u8"Настройка шрифтов:")
          imgui.PushItemWidth(130)
          if imgui.InputTextWithHint('##FontName', u8'Название шрифта', fonts['input'], ffi.sizeof(fonts['input'])) then
            ini.font.name = #ffi.string(fonts['input']) > 0 and u8:decode(ffi.string(fonts['input'])) or 'Arial'
            checker_font = renderCreateFont(ini.font.name, ini.font.size, ini.font.flag)
          end
          imgui.Hint('font_hint_name', u8'Название шрифта')
          if not imgui.IsItemActive() and #ffi.string(fonts['input']) == 0 then
            imgui.StrCopy(fonts['input'], u8'Arial')
          end
          if imgui.SliderInt('##FontSize', fonts['size'], 1, 25, u8'%d') then
            if fonts['size'][0] < 1 then fonts['size'][0] = 1 end
            if fonts['size'][0] > 25 then fonts['size'][0] = 25 end
            ini.font.size = fonts['size'][0]
            checker_font = renderCreateFont(ini.font.name, ini.font.size, ini.font.flag)
          end
          imgui.Hint('font_hint_size', u8'Размер шрифта')
          if imgui.SliderInt('##FontFlag', fonts['flag'], 1, 25, u8'%d') then
            if fonts['flag'][0] < 1 then fonts['flag'][0] = 1 end
            if fonts['flag'][0] > 25 then fonts['flag'][0] = 25 end
            ini.font.flag = fonts['flag'][0]
            checker_font = renderCreateFont(ini.font.name, ini.font.size, ini.font.flag)
          end
          imgui.Hint('font_hint_flag', u8'Флаг шрифта')
          if imgui.SliderInt('##FontOffset', fonts['offset'], 1, 30, u8'%d') then
            if fonts['offset'][0] < 1 then fonts['offset'][0] = 1 end
            if fonts['offset'][0] > 30 then fonts['offset'][0] = 30 end
            ini.font.offset = fonts['offset'][0]
          end
          imgui.Hint('font_hint_offset', u8'Расстояние между строками')
          imgui.PopItemWidth()
          imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 2.0)
          if imgui.BoolButton(ini.font.align == 1, fa.ICON_FA_ALIGN_LEFT, imgui.ImVec2(38, 20)) then
            ini.font.align = 1
          end
          imgui.SameLine()
          if imgui.BoolButton(ini.font.align == 2, fa.ICON_FA_ALIGN_CENTER, imgui.ImVec2(38, 20)) then
            ini.font.align = 2
          end
          imgui.SameLine()
          if imgui.BoolButton(ini.font.align == 3, fa.ICON_FA_ALIGN_RIGHT, imgui.ImVec2(38, 20)) then
            ini.font.align = 3
          end
          imgui.PopStyleVar()
        imgui.EndGroup()
        imgui.NewLine()
        imgui.BeginGroup()
          imgui.BeginCustomChild(u8"Кураторы", imgui.ImVec2(280, 317), ini.color[5]) --317
            imgui.SetCursorPos( imgui.ImVec2(8, 26) )
            imgui.PushItemWidth(180)
            imgui.InputTextWithHint('##add5checker', u8'Введите ник куратора', inputs['bufAdd5'], sizeof(inputs['bufAdd5']))
            imgui.PopItemWidth()
            imgui.SameLine()
            local cc = imgui.ColorConvertU32ToFloat4(ini.color[5])
            imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cc.x, cc.y, cc.z, 0.70))
            imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cc.x, cc.y, cc.z, 0.80))
            imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cc.x, cc.y, cc.z, 0.90))
            if imgui.Button(u8'Добавить', imgui.ImVec2(84, 20)) then
              if #str(inputs['bufAdd5']) > 0 then
                table.insert(ini.kurators, u8:decode(str(inputs['bufAdd5'])))
                imgui.StrCopy(inputs['bufAdd5'], '')
              end
            end
            imgui.PopStyleColor(3)
            if #ini.kurators > 0 then
              for i, kurator in ipairs(ini.kurators) do 
                imgui.SetCursorPosX(8)
                imgui.TextColoredRGB(u8(('{606060}%s. {STANDART}%s'):format(i, kurator)))
                imgui.SameLine(imgui.GetWindowWidth() - 30)
                imgui.Text(fa.ICON_FA_TRASH)
                if imgui.IsItemClicked() then
                  table.remove(ini.kurators, i)	
                end
              end
            else
              imgui.SetCursorPosY(110)
              imgui.CenterTextColored(cc, u8'Список кураторов пуст')
            end
          imgui.EndChild()
        imgui.EndGroup()
        imgui.SameLine(290)
        imgui.BeginGroup()
          imgui.BeginCustomChild(u8"ЗГА", imgui.ImVec2(250, 147), ini.color[6])
            imgui.SetCursorPos( imgui.ImVec2(8, 26) )
            imgui.PushItemWidth(150)
            imgui.InputTextWithHint('##add6checker', u8'Введите ник ЗГА', inputs['bufAdd6'], sizeof(inputs['bufAdd6']))
            imgui.PopItemWidth()
            imgui.SameLine()
            local cc = imgui.ColorConvertU32ToFloat4(ini.color[6])
            imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cc.x, cc.y, cc.z, 0.70))
            imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cc.x, cc.y, cc.z, 0.80))
            imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cc.x, cc.y, cc.z, 0.90))
            if imgui.Button(u8'Добавить', imgui.ImVec2(84, 20)) then
              if #str(inputs['bufAdd6']) > 0 then
                table.insert(ini.zga, u8:decode(str(inputs['bufAdd6'])))
                imgui.StrCopy(inputs['bufAdd6'], '')
              end
            end
            imgui.PopStyleColor(3)
            if #ini.zga > 0 then
              for i, zga in ipairs(ini.zga) do 
                imgui.SetCursorPosX(8)
                imgui.TextColoredRGB(u8(('{606060}%s. {STANDART}%s'):format(i, zga)))
                imgui.SameLine(imgui.GetWindowWidth() - 30)
                imgui.Text(fa.ICON_FA_TRASH)
                if imgui.IsItemClicked() then
                  table.remove(ini.zga, i)	
                end
              end
            else
              imgui.SetCursorPosY(110)
              imgui.CenterTextColored(cc, u8'Список ЗГА пуст')
            end
          imgui.EndChild()
          imgui.NewLine()
          imgui.BeginCustomChild(u8"ГА", imgui.ImVec2(250, 147), ini.color[7])
            imgui.SetCursorPos( imgui.ImVec2(8, 26) )
            imgui.PushItemWidth(150)
            imgui.InputTextWithHint('##add7checker', u8'Введите ник ГА', inputs['bufAdd7'], sizeof(inputs['bufAdd7']))
            imgui.PopItemWidth()
            imgui.SameLine()
            local cc = imgui.ColorConvertU32ToFloat4(ini.color[7])
            imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cc.x, cc.y, cc.z, 0.70))
            imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cc.x, cc.y, cc.z, 0.80))
            imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cc.x, cc.y, cc.z, 0.90))
            if imgui.Button(u8'Добавить', imgui.ImVec2(84, 20)) then
              if #str(inputs['bufAdd7']) > 0 then
                table.insert(ini.ga, u8:decode(str(inputs['bufAdd7'])))
                imgui.StrCopy(inputs['bufAdd7'], '')
              end
            end
            imgui.PopStyleColor(3)
            if #ini.ga > 0 then
              for i, ga in ipairs(ini.ga) do 
                imgui.SetCursorPosX(8)
                imgui.TextColoredRGB(u8(('{606060}%s. {STANDART}%s'):format(i, ga)))
                imgui.SameLine(imgui.GetWindowWidth() - 30)
                imgui.Text(fa.ICON_FA_TRASH)
                if imgui.IsItemClicked() then
                  table.remove(ini.ga, i)	
                end
              end
            else
              imgui.SetCursorPosY(110)
              imgui.CenterTextColored(cc, u8'Список ГА пуст')
            end
          imgui.EndChild()
        imgui.EndGroup()
        imgui.SameLine(550)
        imgui.BeginGroup()
        imgui.BeginCustomChild(u8"Спец.Администрация", imgui.ImVec2(280, 317), ini.color[8])
          imgui.SetCursorPos( imgui.ImVec2(8, 26) )
          imgui.PushItemWidth(180)
          imgui.InputTextWithHint('##add8checker', u8'Введите ник Спец.Администратора', inputs['bufAdd8'], sizeof(inputs['bufAdd8']))
          imgui.PopItemWidth()
          imgui.SameLine()
          local cc = imgui.ColorConvertU32ToFloat4(ini.color[8])
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cc.x, cc.y, cc.z, 0.70))
          imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(cc.x, cc.y, cc.z, 0.80))
          imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(cc.x, cc.y, cc.z, 0.90))
          if imgui.Button(u8'Добавить', imgui.ImVec2(84, 20)) then
            if #str(inputs['bufAdd8']) > 0 then
              table.insert(ini.special, u8:decode(str(inputs['bufAdd8'])))
              imgui.StrCopy(inputs['bufAdd8'], '')
            end
          end
          imgui.PopStyleColor(3)
          if #ini.special > 0 then
            for i, special in ipairs(ini.special) do 
              imgui.SetCursorPosX(8)
              imgui.TextColoredRGB(u8(('{606060}%s. {STANDART}%s'):format(i, special)))
              imgui.SameLine(imgui.GetWindowWidth() - 30)
              imgui.Text(fa.ICON_FA_TRASH)
              if imgui.IsItemClicked() then
                table.remove(ini.special, i)	
              end
            end
          else
            imgui.SetCursorPosY(110)
            imgui.CenterTextColored(cc, u8'Список кураторов пуст')
          end
        imgui.EndChild()
        imgui.EndGroup()
        imgui.NewLine()
      elseif checkers['selected'] == 2 --[[ Чекер лидеров/замов ]] then
        --func
      elseif checkers['selected'] == 3 --[[ Чекер игроков ]] then

      elseif checkers['selected'] == 4 --[[ Лог отключения ]] then
        imgui.Text(u8"Включить лог: ")
        imgui.SameLine()
        if addons.ToggleButton("##logconnecting", toggles['logcon']) then
          ini.main.logcon = toggles['logcon'][0]
          save()
        end
        if ini.main.logcon then
          imgui.Text(u8"Лимит строк: ")
          imgui.SameLine()
          imgui.PushItemWidth(100)
          if imgui.InputInt("##limit", inputs['logconlimit'], 1) then
            if inputs['logconlimit'][0] < 3 then inputs['logconlimit'][0] = 3 end
            if inputs['logconlimit'][0] > 20 then inputs['logconlimit'][0] = 20 end
            ini.main.logconlimit = inputs['logconlimit'][0]
            save()
            for i=1, #logcon do
              logcon[i] = nil
            end
          end
          imgui.PopItemWidth()
          imgui.Text(u8'Местоположение: ')
        imgui.SameLine()
          if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##logdisc', imgui.ImVec2(33, 20)) then
            lua_thread.create(function()
              local backup = {
                ['x'] = ini.main.logconposx,
                ['y'] = ini.main.logconposy
              }
              ChangePosLogDisc = true
              showCursor(true)
              amenu[0] = false
              sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
              if not sampIsChatInputActive() then
                while not sampIsChatInputActive() and ChangePosLogDisc do
                  showCursor(true)
                    wait(0)
                    showCursor(true)
                    ini.main.logconposx, ini.main.logconposy = getCursorPos()
                    local cX, cY = getCursorPos()
                    admins['poslogdisc'].x = cX
                    admins['poslogdisc'].y = cY
                    if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                      showCursor(false)
                      ChangePosLogDisc = false
                      sampAddChatMessage(tag..'Позиция сохранена!', -1)
                    elseif isKeyJustPressed(VK_ESCAPE) then
                      ChangePosLogDisc = false
                      showCursor(false)
                      admins['poslogdisc'].x = backup['x']
                      admins['poslogdisc'].y = backup['y']
                      sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                    end
                end
              end
              ini.main.logconposx = admins['poslogdisc'].x
              ini.main.logconposy = admins['poslogdisc'].y 
              showCursor(false)
              ChangePosLogDisc = false
              amenu[0] = true
              save()
              end)
            end
        end
        
      elseif checkers['selected'] == 5 --[[ Лог регистраций ]] then
        imgui.Text(u8"Включить лог регистраций: ")
        imgui.SameLine()
        if addons.ToggleButton("##logregister", toggles['logreg']) then ini.main.logreg = toggles['logreg'][0] end
        if ini.main.logreg then
          imgui.Text(u8"Лимит строк: ")
          imgui.SameLine()
          imgui.PushItemWidth(100)
          if imgui.InputInt("##limitslines", inputs['limitreg'], 1) then
            if inputs['limitreg'][0] < 3 then inputs['limitreg'][0] = 3 end
            if inputs['limitreg'][0] > 30 then inputs['limitreg'][0] = 30 end
            ini.main.limitreg = inputs['limitreg'][0]
            save()
          end
          imgui.PopItemWidth()
          imgui.Text(u8'Местоположение: ')
          imgui.SameLine()
          if imgui.Button(fa.ICON_FA_ARROWS_ALT..'##logreg', imgui.ImVec2(33, 20)) then
            lua_thread.create(function()
              local backup = {
                ['x'] = ini.main.logregposx,
                ['y'] = ini.main.logregposy
              }
              ChangePosLogReg = true
              showCursor(true)
              amenu[0] = false
              sampAddChatMessage(tag..'Нажмите ЛКМ что-бы сохранить местоположение, или ESC что-бы отменить', -1)
              if not sampIsChatInputActive() then
                while not sampIsChatInputActive() and ChangePosLogReg do
                  showCursor(true)
                    wait(0)
                    showCursor(true)
                    ini.main.logregposx, ini.main.logregposy = getCursorPos()
                    local cX, cY = getCursorPos()
                    admins['poslogreg'].x = cX
                    admins['poslogreg'].y = cY
                    if isKeyJustPressed(keyApply) or sampIsChatInputActive() then
                      showCursor(false)
                      ChangePosLogReg = false
                      sampAddChatMessage(tag..'Позиция сохранена!', -1)
                    elseif isKeyJustPressed(VK_ESCAPE) then
                      ChangePosLogReg = false
                      showCursor(false)
                      admins['poslogreg'].x = backup['x']
                      admins['poslogreg'].y = backup['y']
                      sampAddChatMessage(tag..'Вы отменили изменение местоположения', -1)
                    end
                end
              end
              ini.main.logregposx = admins['poslogreg'].x
              ini.main.logregposy = admins['poslogreg'].y 
              showCursor(false)
              ChangePosLogReg = false
              amenu[0] = true
              save()
              end)
            end
        end
      end
    end
  end

----------------------------------------------------------------------

--                 Хуки

  
  function sampev.onServerMessage(color, text)
    if text:find("^%[A%] .+%[%d+%]: %[Forma%] %+$") then
      formastop = true
  
      return false
    end
    if statusformerror and (text:find("^Используй: /.+") or text:find("^Используйте: /.+") or text:find("^%[Ошибка%] {FFFFFF}Используй: /.+") or text:find("^%[Ошибка%] У игрока нет варнов!") or text:find("^Этот игрок уже в ТСР!") or text:find("^%[Ошибка%] {ffffff}Игрок не был ранен.")) then
			sampSendChat("/a " .. formanick .. "[" .. formaid .. "] " .. text)

			statusformerror = false
      formastop = false
			return false
		end

		if statusformerror and (text:find("^Не больше %d+ символов!$") or text:find("^У этого игрока уже есть бан чата!$") or text:find("/unbanip [ip]") or text:find("/warnoff [name] [количество] [причина]") or text:find("^Игрок не в игре!$") or text:find("^%[Ошибка%] {FFFFFF}Игрок не в сети!$") or text:find("^Игрок не законектился еще!$") or text:find("^Этот игрок уже в ДЕМОРГАНЕ!$") or text:find("^Извините , но такого человека сейчас нет в тюрьме!$") or text:find("^%[Ошибка%] {ffffff}Использовать команду можно если онлайн авторизированных игроков более 950.") ) then
			sampSendChat("/a " .. formanick .. "[" .. formaid .. "] " .. text)

			statusformerror = false
      formastop = false

			return false
		end

    if text:match("^%[A%] (.*)%[(%d+)%]: /(.*)") and statsforma and not afktest then
			formanick, formaid, forma = text:match("%[A%] (.*)%[(%d+)%]: (/.*)")
      if not formanick:find("%s+") then
        if forma:find("/(%w+)%s*.*") then
          local cmdcheck = forma:match("/(%w+)%s*.*")
          cmdcheck = "auto"..cmdcheck
          if ini.forms[cmdcheck] then
            lua_thread.create(function()
              wait(0)
              sampSendChat("/a [Forma] +")
              sampSendChat(forma)
              statusformerror = false
              printStyledString("Admin form accepted", 1500, 5)
              sampAddChatMessage('{545454}[Admin-Form] Форма >> {E3C47F}'..forma..' {545454}<< выдана!', -1)
              local n1, n2, n3 = string.match(text, '%[A%] (%a+%_%a+)%[(%d+)%]: (.+)')
              for l=1, 8 do
                for i, v in ipairs(admins['list'][l]) do
                  if v[1] == n1 then
                    if ini.customcolor[n1] ~= nil then
                      text = ("[A] "..ABGRtoStringRGB(ini.customcolor[n1])..n1.."["..n2.."]{99CC00}: "..n3):format(n1, n2, n3)
                    else
                      text = ("[A] "..ABGRtoStringRGB(ini.color[l])..n1.."["..n2.."]{99CC00}: "..n3):format(n1, n2, n3)
                    end
                  end
                end
              end
            end)
            return {color, text}
          elseif ini.forms[forma:match("/(%w+)%s*.*")] then
            statsforma = false
            sampAddChatMessage("{545454}[Admin-Form] Найдено форма  >> {E3C47F}"..forma.." {545454}<< Отправитель: {E3C47F}"..formanick.."["..formaid.."]", -1)
            sampAddChatMessage('{545454}[Admin-Form] Нажмите клавишу >> {E3C47F}'..keyname(acceptform.v)..' {545454}<< чтобы принять форму.', -1)
            lua_thread.create(function()
              lasttime = os.time()
							lasttimes = 0
							prinalforma = false
              formastop = false
              while lasttimes < tonumber(ini.main.cdacceprform) do
								if formastop then
									sampAddChatMessage("{545454}[Admin Forma] Форма уже принята!", -1)
									break
								end
                lasttimes = os.time() - lasttime
                wait(0)
                printStyledString("ADMIN FORM " .. ini.main.cdacceprform - lasttimes .. " WAIT", 1, 5)
                if prinalforma then
									timeerr = os.time()
									statusformerror = true
									statsforma = true

									if forma:find("/(%w+)%s+(%d+)%s*(.*)") then
										cmd, form_id, form_other = forma:match("/(%w+)%s+(%d+)%s*(.*)")

										if tonumber(form_id) < 0 or tonumber(form_id) > 999 then
											statsforma = true

											return
										end

										if not sampIsPlayerConnected(tonumber(form_id)) and tonumber(form_id) ~= tonumber(id) and not checkIntable(admins['list'], form_id) and not forma:find("off") and not forma:find("unban") then
											sampSendChat("/a [Admin Forma]: Игрок под ID: " .. form_id .. " Оффлайн!")

											statsforma = true
                      formastop = false

											return
										end

                    for l=1, 8 do
                      for i, v in ipairs(admins['list'][l]) do
                        --sampAddChatMessage(v[1], -1)
                        if v[1] == sampGetPlayerNickname(tonumber(form_id)) then
                          sampSendChat("/a [Admin Forma]: " .. formanick .. "[" .. formaid .. "] вы пытаетесь наказать администратора >> " .. sampGetPlayerNickname(form_id) .. "[" .. form_id .. "]" .. " <<")
    
                          statsforma = true
                          formastop = false
    
                          return
                        end
                      end
                    end
									elseif forma:match("/(%w+)%s+(%S+)%s*(.*)") then
										local cmd, form_nick, form_other = forma:match("/(%w+)%s+(%S+)%s*(.*)")
                    if not isPlayerOnline(tostring(form_nick)) and tostring(form_nick) ~= tostring(getMyNick()) and not forma:find("off") and not forma:find("unban")  then
                      sampSendChat("/a [Admin Forma]: Игрок " .. form_nick .. " оффлайн!")

                      statsforma = true
                      formastop = false

                      return
										elseif isPlayerOnline(tostring(form_nick)) and tostring(form_nick) ~= tostring(getMyNick()) and formastop then
											sampSendChat(forma)

											statsforma = true
                      formastop = false

											return
										end

										for l=1, 8 do
                      for i, v in ipairs(admins['list'][l]) do
                        --sampAddChatMessage(v[1], -1)
                        if v[1] == tonumber(form_id) then
                          sampSendChat("/a [Admin Forma]: " .. formanick .. "[" .. formaid .. "] вы пытаетесь наказать администратора >> " .. sampGetPlayerNickname(form_id) .. "[" .. form_id .. "]" .. " <<")
    
                          statsforma = true
                          formastop = false
    
                          return
                        end
                      end
                    end
									end

									forma_copy = forma
									cmd, form_other = forma_copy:match("/(%w+)%s+(.*)")
                  sampSendChat("/a [Forma] +")
                  sampSendChat(forma)
                  formastop = false
                  printStyledString("Admin form accepted", 1500, 5)
                  sampAddChatMessage('{545454}[Admin-Form] Форма >> {E3C47F}'..forma..' {545454}<< выдана!', -1)
                  if os.time() - timeerr < 2 then
                    while os.time() - timeerr < 2 and statusformerror do
                      wait(0)

                      statusformerror = true
                    end
                  end

                  statusformerror = false

                  return
								end
              end
              statsforma = true

                printStyledString("You missed the form", 1500, 5)

                if not formastop then
                  sampAddChatMessage('{545454}[Admin-Form] Форма >> {E3C47F}'..forma..' {545454}<< не принята! Истекло время ожидания.', -1)
                  formastop = false
                end
            end)
          end
        end
      end
    end 
    if text:find("^Приветствуем нового игрока нашего сервера: %{......%}.+ %{......%}%(ID: %d+%)  %{......%}IP: .+") then
      local reg_nick, reg_id, reg_ip = text:match("Приветствуем нового игрока нашего сервера: %{......%}(.+) %{......%}%(ID: (%d+)%)  %{......%}IP: (.+)")
      text = ABGRtoStringRGB(ini.style.logreg).. "[R] "..reg_nick.."["..reg_id.."] - IP: "..reg_ip

      while #logreg == ini.main.limitreg do table.remove(logreg, 1) end
      logreg[#logreg+1] = text
      return false
    end
    if text:find("^.+%[ID: %d+%] %- %{......%}.+") then
      if not rInfo['statusiskamen2'] then
        local player, status = text:match("^(.+)%[ID: %d+%] %- %{......%}(.+)")
        if rInfo['name'] == player then
          if status:find("не использовал камень пространства") then
            rInfo['iskamen'] = false
          else
            rInfo['iskamen'] = true
          end
        end
        return false
      else
        rInfo['statusiskamen2'] = false
      end
    end
    if text:find("^.+%[ID: %d+%] %- %{......%}.+") then
      if not rInfo['statusistp2'] then
        local player, status = text:match("^(.+)%[ID: %d+%] %- %{......%}(.+)")
        if rInfo['name'] == player then
          if status:find("не использует камень неузвимости") then
            rInfo['lasttp'] = false
          else
            rInfo['lasttp'] = true
          end
        end
      else
        rInfo['statusistp2'] = false
      end
    end
    if text:find("^Игрок .+%[%d+%] подключен с %{......%}.+") then
      if not rInfo['statusclcheck2'] then
        local player, id, client = string.match(text, "^Игрок (.+)%[(%d+)%] подключен с %{......%}(.+)")
        if rInfo['name'] == player then
          if client:find("PC Launcher") then
            rInfo['client'] = "Launcher"
          elseif client:find("Mobile Launcher") then
            rInfo['client'] = "Mobile"
          elseif client:find("нет voice") then
            rInfo['client'] = "Client"
          end
        end
        return false
      else
        rInfo['statusclcheck2'] = false
      end
    end
    local all, inAfk = text:match('^{33CC00}Администрация онлайн: %(в сети: (%d+), из них в АФК: (%d+)%)')
    if all and inAfk then
      admins['online'] = tonumber(all)
      admins['afk'] = tonumber(inAfk)
      admins['count'] = 0
      admins['list'] = { {}, {}, {}, {}, {}, {}, {}, {} }
      lua_thread.create(function()
        for _, name in ipairs(ini.kurators) do
          local result, id = getPlayerIdByNickname(name)
          if result then 
            table.insert(admins['list'][5], {name, id, nil, nil, nil})
            admins['online'] = admins['online'] + 1
            admins['count'] = admins['count'] + 1
            admins['active'][name] = false
          end
        end
        for _, name in ipairs(ini.zga) do
          local result, id = getPlayerIdByNickname(name)
          if result then 
            table.insert(admins['list'][6], {name, id, nil, nil, nil})
            admins['online'] = admins['online'] + 1
            admins['count'] = admins['count'] + 1
            admins['active'][name] = false
          end
        end
        for _, name in ipairs(ini.ga) do
          local result, id = getPlayerIdByNickname(name)
          if result then 
            table.insert(admins['list'][7], {name, id, nil, nil, nil})
            admins['online'] = admins['online'] + 1
            admins['count'] = admins['count'] + 1
            admins['active'][name] = false
          end
        end
        for _, name in ipairs(ini.special) do
          local result, id = getPlayerIdByNickname(name)
          if result then 
            table.insert(admins['list'][8], {name, id, nil, nil, nil})
            admins['online'] = admins['online'] + 1
            admins['count'] = admins['count'] + 1
            admins['active'][name] = false
          end
        end
      end)
      return false
    end

    local name, id, lvl, reconInfo, afk, rep = text:match("{fefe22}(.*)%[(%d+)%] %- %[(%d+) lvl%](.*)%[AFK: (%d+)%].*Репутация: (.*)")
    if name and id and lvl and afk and rep then
      if tonumber(id) == selfId then
        if tonumber(lvl) >= 1 and tonumber(lvl) <= 8 then
          ini.main.lvl_adm = tonumber(lvl)
        end
      end
      local recon = reconInfo:match('/re (%d+)')
      table.insert(admins['list'][tonumber(lvl)], {name, tonumber(id), tonumber(afk), (recon and tonumber(recon) or -1), tonumber(rep)})
      admins['count'] = admins['count'] + 1
      if not admins['active'][name] then admins['active'][name] = os.time() end
      if admins['count'] == admins['online'] then requestAdmins = false end
      return false
    end
    if ini.main.ischecker and ini.show.active then
      local admin = text:match('Администратор ([0-9A-z_]+)%[%d+%] ответил игроку')
      if admin and admins['active'][admin] then
        admins['active'][admin] = os.time() 
      end
    end
    if string.find(text, '%[A%] %a+%_%a+%[%d+%]: .+') then
        local n1, n2, n3 = string.match(text, '%[A%] (%a+%_%a+)%[(%d+)%]: (.+)')
        for l=1, 8 do
          for i, v in ipairs(admins['list'][l]) do
            if v[1] == n1 then
              if ini.customcolor[n1] ~= nil then
                text = ("[A] "..ABGRtoStringRGB(ini.customcolor[n1])..n1.."["..n2.."]{99CC00}: "..n3):format(n1, n2, n3)
              else
                text = ("[A] "..ABGRtoStringRGB(ini.color[l])..n1.."["..n2.."]{99CC00}: "..n3):format(n1, n2, n3)
              end
            end
          end
        end
        return {color, text}
    end
    if text:find('{DFCFCF}%[Подсказка%] {DC4747}На сервере есть инвентарь, используйте клавишу Y для работы с ним.') then
        if #tostring(ini.main.pass_adm) > 4 then
            lua_thread.create(function()
                wait(500)
                sampSendChat("/apanel")
            end)
        end
    end
    if text:find('%[A%] Вы успешно авторизовались как') then
        if ini.main.auto_az then
            sampSendChat("/az")
        end
        sampSendChat("/admins")
    end
    if text:find('%[Ошибка%] {FFFFFF}Сейчас нет вопросов в репорт!') and ini.main.flood_ot then
      return false
    end
    if text:find('^Nick %[.+%]  R%-IP %[.+%]  IP | A%-IP %[%{......%}.+ | .+%{......%}%]') then
      if rdata[1] ~= nil then
        for k in pairs (rdata) do
          rdata [k] = nil
        end
      end
      getip_window[0] = false
      ipnick, getipip1, getipip2, getipip3 = string.match(text, '^Nick %[(.+)%]  R%-IP %[(.+)%]  IP | A%-IP %[%{......%}(.+) | (.+)%{......%}%]')
      ip(getipip1.." "..getipip3)
      return false
    end
  end
  
  function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if title:find("Основная статистика") then
      print(text)
      if not rInfo['statusinfocheck2'] then
        if not sampGetDialogCaption():find("Выберите действие") and rInfo['id'] ~= "-1" then
          lua_thread.create(function ()
            local frac, rank = text:match("Организация:.*}%[(.*)%].*Должность:.*(%d+)%).*Уро")
            local protect = text:match("Защита: %{......%}%[%-(%d+)%% урона%]")
            local regen = text:match("Регенерация: %{......%}%[(%d+) HP в мин")
            local force = text:match("Урон: %{......%}%[%+(%d+) урона")
            if frac and rank then
              rInfo['rank'] = rank
              rInfo['org'] = frac
            else
              rInfo['org'] = "Без фракции"
              rInfo['rank'] = "Без Фракции"
            end
            rInfo['protect'] = protect
            rInfo['force'] = force
            rInfo['regen'] = regen
          end)
  
          return false
        end
      else
        rInfo['statusinfocheck2'] = false
      end
    end
    if dialogId == 2 and title:match('Авторизация') and #tostring(ini.main.pass_acc) > 4 then
      local try = text:match('Попыток для ввода пароля: {%x+}(%d)')
      if try then
        if tonumber(try) >= 3 then
          if #ini.main.pass_acc > 4 then
            sampSendDialogResponse(dialogId, 1, _, base64.decode(ini.main.pass_acc))
            return false
          else
            text = text:gsub('Введите свой пароль', '{33AA33}Пароль введён автоматически')
            lua_thread.create(function()
              wait(0)
              sampSetCurrentDialogEditboxText(base64.decode(ini.main.pass_acc))
            end)
          end
        elseif tonumber(try) == 2 and #ini.main.pass_acc > 4 then
          text = text:gsub('Неверный пароль!', 'Авто-ввод пароля не удался!\n%1')
        end
        return {dialogId, style, title, but_1, but_2, text}
      end
    end
    if dialogId == 211 and title:match('Админ%-панель') and #tostring(ini.main.pass_adm) > 4 then
      sampSendDialogResponse(dialogId, 1, _, ini.main.pass_adm)
      return false
    end
    if text:find("Жалоба/Вопрос от:") then
        lua_thread.create(function()
          wait(0)
          enableDialog(false)
          repNick, repId, repText = string.match(text, "Жалоба/Вопрос от: (.+)%[(%d+)%]\n\n{BFE54C}(.+)\n")
          wait(10)
          report_window[0] = true
        end)
    end
    if report_window[0] then
      lost_report = true
      sampAddChatMessage(tag.q.."Окно репорта было сбито, ответ будет отправлен через \"/pm\"", -1)
    end
  end

  function sampev.onSpectatePlayer(playerid, camtype)
    rInfo['cars'] = false
    rInfo['id'] = playerid
    rInfo['iscar'] = false
    rInfo['status'] = true
    rInfo['name'] = sampGetPlayerNickname(rInfo['id'])
    for l=1, 8 do
      for i, v in ipairs(admins['list'][l]) do
        if v[2] == tonumber(rInfo['id']) then
          if v[4] ~= "-1" then
            lua_thread.create(function ()
              wait(0)
              sampSendChat("/re "..v[4])
              sampAddChatMessage(tag.."Автоматическая слежка за игроком из рекона администратора.", -1)
            end)
          end
        end
      end
    end
    if rInfo['id'] ~= "-1" then
      recon_window[0] = true
      reconinfo_window[0] = true
    end
    if rInfo['id'] ~= "-1" then
      lua_thread.create(function ()
        wait(2000)
  
        if not sampIsDialogActive() and not report_window[0] and rInfo['id'] ~= "-1" then
          rInfo['statusinfocheck'] = true
          rInfo['statusclcheck'] = true
          rInfo['statusiskamen'] = true
          rInfo['statusistp'] = true
          sampSendChat("/cl "..rInfo['id'])
          sampSendChat("/check " .. rInfo['id'])
        end
      end)
    end
  end

  function sampev.onTogglePlayerSpectating(state)
    if state then
      if rInfo['id'] ~= "-1" then
        recon_window[0] = true
        reconinfo_window[0] = true
      end
    elseif not state then -- вышел из рекона
      rInfo['id'] = "-1"
      rInfo['carid'] = "-1"
      rInfo['iscar'] = false
      rInfo['status'] = false
      recon_window[0] = false
      reconinfo_window[0] = false
      isfrac = false
    end
  end

  function sampev.onSpectateVehicle(vehicleId, camType)
    recon_window[0] = true
    rInfo['cars'] = vehicleId
    rInfo['carid'] = vehicleId
    rInfo['iscar'] = true
    rInfo['status'] = true
    if rInfo['-1'] ~= "-1" then
      lua_thread.create(function ()
        wait(2000)
  
        if not sampIsDialogActive() and not report_window[0] and rInfo['id'] ~= "-1" then
          rInfo['statusinfocheck'] = true
          rInfo['statusclcheck'] = true
          rInfo['statusiskamen'] = true
          rInfo['statusistp'] = true
          sampSendChat("/cl "..rInfo['id'])
          sampSendChat("/check " .. rInfo['id'])
        end
      end)
    end
  end

  function sampev.onSendSpectatorSync(syncdata)
    if rInfo['id'] ~= -1 and (syncdata.upDownKeys ~= 0 or syncdata.leftRightKeys ~= 0 or syncdata.keysData == 8) then
      return false
    end
  end

  function sampev.onShowTextDraw(id, data)
    if data.text:find("LD_BEAT:chit") and not statusinvent then
      statusinvent = true
  
      lua_thread.create(function ()
        while statusinvent do
          wait(0)
  
          if not sampTextdrawIsExists(2105) then
            break
          end
        end
  
        statusinvent = false
      end)
    end
    if data.text == "…H‹EHЏAP’" then
      idt = id
    end
    if data.text:find("Box") and tostring(data.position.x) == tostring(6.1998000144958) and tostring(data.position.y) == tostring(179.52949523926) and rInfo['id'] ~= "-1" then
      rInfo['lastid'] = id + 55
		  rInfo['oneid']= id
      sampAddChatMessage(tag.."Для вызова курсора/обновления информации рекона используйте клавишу SPACE/ПКМ", -1)
      
      return false
    end

    if rInfo['oneid'] and rInfo['lastid'] and rInfo['oneid'] <= id and id <= rInfo['lastid'] and rInfo['id'] ~= "-1" then
      if rInfo['oneid'] + 33 == id then
        rInfo['name'] = data.text
  
        if rInfo['status'] then
          rInfo['name'] = data.text
        end
      end
  
      if rInfo['oneid'] + 47 == id then
        rInfo['id'] = data.text
  
        if rInfo['status'] then
          rInfo['id'] = data.text
        end
      end
    end
    if rInfo['id'] ~= "-1" and rInfo['oneid'] and rInfo['lastid'] and rInfo['oneid'] <= id and id <= rInfo['lastid'] then
      return false
    end
  end

  function sampev.onSendCommand(cmd)
    local reId = string.match(cmd, "^%/re (%d+)")
    if reId then
      if tonumber(reId) < 0 or tonumber(reId) > 999 then
        return false
      end
      rInfo['id'] = tonumber(reId)
      rInfo['name'] = sampGetPlayerNickname(reId)
    end
    if string.match(cmd, "/ot") and report_window[0] then
      return false
    end
    if (cmd:find("^/check%s+") or cmd:find("^/stats")) and not rInfo['statusinfocheck'] then
      rInfo['statusinfocheck2'] = true
    elseif cmd:find("^/check%s+") and rInfo['statusinfocheck'] then
      rInfo['statusinfocheck'] = false
    end
    if (cmd:find("^/cl%s+") and not rInfo['statusclcheck']) then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusclcheck2'] = true
      end)
    elseif cmd:find("^/cl%s+") and rInfo['statusclcheck'] then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusclcheck'] = false
      end)
    end
    if (cmd:find("^/iskamen%s+") and not rInfo['statusiskamen']) then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusiskamen2'] = true
      end)
    elseif cmd:find("^/iskamen%s+") and rInfo['statusiskamen'] then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusiskamen'] = false
      end)
    end
    if (cmd:find("^/lasttp%s+") and not rInfo['statusistp']) then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusistp2'] = true
      end)
    elseif cmd:find("^/lasttp%s+") and rInfo['statusistp'] then
      lua_thread.create(function()
        wait(2000)
        rInfo['statusistp'] = false
      end)
    end
    if ini.main.autoprefix then
      if cmd:find("^/ban%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/banoff%s+") and (tonumber(ini.main.lvl_adm) < 5) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/banipoff%s+") and (tonumber(ini.main.lvl_adm) < 5) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/warnoff%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unjailoff%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unmuteoff%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/banip%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/sban%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/jailoff%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/warn%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/kick%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/jail%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/mute%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/spcar%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/skick%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/plveh%s+") and tonumber(ini.main.lvl_adm) < 3 then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/weap%s+") and tonumber(ini.main.lvl_adm) < 2 then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unmute%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unjail%s+") and (tonumber(ini.main.lvl_adm) < 2) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unwarn%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/apunish%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/unban%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/bail%s+") and tonumber(ini.main.lvl_adm) < 3 then
        cmd = {
          "/a " .. cmd.. " "..ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/givegun%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/trspawn%s+") and (tonumber(ini.main.lvl_adm) < 3) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/aparkcar%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/cleardemorgane%s+") and tonumber(ini.main.lvl_adm) < 4 then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/unbanip%s+") and tonumber(ini.main.lvl_adm) < 4 then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/ao%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd .. " " .. ini.forms.tag
        }
  
        return cmd
      end
  
      if cmd:find("^/setskin%s+") and tonumber(ini.main.lvl_adm) < 4 then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/trremove%s+") and (tonumber(ini.main.lvl_adm) < 5) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
  
      if cmd:find("^/setgangzone%s+") and (tonumber(ini.main.lvl_adm) < 4) then
        cmd = {
          "/a " .. cmd
        }
  
        return cmd
      end
    end
  end

  function sampev.onSendClientJoin(version,mod,nick)
      if isGamePaused() or isPauseMenuActive() then
      ShowMessage('Вы подключились к серверу!', '', 0x30)
      writeMemory(7634870, 1, 0, 0)
      writeMemory(7635034, 1, 0, 0)
      memory.hex2bin('5051FF1500838500', 7623723, 8)
      memory.hex2bin('0F847B010000', 5499528, 6)
      addOneOffSound(0.0, 0.0, 0.0, 1188)
    end
  end

  function sampev.onBulletSync(playerid, data)
    if ini.main.traicers then
      if data.target.x == -1 or data.target.y == -1 or data.target.z == -1 then
        return true
      end
      BulletSync.lastId = BulletSync.lastId + 1
      if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
        BulletSync.lastId = 1
      end
      local id = BulletSync.lastId
      BulletSync[id].enable = true
      BulletSync[id].tType = data.targetType
      BulletSync[id].time = os.time() + 15
      BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
      BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
    end
  end

  function sampev.onTextDrawSetString(id, text)
    if rInfo['oneid'] then
      if rInfo['oneid'] + 33 == id then
        rInfo['name'] = text
  
        if rInfo['status'] then
          rInfo['name'] = text
        end
      end
  
      if rInfo['oneid'] + 47 == id then
        rInfo['id'] = text
  
        if rInfo['status'] then
          rInfo['id'] = text
        end
      end
    end


    if rInfo['oneid'] then
      if rInfo['oneid'] + 33 == id then
        rInfo['name'] = text
      end
  
      if rInfo['oneid'] + 47 == id then
        rInfo['id'] = text
      end
  
      if rInfo['oneid'] + 35 == id then
        rInfo['lvl'], rInfo['exp'] = text:match("(%d+):(.*)")
      end
  
      if rInfo['oneid'] + 36 == id then
        rInfo['warn'] = text
      end
  
      if rInfo['oneid'] + 37 == id then
        rInfo['arm'] = text
      end
  
      if rInfo['oneid'] + 38 == id then
        rInfo['hp'] = text
      end
  
      if rInfo['oneid'] + 39 == id then
        rInfo['carhp'] = text
      end
  
      if rInfo['oneid'] + 40 == id then
        rInfo['speed'] = text
      end
  
      if rInfo['oneid'] + 41 == id then
        rInfo['ping'] = text
      end
  
      if rInfo['oneid'] + 42 == id then
        rInfo['ammo']= text
      end
  
      if rInfo['oneid'] + 43 == id then
        rInfo['shot'] = text
      end
  
      if rInfo['oneid'] + 44 == id then
        rInfo['tshot'] = text
      end
  
      if rInfo['oneid'] + 45 == id then
        rInfo['afk'] = text
  
        if rInfo['status'] then
          rInfo['afk'] = text
        end
      end
  
      if rInfo['oneid'] + 46 == id then
        if text:find("%-") then
          rInfo['engine'] = "-"
          rInfo['twint'] = "-"
        end
  
        if text:find("%w+%((.*)%)") then
          rec1, rec2 = text:match("(%w+)%((.*)%)")
        end
  
        if tostring(rec1) == tostring("On") then
          rInfo['engine'] = "Заведен"
        elseif tostring(rec1) == tostring("Off") then
          rInfo['engine'] = "Заглушен"
        end
  
        if tostring(rec2) == tostring("TT") then
          rInfo['twint'] = "Есть"
        elseif tostring(rec2) == tostring("NO TT") then
          rInfo['twint'] = "Нету"
        end
      end
    end
  end

  function sampev.onPlayerQuit(playerId, reason)
    while #logcon == ini.main.logconlimit do table.remove(logcon, 1) end
    logcon[#logcon+1] = ABGRtoStringRGB(ini.style.logcon_d).."[Q] {FFFFFF}"..sampGetPlayerNickname(playerId).."["..playerId.."] - "..quitReason[reason+1]
  end
-------------------------------------------------------------------

--                 Мелкие функции

  function save()
      inicfg.save(ini, dirIni)
  end

  function initializeRender()
      font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
      font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
  end

  --[[function mySort(a,b)
      if  a[2] < b [2] then
          return true
      end
      return false
  end ]]

-------------------------------------------------------------------

--                 Команды 

  function cmd_tpr(arg)
    local result, x, y, z = getNearestRoadCoordinates()
    if arg == "" then
      if result then 
        if rInfo['id'] ~= "-1" then
          lua_thread.create(function()
            sampSendChat("/plpos "..rInfo['id'].." "..x.." "..y.." "..z)
            wait(500)
            sampSendChat("/flip "..rInfo['id'])
          end)
        elseif rInfo['id'] == "-1" then
          sampSendChat("/plpos "..id.." "..x.." "..y.." "..z)
        end
      else
        sampAddChatMessage(tag_err..'Не найдено дороги поблизости.', -1)
      end
    elseif string.match(arg, "%a+") then
      sampAddChatMessage(tag_err..'Используйте: /tpr (ID)', -1)
    elseif string.match(arg, "%d+") then
      if sampIsPlayerConnected(arg) then
        lua_thread.create(function()
          sampSendChat("/plpos "..arg.." "..x.." "..y.." "..z)
          wait(500)
          sampSendChat("/flip "..arg)
        end)
      else
        sampAddChatMessage(tag_err..'Не найден игрок с данным ID.', -1)
      end
    else
      sampAddChatMessage(tag_err..'Используйте: /tpr (ID)', -1)
    end
  end
  function CMD_admins(argument)
    sampSendChat('/admins')
    requestAdmins = true
    lua_thread.create(function()
      while requestAdmins do wait(0) end
      if tonumber(argument) then
        local lvl = tonumber(argument)
        if lvl >= 1 and lvl <= 6 then
          local block = admins['list'][lvl]
          local countAfk = function(t)
            local i = 0
            for _, v in ipairs(t) do 
              if v[3] and v[3] > 0 then
                i = i + 1
              end
            end
            return i
          end
          sampAddChatMessage(('Администрация %s уровня онлайн [Всего: %s | В АФК: %s]:'):format(lvl >= 6 and '6+' or  lvl..'-го', #block, countAfk(block)), 0x1ECC00)
            for i, admin in ipairs(block) do
              local recon = admin[4] and (admin[4] >= 0 and ': /re ' ..admin[4] .. ',' or ':') or ':'
              sampAddChatMessage(('%s) %s(%s){FFFFFF}%s AFK: %s, Репутация: %s'):format(i, admin[1], admin[2], recon, admin[3] or 'N', admin[5] or 'N'), 0xFEFE22)
            end
            if #block == 0 then
            sampAddChatMessage('Отсутсвует', 0xFEFE22)
          end
          return
        end
        sampAddChatMessage(tag..'Используйте: /admins [ 1 - 6 ]', imgui.ColorConvertFloat4ToARGB(mc))
      else
        if argument:lower() == 'afk' then
          local count, arr = 0, {}
          for lvl = 1, 6 do
            local block = admins['list'][lvl]
            for _, v in ipairs(block) do 
              if v[3] and v[3] > 0 then
                count = count + 1
                local recon = v[4] and (v[4] >= 0 and ': /re ' ..v[4] .. ',' or ':') or ':'
                local str = ('%s) %s(%s){FFFFFF}%s AFK: %s, Репутация: %s'):format(count, v[1], v[2], recon, v[3] or 'N', v[5] or 'N')
                table.insert(arr, str)
              end
            end
          end
          sampAddChatMessage(('Администрация в АФК [Всего: %s]:'):format(count), 0x1ECC00)
          for _, str in ipairs(arr) do 
            sampAddChatMessage(str, 0xFEFE22)
          end
          if #arr == 0 then
            sampAddChatMessage('Отсутсвует', 0xFEFE22)
          end
          return
        end
        local count = 0
        sampAddChatMessage('Администрация онлайн:', 0x1ECC00)
        for lvl = 1, 6 do
          local block = admins['list'][lvl]
          for i, v in ipairs(block) do
            count = count + 1
            local recon = v[4] and (v[4] >= 0 and ': /re ' ..v[4] .. ',' or ':') or ':'
            local str = ('%s) %s(%s) [%s LVL]{FFFFFF}%s AFK: %s, Репутация: %s'):format(count, v[1], v[2], (lvl >= 6 and lvl..'+' or lvl), recon, v[3] or 'N', v[5] or 'N')
            sampAddChatMessage(str, 0xFEFE22)
          end
        end
        sampAddChatMessage(('Всего: %s, из них %s в АФК'):format(admins['online'], admins['afk']), 0x1ECC00)
      end
    end)
  end
  function cmd_amember()
    amember_window[0] = not amember_window[0]
  end
  function cmd_tp(arg)
    if arg:match("%d+") then
      if tonumber(arg) < 1 or tonumber(arg) > 28 then
        sampAddChatMessage(tag_err.."Выберите ID от 1го до 28и", -1)
      else
        sampSendChat("/tp "..arg)
      end
    else
      tp_window[0] = not tp_window[0]
    end
  end
--------------------------------------------------------------------

--                    Фигня всякая


  function keyname(key)
    if key ~= "" or key ~= nil then
      if #rkeys.getKeysName(key) == 1 then
        return rkeys.getKeysName(key)[1]
      elseif #rkeys.getKeysName(key) > 1 then
        for k, v in pairs(rkeys.getKeysName(key)) do
          cmdkey = k == 1 and v or "" .. "+" .. v
        end

        return cmdkey
      end
    else
      return "Не указана"
    end
  end
  function getMyNick()
    local result, id = sampGetPlayerIdByCharHandle(playerPed)
    if result then
        local nick = sampGetPlayerNickname(id)
        return nick
    end
  end

  function getMyId()
    local result, id = sampGetPlayerIdByCharHandle(playerPed)
    if result then
        return id
    end
  end
  function sampGetPlayerSkin(id)
    result, pedHandle = sampGetCharHandleBySampPlayerId(id)
    if result then
        skinId = getCharModel(pedHandle)
        return skinId
    end
  end
  function drawClickableText(active, font, text, posX, posY, color, colorA, align, b_symbol) --cfg.main.align
    local cursorX, cursorY = getCursorPos()
    local lenght = renderGetFontDrawTextLength(font, text)
    local height = renderGetFontDrawHeight(font)
    local symb_len = renderGetFontDrawTextLength(font, '>')
    local hovered = false
    local result = false
      b_symbol = b_symbol == nil and false or b_symbol
      align = align or 1
  
      if align == 2 then
        posX = posX - (lenght / 2)
      elseif align == 3 then
        posX = posX - lenght
    end
  
      if active and cursorX > posX and cursorY > posY and cursorX < posX + lenght and cursorY < posY + height then
          hovered = true
          if isKeyJustPressed(0x01) then -- LButton
            result = true 
          end
      end
  
      local anim = math.floor(math.sin(os.clock() * 10) * 3 + 5)
  
     if hovered and b_symbol and (align == 2 or align == 1) then
        renderFontDrawText(font, '>', posX - symb_len - anim, posY, 0x90FFFFFF)
      end 
  
      renderFontDrawText(font, text, posX, posY, hovered and color_hovered or color)
  
      if hovered and b_symbol and (align == 2 or align == 3) then
        renderFontDrawText(font, '<', posX + lenght + anim, posY, 0x90FFFFFF)
      end 
  
      return result
  end
  function imgui.ButtonWithSettings(text, settings, size)
    imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, settings.rounding or imgui.GetStyle().FrameRounding)
    imgui.PushStyleColor(imgui.Col.Button, settings.color or imgui.GetStyle().Colors[imgui.Col.Button])
    imgui.PushStyleColor(imgui.Col.ButtonHovered, settings.color_hovered or imgui.GetStyle().Colors[imgui.Col.ButtonHovered])
    imgui.PushStyleColor(imgui.Col.ButtonActive, settings.color_active or imgui.GetStyle().Colors[imgui.Col.ButtonActive])
    imgui.PushStyleColor(imgui.Col.Text, settings.color_text or imgui.GetStyle().Colors[imgui.Col.Text])
    local click = imgui.Button(text, size)
    imgui.PopStyleColor(4)
    imgui.PopStyleVar()
    return click
  end

  function theme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding         = imgui.ImVec2(8, 8)
    style.WindowRounding        = ini.style.rounding
    style.ChildRounding   		= 15
    style.FramePadding          = imgui.ImVec2(5, 3)
    style.FrameRounding         = 3.0
    style.ItemSpacing           = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing      = imgui.ImVec2(4, 4)
    style.IndentSpacing         = 21
    style.ScrollbarSize         = 10.0
    style.ScrollbarRounding     = 13
    style.GrabMinSize           = 8
    style.GrabRounding          = 1
    style.WindowTitleAlign      = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign       = imgui.ImVec2(0.5, 0.5)

    colors[clr.Text]                                = ImVec4(tc.x, tc.y, tc.z, 1.00)
    colors[clr.TextDisabled]                        = ImVec4(0.40, 0.40, 0.40, 1.00)
    colors[clr.WindowBg]                            = ImVec4(0.09, 0.09, 0.09, 1.00)
    colors[clr.ChildBg]                       		= ImVec4(0.09, 0.09, 0.09, 1.00)
    colors[clr.PopupBg]                             = ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[clr.Border]                              = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.BorderShadow]                        = ImVec4(0.00, 0.60, 0.00, 0.00)
    colors[clr.FrameBg]                             = ImVec4(0.20, 0.20, 0.20, 1.00)
    colors[clr.FrameBgHovered]                      = ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.FrameBgActive]                       = ImVec4(mc.x, mc.y, mc.z, 0.80)
    colors[clr.TitleBg]                             = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.TitleBgActive]                       = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.TitleBgCollapsed]                    = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.MenuBarBg]                           = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]                         = ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.ScrollbarGrab]                       = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.ScrollbarGrabHovered]                = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.ScrollbarGrabActive]                 = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.CheckMark]                           = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.SliderGrab]                          = ImVec4(mc.x, mc.y, mc.z, 0.70)
    colors[clr.SliderGrabActive]                    = ImVec4(mc.x, mc.y, mc.z, 1.00)
    colors[clr.Button]                              = ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.ButtonHovered]                       = ImVec4(mc.x, mc.y, mc.z, 0.80)
    colors[clr.ButtonActive]                        = ImVec4(mc.x, mc.y, mc.z, 0.90)
    colors[clr.Header]                              = ImVec4(1.00, 1.00, 1.00, 0.20)
    colors[clr.HeaderHovered]                       = ImVec4(1.00, 1.00, 1.00, 0.20)
    colors[clr.HeaderActive]                        = ImVec4(1.00, 1.00, 1.00, 0.30)
    colors[clr.TextSelectedBg]                      = ImVec4(mc.x, mc.y, mc.z, 0.90)
    colors[clr.Tab]                      			= ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.TabHovered]                      	= ImVec4(mc.x, mc.y, mc.z, 0.70)
    colors[clr.TabActive]                      		= ImVec4(mc.x, mc.y, mc.z, 0.90)
    colors[clr.TabUnfocused]                      	= ImVec4(mc.x, mc.y, mc.z, 0.50)
    colors[clr.TabUnfocusedActive]                  = ImVec4(mc.x, mc.y, mc.z, 0.90)
  end

  function mysplit (inputstr, sep)
      if sep == nil then
              sep = "%s"
      end
      local t={}
      for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
              table.insert(t, tonumber(str))
      end
      return t
  end

  function rainbow(speed, alpha)
    local alpha = alpha or 255
      local r = math.floor(math.sin(os.clock() * speed) * 127 + 128)
      local g = math.floor(math.sin(os.clock() * speed + 2) * 127 + 128)
      local b = math.floor(math.sin(os.clock() * speed + 4) * 127 + 128)
      return join_argb(alpha, r, g, b)
  end
------------------------------------------------------------------

--                       Вырезано
  function sendClickMap(kak, tak, epta)
    nepon = raknetNewBitStream()

    raknetBitStreamWriteFloat(nepon, kak)
    raknetBitStreamWriteFloat(nepon, tak)
    raknetBitStreamWriteFloat(nepon, epta)
    raknetSendRpc(119, nepon)
    raknetDeleteBitStream(nepon)
  end
  function SearchMarker(posX, posY, posZ, radius, isRace)
      local ret_posX = 0.0
      local ret_posY = 0.0
      local ret_posZ = 0.0
      local isFind = false

      for id = 0, 31 do
          local MarkerStruct = 0
          if isRace then MarkerStruct = 0xC7F168 + id * 56
          else MarkerStruct = 0xC7DD88 + id * 160 end
          local MarkerPosX = representIntAsFloat(readMemory(MarkerStruct + 0, 4, false))
          local MarkerPosY = representIntAsFloat(readMemory(MarkerStruct + 4, 4, false))
          local MarkerPosZ = representIntAsFloat(readMemory(MarkerStruct + 8, 4, false))

          if MarkerPosX ~= 0.0 or MarkerPosY ~= 0.0 or MarkerPosZ ~= 0.0 then
              if getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ, posX, posY, posZ) < radius then
                  ret_posX = MarkerPosX
                  ret_posY = MarkerPosY
                  ret_posZ = MarkerPosZ
                  isFind = true
                  radius = getDistanceBetweenCoords3d(MarkerPosX, MarkerPosY, MarkerPosZ, posX, posY, posZ)
              end
          end
      end

      return isFind, ret_posX, ret_posY, ret_posZ
  end
  function isPlayerOnline(nick)
    nick = nick:lower()
    for i = 0, 999 do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i):lower() == nick then
            return true
        end
    end
    return false
  end
  function enableDialog(bool)
    local memory = require 'memory'
    memory.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
    sampToggleCursor(bool)
  end
  function bringFloatTo(from, dest, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
      local count = timer / (duration / 100)
      return from + (count * (dest - from) / 100)
    end
    return (timer > duration) and dest or from
  end
  local print_orig = print
  function print(...)
      local args = {...}
      function table.val_to_str( v )
            if "string" == type( v ) then
              v = string.gsub( v, "\n", "\\n" )
              if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
                    return "'" .. v .. "'"
              end
              return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
            else
              return "table" == type( v ) and table.tostring( v ) or tostring( v )
            end
      end
      function table.key_to_str( k )
            if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
              return k
            else
              return "[" .. table.val_to_str( k ) .. "]"
            end
      end
      function table.tostring( tbl )
          local result, done = {}, {}
          for k, v in ipairs( tbl ) do
              table.insert( result, table.val_to_str( v ) )
              done[ k ] = true
          end
          for k, v in pairs( tbl ) do
              if not done[ k ] then
                  table.insert( result, table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
              end
          end
          return "{" .. table.concat( result, "," ) .. "}"
      end
      for i, arg in ipairs(args) do
          if type(arg) == "table" then
              args[i] = table.tostring(arg)
          end
      end
      print_orig(table.unpack(args))
  end
  function ip(cl)
    ips = {}
    for word in string.gmatch(cl, "(%d+%p%d+%p%d+%p%d+)") do
      table.insert(ips, { query = word })
    end
    if #ips > 0 then
      data_json = cjson.encode(ips)
      asyncHttpRequest(
        "POST",
        "http://ip-api.com/batch?fields=25305&lang=ru",
        { data = data_json },
        function(response)
          rdata = cjson.decode(u8:decode(response.text))
          textGetip = ""
          for i = 1, #rdata do
            if rdata[i]["status"] == "success" then
              distances =
                distance_cord(
                  rdata[1]["lat"],
                  rdata[1]["lon"],
                  rdata[i]["lat"],
                  rdata[i]["lon"]
                )
              if i == 1 then
                textGetip = textGetip .. string.format(
                  "Reg-ip:\n\nIP - %s\nСтрана - %s\nГород - %s\nПровайдер - %s\nРастояние - %d  \n\n",
                  rdata[i]["query"],
                  rdata[i]["country"],
                  rdata[i]["city"],
                  rdata[i]["isp"],
                  distances
                )
              else
                textGetip = textGetip .. string.format(
                  "Log-ip:\n\nIP - %s\nСтрана - %s\nГород - %s\nПровайдер - %s\nРастояние - %d  \n\n",
                  rdata[i]["query"],
                  rdata[i]["country"],
                  rdata[i]["city"],
                  rdata[i]["isp"],
                  distances
                )
              end
            end
          end
          if textGetip == "" then
            textGetip = " \n\tНичего не найдено"
          end
          if ini.main.getipwindow then
            getip_window[0] = true
          else
            sampAddChatMessage('', -1)
            sampAddChatMessage(string.format(maincolor.."[Ник] {FFFFFF}%s | "..maincolor.."R-IP {FFFFFF}[%s] "..maincolor.."A-IP {FFFFFF}[%s] "..maincolor.."L-IP {FFFFFF}[%s]", ipnick, rdata[1]["query"], getipip2, rdata[2]["query"]), -1)
            sampAddChatMessage(string.format(maincolor.."[Страна] REG - {FFFFFF}%s | "..maincolor.."Last - {FFFFFF}%s", rdata[1]["country"], rdata[2]["country"]), -1)
            sampAddChatMessage(string.format(maincolor.."[Город] REG - {FFFFFF}%s | "..maincolor.."Last - {FFFFFF}%s", rdata[1]["city"], rdata[2]["city"]), -1)
            sampAddChatMessage(string.format(maincolor.."[Провайдер] REG - {FFFFFF}%s | "..maincolor.."Last - {FFFFFF}%s", rdata[1]["isp"], rdata[2]["isp"]), -1)
            sampAddChatMessage(string.format(maincolor.."Расстояние между городами: {FFFFFF}[~%s]"..maincolor.."км.", math.ceil(distances)), -1)
            sampAddChatMessage('', -1)
          end
        end,
        function(err)
          sampAddChatMessage(tag_err..'Произошла ошибка \n '..err, -1)
        end
      )
    end
  end
  function showdialog(name, rdata)
    sampShowDialog(
      math.random(1000),
      "{FF4444}" .. name,
      rdata,
      "Закрыть",
      false,
      0
    )
  end

  function distance_cord(lat1, lon1, lat2, lon2)
    if lat1 == nil or lon1 == nil or lat2 == nil or lon2 == nil or lat1 == "" or lon1 == "" or lat2 == "" or lon2 == "" then
      return 0
    end
    local dlat = math.rad(lat2 - lat1)
    local dlon = math.rad(lon2 - lon1)
    local sin_dlat = math.sin(dlat / 2)
    local sin_dlon = math.sin(dlon / 2)
    local a =
      sin_dlat * sin_dlat + math.cos(math.rad(lat1)) * math.cos(
        math.rad(lat2)
      ) * sin_dlon * sin_dlon
    local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    local d = 6378 * c
    return d
  end
  function asyncHttpRequest(method, url, args, resolve, reject)
    local request_thread = effil.thread(function(method, url, args)
      local requests = require"requests"
      local result, response = pcall(requests.request, method, url, args)
      if result then
        response.json, response.xml = nil, nil
        return true, response
      else
        return false, response
      end
    end)(method, url, args)
  
    if not resolve then
      resolve = function() end
    end
    if not reject then
      reject = function() end
    end
    lua_thread.create(function()
      local runner = request_thread
      while true do
        local status, err = runner:status()
        if not err then
          if status == "completed" then
            local result, response = runner:get()
            if result then
              resolve(response)
            else
              reject(response)
            end
            return
          elseif status == "canceled" then
            return reject(status)
          end
        else
          return reject(err)
        end
        wait(0)
      end
    end)
  end
  function sampSetChatInputCursor(start, finish)
    local finish = finish or start
    local start, finish = tonumber(start), tonumber(finish)
    local mem = require 'memory'
    local chatInfoPtr = sampGetInputInfoPtr()
    local chatBoxInfo = getStructElement(chatInfoPtr, 0x8, 4)
    mem.setint8(chatBoxInfo + 0x11E, start)
    mem.setint8(chatBoxInfo + 0x119, finish)
    return true
  end
  function getPlayerIdByNickname(name)
    for i = 0, sampGetMaxPlayerId(false) do
        if sampIsPlayerConnected(i) then
            if sampGetPlayerNickname(i):lower() == tostring(name):lower() then return true, i end
        end
    end
    return false
  end
  function imgui.BeginCustomChild(str_id, size, color)
    local pos = imgui.GetCursorScreenPos()
    local Y = imgui.GetCursorPos().y
    local drawList = imgui.GetWindowDrawList()
    local rounding = imgui.GetStyle().ChildRounding
    local text = str_id:gsub('##.+$', '')
    local lenght = imgui.CalcTextSize(text).x
    imgui.BeginChild(str_id, imgui.ImVec2(size.x, size.y), false)
    local wsize = imgui.GetWindowSize()
    imgui.SetCursorPosX((wsize.x - lenght) / 2)
    imgui.Text(text)
    drawList:AddRect(imgui.ImVec2(pos.x - 1, pos.y - 1), imgui.ImVec2(pos.x + wsize.x + 1, pos.y + wsize.y + 1), color, rounding)
    drawList:AddRectFilled(imgui.ImVec2(pos.x - 1, pos.y - 1), imgui.ImVec2(pos.x + wsize.x + 1, pos.y + 17 + 1), color, rounding, 19)
  end
  function imgui.CustomBarCheckers()
    local pos = imgui.GetCursorScreenPos()
    local winWide = imgui.GetWindowWidth()
    local drawList = imgui.GetWindowDrawList()

    local count = #checkers['buttons']
    local butWide = winWide / count
    local animTime = 0.2
    local sel = checkers['selected']
    local col = imgui.ColorConvertFloat4ToU32(mc)

      drawList:AddRectFilled(imgui.ImVec2(pos.x, pos.y), imgui.ImVec2(pos.x + winWide, pos.y + 60), 0xFF191919, 15)
      
      local renderButton = function(n, color)
        if n == 1 then
          drawList:AddRectFilled(imgui.ImVec2(pos.x + (butWide * n) - butWide, pos.y), imgui.ImVec2(pos.x + (butWide * n), pos.y + 60), color, 15, 5)
        elseif n == count then
          drawList:AddRectFilled(imgui.ImVec2(pos.x + (butWide * n) - butWide, pos.y), imgui.ImVec2(pos.x + (butWide * n), pos.y + 60), color, 15, 10)
        else
          drawList:AddRectFilled(imgui.ImVec2(pos.x + (butWide * n) - butWide, pos.y), imgui.ImVec2(pos.x + (butWide * n), pos.y + 60), color)
        end
      end
      local smooth = function(color)
      local s = function(f)
        return f < 0 and 0 or (f > 255 and 255 or f)
      end
      local _, r, g, b = explode_U32(color)
        local a = s((os.clock() - checkers['clicked']['time']) * (128 / animTime))
        return join_argb(a, r, g, b)
      end
      if checkers['clicked']['time'] and os.clock() - checkers['clicked']['time'] < 0.4 then
        renderButton(sel, smooth(col))
    else
      renderButton(sel, col)
    end
      imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 15)
      imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 4))
      imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      for i, button in ipairs(checkers['buttons']) do
        if imgui.Button(u8(button .. '##' .. i), imgui.ImVec2(butWide, 60)) then
          if checkers['selected'] ~= i then
            checkers['clicked']['last'] = checkers['selected']
            checkers['clicked']['time'] = os.clock()
            checkers['selected'] = i
          end
        end
        if i ~= count then
          imgui.SameLine()
        end
      end
      imgui.PopStyleColor(3)
      imgui.PopStyleVar(2)
    end
    function imgui.Hint(str_id, hint, delay)
    local hovered = imgui.IsItemHovered()
    local col = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
    local animTime = 0.2
    local delay = delay or 0.00
    local show = true

    if not allHints then allHints = {} end
    if not allHints[str_id] then
      allHints[str_id] = {
        status = false,
        timer = 0
      }
    end

    if hovered then
      for k, v in pairs(allHints) do
        if k ~= str_id and os.clock() - v.timer <= animTime  then
          show = false
        end
      end
    end

    if show and allHints[str_id].status ~= hovered then
      allHints[str_id].status = hovered
      allHints[str_id].timer = os.clock() + delay
    end

    local showHint = function(text, alpha)
      imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)
      imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 5)
      imgui.BeginTooltip()
        imgui.TextColored(imgui.ImVec4(col.x, col.y, col.z, 1.00), fa.ICON_FA_INFO_CIRCLE..u8' Подсказка:')
        imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
        imgui.TextColoredRGB(text, false, true)
        imgui.PopStyleVar()
      imgui.EndTooltip()
      imgui.PopStyleVar(2)
    end

    if show then
      local btw = os.clock() - allHints[str_id].timer
      if btw <= animTime then
        local s = function(f) 
          return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
        end
        local alpha = hovered and s(btw / animTime) or s(1.00 - btw / animTime)
        showHint(hint, alpha)
      elseif hovered then
        showHint(hint, 1.00)
      end
    end
  end
  function explode_U32(u32)
    local a = bit.band(bit.rshift(u32, 24), 0xFF)
    local r = bit.band(bit.rshift(u32, 16), 0xFF)
    local g = bit.band(bit.rshift(u32, 8), 0xFF)
    local b = bit.band(u32, 0xFF)
    return a, r, g, b
  end

  function join_argb(a, r, g, b)
    local argb = b
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
  end

  function imgui.ColorConvertFloat4ToARGB(float4)
    local abgr = imgui.ColorConvertFloat4ToU32(float4)
    local a, b, g, r = explode_U32(abgr)
    return join_argb(a, r, g, b)
  end

  function ARGBtoStringRGB(argb)
    local color = ('%x'):format(bit.band(argb, 0xFFFFFF))
    return ('{%s%s}'):format(('0'):rep(6 - #color), color)
  end

  function ABGRtoStringRGB(abgr)
    local a, b, g, r = explode_U32(abgr)
    local argb = join_argb(a, r, g, b)
    return ARGBtoStringRGB(argb)
  end
  function imgui.CloseButton(rad, bool)
    local pos = imgui.GetCursorScreenPos()
    local poss = imgui.GetCursorPos()
    local a, b, c, d = pos.x - rad, pos.x + rad, pos.y - rad, pos.y + rad
    local e, f = poss.x - rad, poss.y - rad
    local drawList = imgui.GetWindowDrawList()
    drawList:AddLine(imgui.ImVec2(a, d), imgui.ImVec2(b, c), cbcolor and cbcolor or -1)
    drawList:AddLine(imgui.ImVec2(b, d), imgui.ImVec2(a, c), cbcolor and cbcolor or -1)
    imgui.SetCursorPos(imgui.ImVec2(e, f))
    if imgui.InvisibleButton('##closebut', imgui.ImVec2(rad * 2, rad * 2)) then
        bool[0] = false
    end
    cbcolor = imgui.IsItemHovered() and 0xFF707070 or nil
  end

  function imgui_text_wrappedot(text)

    text = ffi.new('char[?]', #text + 1, text)
    local text_end = text + ffi.sizeof(text) - 1
    local pFont = imgui.GetFont()

    local scale = 1.0
    local endPrevLine = pFont:CalcWordWrapPositionA(scale, text, text_end, imgui.GetContentRegionAvail().x)
    imgui.TextUnformatted(text, endPrevLine)

    while endPrevLine < text_end do
        text = endPrevLine
        if text[0] == 32 then text = text + 1 end
        endPrevLine = pFont:CalcWordWrapPositionA(scale, text, text_end, imgui.GetContentRegionAvail().x)
        if text == endPrevLine then
            endPrevLine = endPrevLine + 1
        end
        imgui.TextUnformatted(text, endPrevLine)
    end

    if clr then imgui.PopStyleColor() end
  end

  function imgui.CenterTextColoredSameLine(clr, text)
    local width = imgui.GetWindowWidth()
    local lenght = imgui.CalcTextSize(text).x
  
    imgui.SetCursorPosX((width - lenght) / 2)
    imgui.SameLine()
    imgui.TextColored(clr, text)
  end

  function imgui.CenterTextColored(clr, text)
    local width = imgui.GetWindowWidth()
    local lenght = imgui.CalcTextSize(text).x
  
    imgui.SetCursorPosX((width - lenght) / 2)
    imgui.TextColored(clr, text)
  end

  function getNearestRoadCoordinates(radius)
    local A = { getCharCoordinates(PLAYER_PED) }
    local B = { getClosestStraightRoad(A[1], A[2], A[3], 0, radius or 600) }
    if B[1] ~= 0 and B[2] ~= 0 and B[3] ~= 0 then
        return true, B[1], B[2], B[3]
    end
    return false
  end

  local splitsigned = function(n) --  нагло спизженно с гита WINAPI.lua
      n = tonumber(n)
      local x, y = bit.band(n, 0xffff), bit.rshift(n, 16)
      if x >= 0x8000 then x = x-0xffff end
      if y >= 0x8000 then y = y-0xffff end
      return x, y
  end

  function rotateCarAroundUpAxis(car, vec)
    local mat = Matrix3X3(getVehicleRotationMatrix(car))
    local rotAxis = Vector3D(mat.up:get())
    vec:normalize()
    rotAxis:normalize()
    local theta = math.acos(rotAxis:dotProduct(vec))
    if theta ~= 0 then
      rotAxis:crossProduct(vec)
      rotAxis:normalize()
      rotAxis:zeroNearZero()
      mat = mat:rotate(rotAxis, -theta)
    end
    setVehicleRotationMatrix(car, mat:get())
  end

  function readFloatArray(ptr, idx)
    return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
  end

  function writeFloatArray(ptr, idx, value)
    writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
  end

  function getVehicleRotationMatrix(car)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
      local mat = readMemory(entityPtr + 0x14, 4, false)
      if mat ~= 0 then
        local rx, ry, rz, fx, fy, fz, ux, uy, uz
        rx = readFloatArray(mat, 0)
        ry = readFloatArray(mat, 1)
        rz = readFloatArray(mat, 2)

        fx = readFloatArray(mat, 4)
        fy = readFloatArray(mat, 5)
        fz = readFloatArray(mat, 6)

        ux = readFloatArray(mat, 8)
        uy = readFloatArray(mat, 9)
        uz = readFloatArray(mat, 10)
        return rx, ry, rz, fx, fy, fz, ux, uy, uz
      end
    end
  end

  function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
      local mat = readMemory(entityPtr + 0x14, 4, false)
      if mat ~= 0 then
        writeFloatArray(mat, 0, rx)
        writeFloatArray(mat, 1, ry)
        writeFloatArray(mat, 2, rz)

        writeFloatArray(mat, 4, fx)
        writeFloatArray(mat, 5, fy)
        writeFloatArray(mat, 6, fz)

        writeFloatArray(mat, 8, ux)
        writeFloatArray(mat, 9, uy)
        writeFloatArray(mat, 10, uz)
      end
    end
  end

  function displayVehicleName(x, y, gxt)
    x, y = convertWindowScreenCoordsToGameScreenCoords(x, y)
    useRenderCommands(true)
    setTextWrapx(640.0)
    setTextProportional(true)
    setTextJustify(false)
    setTextScale(0.33, 0.8)
    setTextDropshadow(0, 0, 0, 0, 0)
    setTextColour(255, 255, 255, 230)
    setTextEdge(1, 0, 0, 0, 100)
    setTextFont(1)
    displayText(x, y, gxt)
  end

  function createPointMarker(x, y, z)
    pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
  end

  function removePointMarker()
    if pointMarker then
      removeUser3dMarker(pointMarker)
      pointMarker = nil
    end
  end

  function getCarFreeSeat(car)
    if doesCharExist(getDriverOfCar(car)) then
      local maxPassengers = getMaximumNumberOfPassengers(car)
      for i = 0, maxPassengers do
        if isCarPassengerSeatFree(car, i) then
          return i + 1
        end
      end
      return nil -- no free seats
    else
      return 0 -- driver seat
    end
  end

  function jumpIntoCar(car)
    local seat = getCarFreeSeat(car)
    if not seat then return false end                         -- no free seats
    if seat == 0 then warpCharIntoCar(playerPed, car)         -- driver seat
    else warpCharIntoCarAsPassenger(playerPed, car, seat - 1) -- passenger seat
    end
    restoreCameraJumpcut()
    return true
  end

  function teleportPlayer(x, y, z)
    if isCharInAnyCar(playerPed) then
      setCharCoordinates(playerPed, x, y, z)
    end
    setCharCoordinatesDontResetAnim(playerPed, x, y, z)
  end

  function setCharCoordinatesDontResetAnim(char, x, y, z)
    if doesCharExist(char) then
      local ptr = getCharPointer(char)
      setEntityCoordinates(ptr, x, y, z)
    end
  end

  function setEntityCoordinates(entityPtr, x, y, z)
    if entityPtr ~= 0 then
      local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
      if matrixPtr ~= 0 then
        local posPtr = matrixPtr + 0x30
        writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
        writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
        writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
      end
    end
  end

  function showCursor(toggle)
    if toggle then
      sampSetCursorMode(CMODE_LOCKCAM)
    else
      sampToggleCursor(false)
    end
    cursorEnabled = toggle
  end
    
  function imgui.TextColoredRGB(text, shadow, wrapped)
	local style = imgui.GetStyle()
	local colors = style.Colors

	local designText = function(text)
		local pos = imgui.GetCursorPos()
		for i = 1, 1 do
			imgui.SetCursorPos(imgui.ImVec2(pos.x + i, pos.y))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x - i, pos.y))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y + i))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
			imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y - i))
			imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text)
		end
		imgui.SetCursorPos(pos)
	end

	text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')
	local render_func = wrapped and imgui_text_wrapped or function(clr, text)
		if clr then imgui.PushStyleColor(ffi.C.ImGuiCol_Text, clr) end
		if shadow then designText(text) end
		imgui.TextUnformatted(text)
		if clr then imgui.PopStyleColor() end
	end

	local split = function(str, delim, plain)
		local tokens, pos, i, plain = {}, 1, 1, not (plain == false)
		repeat
			local npos, epos = string.find(str, delim, pos, plain)
			tokens[i] = string.sub(str, pos, npos and npos - 1)
			pos = epos and epos + 1
			i = i + 1
		until not pos
		return tokens
	end

	local color = colors[ffi.C.ImGuiCol_Text]
	for _, w in ipairs(split(text, '\n')) do
		local start = 1
		local a, b = w:find('{........}', start)
		while a do
			local t = w:sub(start, a - 1)
			if #t > 0 then
				render_func(color, t)
				imgui.SameLine(nil, 0)
			end

			local clr = w:sub(a + 1, b - 1)
			if clr:upper() == 'STANDART' then color = colors[ffi.C.ImGuiCol_Text]
			else
				clr = tonumber(clr, 16)
				if clr then
					local r = bit.band(bit.rshift(clr, 24), 0xFF)
					local g = bit.band(bit.rshift(clr, 16), 0xFF)
					local b = bit.band(bit.rshift(clr, 8), 0xFF)
					local a = bit.band(clr, 0xFF)
					color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
				end
			end

			start = b + 1
			a, b = w:find('{........}', start)
		end
		imgui.NewLine()
		if #w >= start then
			imgui.SameLine(nil, 0)
			render_func(color, w:sub(start))
		end
	end
  end

-----------------------------------------------------------------

--                             Системки

  function autoupdate(json_url, prefix, url)
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile(json_url, json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              local info = decodeJson(f:read('*a'))
              updatelink = info.updateurl
              updateversion = info.latest
              f:close()
              os.remove(json)
              if updateversion ~= thisScript().version then
                lua_thread.create(function(prefix)
                  local dlstatus = require('moonloader').download_status
                  local color = -1
                  sampAddChatMessage(tag..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion, -1)
                  wait(250)
                  downloadUrlToFile(updatelink, thisScript().path,
                    function(id3, status1, p13, p23)
                      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                        print(string.format('Загружено %d из %d.', p13, p23))
                      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                        print('Загрузка обновления завершена.')
                        sampAddChatMessage(tag..'Обновление завершено!', -1)
                        goupdatestatus = true
                        lua_thread.create(function() wait(500) thisScript():reload() end)
                      end
                      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                        if goupdatestatus == nil then
                          sampAddChatMessage(tag..'Обновление прошло неудачно. Запускаю устаревшую версию..', -1)
                          update = false
                        end
                      end
                    end
                  )
                  end, prefix
                )
              else
                update = false
                print('v'..thisScript().version..': Обновление не требуется.')
              end
            end
          else
            print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
            update = false
          end
        end
      end
    )
    while update ~= false do wait(100) end
  end
  function checkIntable(t, str)
    for k, v in pairs(t) do
      if v == str then return true end
    end
    return false
  end
  function number_week() -- получение номера недели в году
    local current_time = os.date'*t'
    local start_year = os.time{ year = current_time.year, day = 1, month = 1 }
    local week_day = ( os.date('%w', start_year) - 1 ) % 7
    return math.ceil((current_time.yday + week_day) / 7)
  end

  function getStrDate(unixTime)
    local tMonths = {'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'}
    local day = tonumber(os.date('%d', unixTime))
    local month = tMonths[tonumber(os.date('%m', unixTime))]
    local weekday = tWeekdays[tonumber(os.date('%w', unixTime))]
    return string.format('%s, %s %s', weekday, day, month)
  end

  function get_clock(time)
    local timezone_offset = 86400 - os.date('%H', 0) * 3600
    if tonumber(time) >= 86400 then onDay = true else onDay = false end
    return os.date((onDay and math.floor(time / 86400)..'д ' or '')..'%H:%M:%S', time + timezone_offset)
  end
  function imgui.NewInputText(lable, val, width, hint, hintpos)
    local hint = hint and hint or ''
    local hintpos = tonumber(hintpos) and tonumber(hintpos) or 1
    local cPos = imgui.GetCursorPos()
    imgui.PushItemWidth(width)
    local result = imgui.InputText(lable, val, sizeof(val))
    if #str(val) == 0 then
        local hintSize = imgui.CalcTextSize(hint)
        if hintpos == 2 then imgui.SameLine(cPos.x + (width - hintSize.x) / 2)
        elseif hintpos == 3 then imgui.SameLine(cPos.x + (width - hintSize.x - 5))
        else imgui.SameLine(cPos.x + 5) end
        imgui.TextColored(imgui.ImVec4(1.00, 1.00, 1.00, 0.40), tostring(hint))
    end
    imgui.PopItemWidth()
    return result
  end
  function imgui.BoolButton(bool, ...)
    if type(bool) ~= 'boolean' then return end
    if bool then
      imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1.00, 0.28, 0.28, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.28, 0.28, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1.00, 0.28, 0.28, 1.00))
        local result = imgui.Button(...)
        imgui.PopStyleColor(3)
        return result
    else
      imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.20, 0.20, 0.20, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.18, 0.18, 0.18, 1.00))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.16, 0.16, 0.16, 1.00))
        local result = imgui.Button(...)
        imgui.PopStyleColor(3)
        return result
    end
  end
  function imgui.Question(...)
    imgui.SameLine()
    imgui.SetCursorPosY(imgui.GetCursorPos().y + 3)
    imgui.PushFont(imFont[11])
    imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.3), fa.ICON_FA_QUESTION)
    imgui.PopFont()
    local id = imgui.GetCursorPos()
    imgui.Hint(...)
    imgui.SetCursorPosY(imgui.GetCursorPos().y - 3)
  end
  function imgui.NavigateButton(bool, icon, name)
    local buttonWide = 190
    local animTime = 0.25
    local drawList = imgui.GetWindowDrawList()
    local p1 = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
      local button = imgui.InvisibleButton(name, imgui.ImVec2(buttonWide, 35))
      if button and not bool then navigateLast = os.clock() end
      local pressed = imgui.IsItemActive()
      imgui.PopStyleColor(3)
    if bool then
      if navigateLast and (os.clock() - navigateLast) < animTime then
        local wide = (os.clock() - navigateLast) * (buttonWide / animTime)
        drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2((p1.x + 190) - wide, p1.y + 35), 0x10FFFFFF, 15, 10)
            drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 5, p1.y + 35), imgui.ColorConvertFloat4ToU32(mc))
        drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + wide, p1.y + 35), imgui.ColorConvertFloat4ToU32(imgui.ImVec4(mc.x, mc.y, mc.z, 0.6)), 15, 10)
      else
        drawList:AddRectFilled(imgui.ImVec2(p1.x, (pressed and p1.y + 3 or p1.y)), imgui.ImVec2(p1.x + 5, (pressed and p1.y + 32 or p1.y + 35)), imgui.ColorConvertFloat4ToU32(mc))
        drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), imgui.ColorConvertFloat4ToU32(imgui.ImVec4(mc.x, mc.y, mc.z, 0.6)), 15, 10)
      end
    else
      if imgui.IsItemHovered() then
        drawList:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), 0x10FFFFFF, 15, 10)
      end
    end
    imgui.SameLine(10); imgui.SetCursorPosY(p2.y + 8)
    if bool then
      imgui.Text((' '):rep(3) .. icon)
      imgui.SameLine(60)
      imgui.Text(name)
    else
      imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), (' '):rep(3) .. icon)
      imgui.SameLine(60)
      imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), name)
    end
    imgui.SetCursorPosY(p2.y + 40)
    return button
  end

  function imgui.SubTitle(title)
    imgui.PushFont(imFont[18])
    imgui.TextColored(mc, title)
    imgui.PopFont()
  end
  function getTargetBlipCoordinatesFixed()
    local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
    requestCollision(x, y); loadScene(x, y, z)
    local bool, x, y, z = getTargetBlipCoordinates()
    return bool, x, y, z
  end
  function ShowMessage(text, title, style)
    ffi.cdef [[
        int MessageBoxA(
            void* hWnd,
            const char* lpText,
            const char* lpCaption,
            unsigned int uType
            
        );
    ]]
    local hwnd = ffi.cast('void*', readMemory(0x00C8CF88, 4, false))
    ffi.C.MessageBoxA(hwnd, text,  title, style and (style + 0x50000) or 0x50000)
  end 

  function gpsDw()
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\Arizona Tools\\gps.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile("https://raw.githubusercontent.com/edisondorado/arizonatools/main/gps", json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              gpsInfo = decodeJson(f:read('*a'))
              f:close()
            end
          end
        end
      end
    )

    local json = getWorkingDirectory() .. '\\Arizona Tools\\cmd.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile("https://raw.githubusercontent.com/edisondorado/arizonatools/main/cmd", json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              cmdInfo = decodeJson(f:read('*a'))
              f:close()
            end
          end
        end
      end
    )--

    local json = getWorkingDirectory() .. '\\Arizona Tools\\questions.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile("https://raw.githubusercontent.com/edisondorado/arizonatools/main/questions", json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              questionInfo = decodeJson(f:read('*a'))
              f:close()
            end
          end
        end
      end
    )
  end
  

  addEventHandler("onWindowMessage", function (msg, wparam, lparam)
      if msg == wm.WM_MOUSEWHEEL and enAirBrake then
          local button, delta = splitsigned(ffi.cast('int32_t', wparam))
          if delta > 0 then
              if ini.main.speed_airbrake <= 0.1 then
                  return false
              end
              ini.main.speed_airbrake = ini.main.speed_airbrake - 0.03
          elseif delta < 0 then
              ini.main.speed_airbrake = ini.main.speed_airbrake + 0.03
          end
      end
  end)

  function infoReport(answer)
    sampAddChatMessage('{ffa6a6}---------------------------------------------------------------------------------------------', -1)
    sampAddChatMessage('', -1)
    sampAddChatMessage('', -1)
    sampAddChatMessage(ABGRtoStringRGB(ini.style.color)..'Автор жалобы: {FFFFFF}'..repNick.."["..repId.."]", -1)
    sampAddChatMessage(ABGRtoStringRGB(ini.style.color)..'Текст: {FFFFFF}'..repText, -1)
    sampAddChatMessage(ABGRtoStringRGB(ini.style.color)..'Ответ: {FFFFFF}'..answer, -1)
    sampAddChatMessage('', -1)
    sampAddChatMessage('', -1)
    sampAddChatMessage('{ffa6a6}---------------------------------------------------------------------------------------------', -1)
  end

---------------------------------------------------------------------