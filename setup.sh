#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════════════════════
# Remna Reiwa Subpage — Setup Script
# ═══════════════════════════════════════════════════════════════════════════
# Usage:
#   bash setup.sh              # interactive prompts
#   bash setup.sh -t 3        # skip prompts, set theme directly
#   bash setup.sh -t 2 -l ru  # theme + language
#   bash setup.sh -t 1 -m light  # Purple light variant
#
# One-liner (download + run):
#   curl -L -s -O https://raw.githubusercontent.com/Demyasha-An/Remna-Reiwa-Subpage/main/setup.sh && bash setup.sh -t 3
# ═══════════════════════════════════════════════════════════════════════════

REPO_URL="https://raw.githubusercontent.com/Demyasha-An/Remna-Reiwa-Subpage/main"

# ── Argument parsing ─────────────────────────────────────────────────────
THEME_ARG=""
LANG_ARG=""
MODE_ARG=""
while getopts "t:l:m:" opt; do
    case "$opt" in
        t) THEME_ARG="$OPTARG" ;;
        l) LANG_ARG="$OPTARG" ;;
        m) MODE_ARG="$OPTARG" ;;
        *) echo "Usage: bash setup.sh [-t theme(1-11)] [-m dark|light] [-l en|ru]"; exit 1 ;;
    esac
done

# ── Language ─────────────────────────────────────────────────────────────
if [ "$LANG_ARG" = "ru" ]; then
    L="ru"
elif [ "$LANG_ARG" = "en" ]; then
    L="en"
elif [ -t 0 ]; then
    echo ""
    echo "  Remna Reiwa Subpage — Setup"
    echo "  ───────────────────────────"
    echo ""
    echo "  Select language:"
    echo "    1) English"
    echo "    2) Русский"
    echo ""
    read -rp "  > " lang_choice
    [ "$lang_choice" = "2" ] && L="ru" || L="en"
else
    L="en"
fi

# ── Localized strings ────────────────────────────────────────────────────
if [ "$L" = "ru" ]; then
    MSG_THEME="Выбери тему оформления:"
    MSG_DOWNLOAD="Скачиваю index.html..."
    MSG_OK="Готово! Тема применена."
    MSG_INVALID="Неверный выбор. Попробуй ещё раз."
    THEMES=(
        "Default (Purple) — фиолетовый"
        "Monochrome — чёрно-белый"
        "Cyberpunk — розовый/голубой неон"
        "Emerald — изумрудный"
        "Amber — янтарный"
        "Ocean — синий"
        "Blush — светло-розовый"
        "Open Red — красный (open-color)"
        "Open Grape — виноград (open-color)"
        "Open Teal — бирюза (open-color)"
        "Open Yellow — жёлтый (open-color)"
    )
else
    MSG_THEME="Select theme:"
    MSG_DOWNLOAD="Downloading index.html..."
    MSG_OK="Done! Theme applied."
    MSG_INVALID="Invalid choice. Try again."
    THEMES=(
        "Default (Purple)"
        "Monochrome (black & white)"
        "Cyberpunk (pink/blue neon)"
        "Emerald (green)"
        "Amber (warm orange)"
        "Ocean (blue)"
        "Blush (light pink)"
        "Open Red (open-color)"
        "Open Grape (open-color)"
        "Open Teal (open-color)"
        "Open Yellow (open-color)"
    )
fi

# ── Theme selection ──────────────────────────────────────────────────────
if [ -n "$THEME_ARG" ]; then
    theme_choice="$THEME_ARG"
else
    echo ""
    echo "  $MSG_THEME"
    echo ""
    for i in "${!THEMES[@]}"; do
        printf "  %d) %s\n" $((i+1)) "${THEMES[$i]}"
    done
    echo ""
    while true; do
        read -rp "  Theme [1-${#THEMES[@]}]: " theme_choice
        case "$theme_choice" in
            1|2|3|4|5|6|7|8|9|10|11) break ;;
            *) echo "  $MSG_INVALID" ;;
        esac
    done
fi

# ── Appearance mode (dark / light) ───────────────────────────────────────
if [ "$MODE_ARG" = "light" ] || [ "$MODE_ARG" = "dark" ]; then
    MODE_CHOICE="$MODE_ARG"
elif [ -t 0 ]; then
    echo ""
    if [ "$L" = "ru" ]; then
        echo "  Режим оформления:"
        echo "    1) Тёмный"
        echo "    2) Светлый (белая вариация)"
        read -rp "  > " mode_pick
        [ "$mode_pick" = "2" ] && MODE_CHOICE="light" || MODE_CHOICE="dark"
    else
        echo "  Appearance mode:"
        echo "    1) Dark"
        echo "    2) Light (white variant)"
        read -rp "  > " mode_pick
        [ "$mode_pick" = "2" ] && MODE_CHOICE="light" || MODE_CHOICE="dark"
    fi
else
    MODE_CHOICE="dark"
fi

# ── Theme config ─────────────────────────────────────────────────────────
PRIMARY_TEXT="#0a0a0a"
case "$theme_choice" in
    1) # Default (Purple)
        PRIMARY="#c084fc"; PRIMARY_RGB="192, 132, 252"; HOVER="#a78bfa"; BACKGROUND="#0a0812"; INFO="#c084fc"; THEME_COLOR="#c084fc"
        BG_GRADIENT_START="#1e1b4b"; BG_GRADIENT_MID="#0f0a1a"; BG_GRADIENT_END="#020617"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#93c5fd"; C_CYAN="#67e8f9"; C_DARK="#1e293b"; C_GRAPE="#c084fc"; C_GRAY="#6b7280"
        C_GREEN="#6ee7b7"; C_INDIGO="#a5b4fc"; C_LIME="#bef264"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
        C_RED="#fca5a5"; C_TEAL="#5eead4"; C_VIOLET="#c084fc"; C_YELLOW="#fde68a"
        WARP_L1='                            [0.07, 0.07, 0.07],'
        WARP_L2='                            [0.58, 0.44, 1.0],'
        WARP_L3='                            [0.07, 0.07, 0.07],'
        WARP_L4='                            [0.53, 0.22, 1.0],'
        ;;
    2) # Monochrome
        PRIMARY="#e0e0e0"; PRIMARY_RGB="224, 224, 224"; HOVER="#c0c0c0"; BACKGROUND="#0a0a0a"; INFO="#9ca3af"; THEME_COLOR="#666666"
        BG_GRADIENT_START="#1a1a1a"; BG_GRADIENT_MID="#0f0f0f"; BG_GRADIENT_END="#050505"; BG_GLOW="rgba(var(--primary-rgb), 0.03)"
        C_BLUE="#a0a0a0"; C_CYAN="#b0b0b0"; C_DARK="#1a1a1a"; C_GRAPE="#c0c0c0"; C_GRAY="#707070"
        C_GREEN="#a0a0a0"; C_INDIGO="#909090"; C_LIME="#b0b0b0"; C_ORANGE="#c0c0c0"; C_PINK="#b0b0b0"
        C_RED="#d0a0a0"; C_TEAL="#a0b0b0"; C_VIOLET="#c0c0c0"; C_YELLOW="#c0b0a0"
        WARP_L1='                            [0.02, 0.02, 0.02],'
        WARP_L2='                            [0.5, 0.5, 0.5],'
        WARP_L3='                            [0.02, 0.02, 0.02],'
        WARP_L4='                            [0.8, 0.8, 0.8],'
        ;;
    3) # Cyberpunk — hot pink / cyan neon
        PRIMARY="#ff2d78"; PRIMARY_RGB="255, 45, 120"; HOVER="#ff6b9d"; BACKGROUND="#0a0515"; INFO="#00d4ff"; THEME_COLOR="#ff2d78"
        BG_GRADIENT_START="#2d0a1e"; BG_GRADIENT_MID="#0f0515"; BG_GRADIENT_END="#050210"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#00d4ff"; C_CYAN="#00ffcc"; C_DARK="#12082a"; C_GRAPE="#ff6b9d"; C_GRAY="#6b7280"
        C_GREEN="#00ff88"; C_INDIGO="#7c3aed"; C_LIME="#c6ff00"; C_ORANGE="#ff6600"; C_PINK="#ff2d78"
        C_RED="#ff1744"; C_TEAL="#00d4aa"; C_VIOLET="#ff2d78"; C_YELLOW="#ffea00"
        WARP_L1='                            [0.04, 0.02, 0.08],'
        WARP_L2='                            [1.0, 0.18, 0.47],'
        WARP_L3='                            [0.04, 0.02, 0.08],'
        WARP_L4='                            [0.0, 0.83, 1.0],'
        ;;
    4) # Emerald — green / teal
        PRIMARY="#34d399"; PRIMARY_RGB="52, 211, 153"; HOVER="#6ee7b7"; BACKGROUND="#050f0a"; INFO="#34d399"; THEME_COLOR="#34d399"
        BG_GRADIENT_START="#0a2d1e"; BG_GRADIENT_MID="#050f0a"; BG_GRADIENT_END="#020a05"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#38bdf8"; C_CYAN="#2dd4bf"; C_DARK="#0a1a12"; C_GRAPE="#6ee7b7"; C_GRAY="#6b7280"
        C_GREEN="#34d399"; C_INDIGO="#818cf8"; C_LIME="#a3e635"; C_ORANGE="#fb923c"; C_PINK="#f472b6"
        C_RED="#f87171"; C_TEAL="#14b8a6"; C_VIOLET="#34d399"; C_YELLOW="#facc15"
        WARP_L1='                            [0.02, 0.06, 0.03],'
        WARP_L2='                            [0.1, 0.9, 0.5],'
        WARP_L3='                            [0.02, 0.06, 0.03],'
        WARP_L4='                            [0.3, 1.0, 0.6],'
        ;;
    5) # Amber — warm orange / yellow
        PRIMARY="#f59e0b"; PRIMARY_RGB="245, 158, 11"; HOVER="#fbbf24"; BACKGROUND="#0f0a05"; INFO="#f59e0b"; THEME_COLOR="#f59e0b"
        BG_GRADIENT_START="#2d1a0a"; BG_GRADIENT_MID="#0f0a05"; BG_GRADIENT_END="#0a0502"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#93c5fd"; C_CYAN="#67e8f9"; C_DARK="#1a120a"; C_GRAPE="#fbbf24"; C_GRAY="#78716c"
        C_GREEN="#a3e635"; C_INDIGO="#a5b4fc"; C_LIME="#eab308"; C_ORANGE="#f97316"; C_PINK="#fb7185"
        C_RED="#ef4444"; C_TEAL="#2dd4bf"; C_VIOLET="#f59e0b"; C_YELLOW="#fbbf24"
        WARP_L1='                            [0.08, 0.04, 0.01],'
        WARP_L2='                            [1.0, 0.7, 0.1],'
        WARP_L3='                            [0.08, 0.04, 0.01],'
        WARP_L4='                            [0.1, 0.1, 0.1],'
        ;;
    6) # Ocean — blue / indigo
        PRIMARY="#60a5fa"; PRIMARY_RGB="96, 165, 250"; HOVER="#93bbfc"; BACKGROUND="#05080f"; INFO="#60a5fa"; THEME_COLOR="#60a5fa"
        BG_GRADIENT_START="#0a1e2d"; BG_GRADIENT_MID="#050a15"; BG_GRADIENT_END="#02050a"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#60a5fa"; C_CYAN="#22d3ee"; C_DARK="#0a1628"; C_GRAPE="#818cf8"; C_GRAY="#6b7280"
        C_GREEN="#34d399"; C_INDIGO="#6366f1"; C_LIME="#a3e635"; C_ORANGE="#fb923c"; C_PINK="#f472b6"
        C_RED="#f87171"; C_TEAL="#14b8a6"; C_VIOLET="#60a5fa"; C_YELLOW="#facc15"
        WARP_L1='                            [0.02, 0.04, 0.08],'
        WARP_L2='                            [0.3, 0.6, 1.0],'
        WARP_L3='                            [0.02, 0.04, 0.08],'
        WARP_L4='                            [0.6, 0.85, 1.0],'
        ;;
    7) # Blush — soft light pink on dark rose-tinted base
        PRIMARY="#f9a8d4"; PRIMARY_RGB="249, 168, 212"; HOVER="#fbcfe8"; BACKGROUND="#10080c"; INFO="#f9a8d4"; THEME_COLOR="#f9a8d4"
        BG_GRADIENT_START="#2d1520"; BG_GRADIENT_MID="#12080c"; BG_GRADIENT_END="#080406"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#93c5fd"; C_CYAN="#fda4af"; C_DARK="#1a0f14"; C_GRAPE="#f0abfc"; C_GRAY="#9ca3af"
        C_GREEN="#86efac"; C_INDIGO="#c4b5fd"; C_LIME="#fde68a"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
        C_RED="#fca5a5"; C_TEAL="#fbcfe8"; C_VIOLET="#e879f9"; C_YELLOW="#fde68a"
        WARP_L1='                            [0.06, 0.03, 0.05],'
        WARP_L2='                            [0.98, 0.66, 0.83],'
        WARP_L3='                            [0.06, 0.03, 0.05],'
        WARP_L4='                            [0.85, 0.45, 0.65],'
        ;;
    8) # Open Color — Red
        PRIMARY="#ff6b6b"; PRIMARY_RGB="255, 107, 107"; HOVER="#fa5252"; BACKGROUND="#140808"; INFO="#ff6b6b"; THEME_COLOR="#ff6b6b"
        BG_GRADIENT_START="#5c1010"; BG_GRADIENT_MID="#1a0909"; BG_GRADIENT_END="#0a0505"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#4dabf7"; C_CYAN="#3bc9db"; C_DARK="#343a40"; C_GRAPE="#da77f2"; C_GRAY="#868e96"
        C_GREEN="#51cf66"; C_INDIGO="#5c7cfa"; C_LIME="#94d82d"; C_ORANGE="#ff922b"; C_PINK="#f783ac"
        C_RED="#ff6b6b"; C_TEAL="#38d9a9"; C_VIOLET="#9775fa"; C_YELLOW="#fcc419"
        WARP_L1='                            [0.08, 0.02, 0.02],'
        WARP_L2='                            [1.0, 0.42, 0.42],'
        WARP_L3='                            [0.08, 0.02, 0.02],'
        WARP_L4='                            [0.88, 0.18, 0.18],'
        ;;
    9) # Open Color — Grape
        PRIMARY="#cc5de8"; PRIMARY_RGB="204, 93, 232"; HOVER="#be4bdb"; BACKGROUND="#100818"; INFO="#cc5de8"; THEME_COLOR="#cc5de8"
        BG_GRADIENT_START="#3d1550"; BG_GRADIENT_MID="#12081a"; BG_GRADIENT_END="#08040c"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#4dabf7"; C_CYAN="#3bc9db"; C_DARK="#343a40"; C_GRAPE="#cc5de8"; C_GRAY="#868e96"
        C_GREEN="#51cf66"; C_INDIGO="#748ffc"; C_LIME="#94d82d"; C_ORANGE="#ff922b"; C_PINK="#f06595"
        C_RED="#ff6b6b"; C_TEAL="#38d9a9"; C_VIOLET="#9775fa"; C_YELLOW="#fcc419"
        WARP_L1='                            [0.06, 0.02, 0.08],'
        WARP_L2='                            [0.80, 0.36, 0.92],'
        WARP_L3='                            [0.06, 0.02, 0.08],'
        WARP_L4='                            [0.68, 0.22, 0.78],'
        ;;
    10) # Open Color — Teal
        PRIMARY="#20c997"; PRIMARY_RGB="32, 201, 151"; HOVER="#12b886"; BACKGROUND="#051210"; INFO="#20c997"; THEME_COLOR="#20c997"
        BG_GRADIENT_START="#0a3d32"; BG_GRADIENT_MID="#051210"; BG_GRADIENT_END="#020a08"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#4dabf7"; C_CYAN="#22b8cf"; C_DARK="#343a40"; C_GRAPE="#da77f2"; C_GRAY="#868e96"
        C_GREEN="#40c057"; C_INDIGO="#5c7cfa"; C_LIME="#94d82d"; C_ORANGE="#ff922b"; C_PINK="#f783ac"
        C_RED="#ff6b6b"; C_TEAL="#20c997"; C_VIOLET="#9775fa"; C_YELLOW="#fcc419"
        WARP_L1='                            [0.02, 0.06, 0.05],'
        WARP_L2='                            [0.12, 0.80, 0.58],'
        WARP_L3='                            [0.02, 0.06, 0.05],'
        WARP_L4='                            [0.22, 0.95, 0.72],'
        ;;
    11) # Open Color — Yellow
        PRIMARY="#fcc419"; PRIMARY_RGB="252, 196, 25"; HOVER="#fab005"; BACKGROUND="#121008"; INFO="#fcc419"; THEME_COLOR="#fcc419"
        BG_GRADIENT_START="#3d3010"; BG_GRADIENT_MID="#121008"; BG_GRADIENT_END="#0a0804"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#4dabf7"; C_CYAN="#3bc9db"; C_DARK="#343a40"; C_GRAPE="#da77f2"; C_GRAY="#868e96"
        C_GREEN="#51cf66"; C_INDIGO="#748ffc"; C_LIME="#94d82d"; C_ORANGE="#ff922b"; C_PINK="#f783ac"
        C_RED="#ff6b6b"; C_TEAL="#38d9a9"; C_VIOLET="#9775fa"; C_YELLOW="#fcc419"
        WARP_L1='                            [0.08, 0.06, 0.02],'
        WARP_L2='                            [0.98, 0.77, 0.10],'
        WARP_L3='                            [0.08, 0.06, 0.02],'
        WARP_L4='                            [0.92, 0.62, 0.05],'
        ;;
    *)
        echo "  $MSG_INVALID"
        exit 1
        ;;
esac

if [ "$MODE_CHOICE" = "light" ]; then
    PRIMARY_TEXT="#1e293b"
    case "$theme_choice" in
        1)
            PRIMARY="#c4b5fd"; PRIMARY_RGB="196, 181, 253"; HOVER="#a78bfa"; BACKGROUND="#ede9fe"; INFO="#a78bfa"; THEME_COLOR="#c4b5fd"
            BG_GRADIENT_START="#8b5cf6"; BG_GRADIENT_MID="#ddd6fe"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.28)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#d8b4fe"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#c7d2fe"; C_LIME="#d9f99d"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#c4b5fd"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.94, 0.90, 0.99],'
            WARP_L2='                            [0.62, 0.42, 0.92],'
            WARP_L3='                            [0.97, 0.95, 1.0],'
            WARP_L4='                            [0.52, 0.32, 0.82],'
            ;;
        2)
            PRIMARY="#d4d4d8"; PRIMARY_RGB="212, 212, 216"; HOVER="#a1a1aa"; BACKGROUND="#e4e4e7"; INFO="#a1a1aa"; THEME_COLOR="#d4d4d8"
            BG_GRADIENT_START="#a1a1aa"; BG_GRADIENT_MID="#e4e4e7"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(100, 116, 139, 0.22)"
            C_BLUE="#cbd5e1"; C_CYAN="#cbd5e1"; C_DARK="#e2e8f0"; C_GRAPE="#d4d4d8"; C_GRAY="#94a3b8"
            C_GREEN="#d4d4d8"; C_INDIGO="#cbd5e1"; C_LIME="#e4e4e7"; C_ORANGE="#d4d4d8"; C_PINK="#d4d4d8"
            C_RED="#fca5a5"; C_TEAL="#cbd5e1"; C_VIOLET="#d4d4d8"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.94, 0.94, 0.96],'
            WARP_L2='                            [0.72, 0.72, 0.78],'
            WARP_L3='                            [0.98, 0.98, 1.0],'
            WARP_L4='                            [0.58, 0.58, 0.65],'
            ;;
        3)
            PRIMARY="#f9a8d4"; PRIMARY_RGB="249, 168, 212"; HOVER="#f472b6"; BACKGROUND="#fce7f3"; INFO="#7dd3fc"; THEME_COLOR="#f9a8d4"
            BG_GRADIENT_START="#ec4899"; BG_GRADIENT_MID="#fbcfe8"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#f0abfc"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#c4b5fd"; C_LIME="#d9f99d"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#f9a8d4"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.98, 0.92, 0.96],'
            WARP_L2='                            [0.92, 0.45, 0.72],'
            WARP_L3='                            [0.99, 0.96, 0.98],'
            WARP_L4='                            [0.45, 0.78, 0.95],'
            ;;
        4)
            PRIMARY="#6ee7b7"; PRIMARY_RGB="110, 231, 183"; HOVER="#34d399"; BACKGROUND="#d1fae5"; INFO="#5eead4"; THEME_COLOR="#6ee7b7"
            BG_GRADIENT_START="#10b981"; BG_GRADIENT_MID="#a7f3d0"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#bbf7d0"; C_GRAY="#94a3b8"
            C_GREEN="#6ee7b7"; C_INDIGO="#c7d2fe"; C_LIME="#d9f99d"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#a7f3d0"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.90, 0.98, 0.94],'
            WARP_L2='                            [0.35, 0.82, 0.62],'
            WARP_L3='                            [0.96, 1.0, 0.98],'
            WARP_L4='                            [0.55, 0.92, 0.75],'
            ;;
        5)
            PRIMARY="#fcd34d"; PRIMARY_RGB="252, 211, 77"; HOVER="#fbbf24"; BACKGROUND="#fef3c7"; INFO="#fdba74"; THEME_COLOR="#fcd34d"
            BG_GRADIENT_START="#f59e0b"; BG_GRADIENT_MID="#fde68a"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#fde68a"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#c7d2fe"; C_LIME="#fde68a"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#fcd34d"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.99, 0.97, 0.92],'
            WARP_L2='                            [0.95, 0.72, 0.28],'
            WARP_L3='                            [1.0, 0.99, 0.96],'
            WARP_L4='                            [0.88, 0.65, 0.22],'
            ;;
        6)
            PRIMARY="#93c5fd"; PRIMARY_RGB="147, 197, 253"; HOVER="#60a5fa"; BACKGROUND="#dbeafe"; INFO="#7dd3fc"; THEME_COLOR="#93c5fd"
            BG_GRADIENT_START="#3b82f6"; BG_GRADIENT_MID="#93c5fd"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#c7d2fe"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#a5b4fc"; C_LIME="#d9f99d"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#93c5fd"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.92, 0.96, 1.0],'
            WARP_L2='                            [0.45, 0.68, 0.95],'
            WARP_L3='                            [0.97, 0.99, 1.0],'
            WARP_L4='                            [0.55, 0.78, 0.98],'
            ;;
        7)
            PRIMARY="#fbcfe8"; PRIMARY_RGB="251, 207, 232"; HOVER="#f9a8d4"; BACKGROUND="#fce7f3"; INFO="#f9a8d4"; THEME_COLOR="#fbcfe8"
            BG_GRADIENT_START="#db2777"; BG_GRADIENT_MID="#f9a8d4"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.28)"
            C_BLUE="#93c5fd"; C_CYAN="#fda4af"; C_DARK="#e2e8f0"; C_GRAPE="#f5d0fe"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#ddd6fe"; C_LIME="#fde68a"; C_ORANGE="#fdba74"; C_PINK="#fbcfe8"
            C_RED="#fca5a5"; C_TEAL="#fbcfe8"; C_VIOLET="#f0abfc"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.98, 0.94, 0.97],'
            WARP_L2='                            [0.88, 0.48, 0.72],'
            WARP_L3='                            [0.99, 0.97, 0.99],'
            WARP_L4='                            [0.82, 0.38, 0.62],'
            ;;
        8)
            PRIMARY="#ffa8a8"; PRIMARY_RGB="255, 168, 168"; HOVER="#ff8787"; BACKGROUND="#fff5f5"; INFO="#ff6b6b"; THEME_COLOR="#ff6b6b"
            BG_GRADIENT_START="#fa5252"; BG_GRADIENT_MID="#ffc9c9"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#74c0fc"; C_CYAN="#66d9e8"; C_DARK="#dee2e6"; C_GRAPE="#e599f7"; C_GRAY="#adb5bd"
            C_GREEN="#8ce99a"; C_INDIGO="#91a7ff"; C_LIME="#c0eb75"; C_ORANGE="#ffc078"; C_PINK="#faa2c1"
            C_RED="#ffa8a8"; C_TEAL="#63e6be"; C_VIOLET="#b197fc"; C_YELLOW="#ffe066"
            WARP_L1='                            [1.0, 0.96, 0.96],'
            WARP_L2='                            [0.98, 0.32, 0.32],'
            WARP_L3='                            [1.0, 0.99, 0.99],'
            WARP_L4='                            [0.92, 0.45, 0.45],'
            ;;
        9)
            PRIMARY="#e599f7"; PRIMARY_RGB="229, 153, 247"; HOVER="#da77f2"; BACKGROUND="#f8f0fc"; INFO="#cc5de8"; THEME_COLOR="#cc5de8"
            BG_GRADIENT_START="#be4bdb"; BG_GRADIENT_MID="#eebefa"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#74c0fc"; C_CYAN="#66d9e8"; C_DARK="#dee2e6"; C_GRAPE="#e599f7"; C_GRAY="#adb5bd"
            C_GREEN="#8ce99a"; C_INDIGO="#91a7ff"; C_LIME="#c0eb75"; C_ORANGE="#ffc078"; C_PINK="#faa2c1"
            C_RED="#ffa8a8"; C_TEAL="#63e6be"; C_VIOLET="#b197fc"; C_YELLOW="#ffe066"
            WARP_L1='                            [0.98, 0.94, 1.0],'
            WARP_L2='                            [0.75, 0.35, 0.92],'
            WARP_L3='                            [1.0, 0.98, 1.0],'
            WARP_L4='                            [0.85, 0.55, 0.95],'
            ;;
        10)
            PRIMARY="#63e6be"; PRIMARY_RGB="99, 230, 190"; HOVER="#38d9a9"; BACKGROUND="#e6fcf5"; INFO="#20c997"; THEME_COLOR="#20c997"
            BG_GRADIENT_START="#12b886"; BG_GRADIENT_MID="#96f2d7"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#74c0fc"; C_CYAN="#66d9e8"; C_DARK="#dee2e6"; C_GRAPE="#e599f7"; C_GRAY="#adb5bd"
            C_GREEN="#8ce99a"; C_INDIGO="#91a7ff"; C_LIME="#c0eb75"; C_ORANGE="#ffc078"; C_PINK="#faa2c1"
            C_RED="#ffa8a8"; C_TEAL="#63e6be"; C_VIOLET="#b197fc"; C_YELLOW="#ffe066"
            WARP_L1='                            [0.94, 0.99, 0.97],'
            WARP_L2='                            [0.07, 0.72, 0.53],'
            WARP_L3='                            [0.98, 1.0, 0.99],'
            WARP_L4='                            [0.22, 0.85, 0.68],'
            ;;
        11)
            PRIMARY="#ffe066"; PRIMARY_RGB="255, 224, 102"; HOVER="#ffd43b"; BACKGROUND="#fff9db"; INFO="#fcc419"; THEME_COLOR="#fcc419"
            BG_GRADIENT_START="#fab005"; BG_GRADIENT_MID="#ffec99"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#74c0fc"; C_CYAN="#66d9e8"; C_DARK="#dee2e6"; C_GRAPE="#e599f7"; C_GRAY="#adb5bd"
            C_GREEN="#8ce99a"; C_INDIGO="#91a7ff"; C_LIME="#c0eb75"; C_ORANGE="#ffc078"; C_PINK="#faa2c1"
            C_RED="#ffa8a8"; C_TEAL="#63e6be"; C_VIOLET="#b197fc"; C_YELLOW="#ffe066"
            WARP_L1='                            [1.0, 0.98, 0.92],'
            WARP_L2='                            [0.98, 0.75, 0.08],'
            WARP_L3='                            [1.0, 0.99, 0.96],'
            WARP_L4='                            [0.92, 0.62, 0.12],'
            ;;
    esac
fi

# Snapshot palettes: first case = dark; light block above overwrites PRIMARY → save both
save_palette() {
    local prefix="$1"
    eval "${prefix}PRIMARY=\"\$PRIMARY\""
    eval "${prefix}PRIMARY_RGB=\"\$PRIMARY_RGB\""
    eval "${prefix}HOVER=\"\$HOVER\""
    eval "${prefix}BACKGROUND=\"\$BACKGROUND\""
    eval "${prefix}INFO=\"\$INFO\""
    eval "${prefix}THEME_COLOR=\"\$THEME_COLOR\""
    eval "${prefix}PRIMARY_TEXT=\"\$PRIMARY_TEXT\""
    eval "${prefix}BG_GRADIENT_START=\"\$BG_GRADIENT_START\""
    eval "${prefix}BG_GRADIENT_MID=\"\$BG_GRADIENT_MID\""
    eval "${prefix}BG_GRADIENT_END=\"\$BG_GRADIENT_END\""
    eval "${prefix}BG_GLOW=\"\$BG_GLOW\""
    eval "${prefix}C_BLUE=\"\$C_BLUE\""
    eval "${prefix}C_CYAN=\"\$C_CYAN\""
    eval "${prefix}C_DARK=\"\$C_DARK\""
    eval "${prefix}C_GRAPE=\"\$C_GRAPE\""
    eval "${prefix}C_GRAY=\"\$C_GRAY\""
    eval "${prefix}C_GREEN=\"\$C_GREEN\""
    eval "${prefix}C_INDIGO=\"\$C_INDIGO\""
    eval "${prefix}C_LIME=\"\$C_LIME\""
    eval "${prefix}C_ORANGE=\"\$C_ORANGE\""
    eval "${prefix}C_PINK=\"\$C_PINK\""
    eval "${prefix}C_RED=\"\$C_RED\""
    eval "${prefix}C_TEAL=\"\$C_TEAL\""
    eval "${prefix}C_VIOLET=\"\$C_VIOLET\""
    eval "${prefix}C_YELLOW=\"\$C_YELLOW\""
    eval "${prefix}WARP_L1=\"\$WARP_L1\""
    eval "${prefix}WARP_L2=\"\$WARP_L2\""
    eval "${prefix}WARP_L3=\"\$WARP_L3\""
    eval "${prefix}WARP_L4=\"\$WARP_L4\""
}

# Re-apply dark palette from first case (re-run theme case for dark only)
PRIMARY_TEXT="#0a0a0a"
case "$theme_choice" in
    1) PRIMARY="#c084fc"; PRIMARY_RGB="192, 132, 252"; HOVER="#a78bfa"; BACKGROUND="#0a0812"; INFO="#c084fc"; THEME_COLOR="#c084fc"
        BG_GRADIENT_START="#1e1b4b"; BG_GRADIENT_MID="#0f0a1a"; BG_GRADIENT_END="#020617"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#93c5fd"; C_CYAN="#67e8f9"; C_DARK="#1e293b"; C_GRAPE="#c084fc"; C_GRAY="#6b7280"
        C_GREEN="#6ee7b7"; C_INDIGO="#a5b4fc"; C_LIME="#bef264"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
        C_RED="#fca5a5"; C_TEAL="#5eead4"; C_VIOLET="#c084fc"; C_YELLOW="#fde68a"
        WARP_L1='                            [0.07, 0.07, 0.07],'; WARP_L2='                            [0.58, 0.44, 1.0],'
        WARP_L3='                            [0.07, 0.07, 0.07],'; WARP_L4='                            [0.53, 0.22, 1.0],' ;;
    2) PRIMARY="#e0e0e0"; PRIMARY_RGB="224, 224, 224"; HOVER="#c0c0c0"; BACKGROUND="#0a0a0a"; INFO="#9ca3af"; THEME_COLOR="#666666"
        BG_GRADIENT_START="#1a1a1a"; BG_GRADIENT_MID="#0f0f0f"; BG_GRADIENT_END="#050505"; BG_GLOW="rgba(var(--primary-rgb), 0.03)"
        C_BLUE="#a0a0a0"; C_CYAN="#b0b0b0"; C_DARK="#1a1a1a"; C_GRAPE="#c0c0c0"; C_GRAY="#707070"
        C_GREEN="#a0a0a0"; C_INDIGO="#909090"; C_LIME="#b0b0b0"; C_ORANGE="#c0c0c0"; C_PINK="#b0b0b0"
        C_RED="#d0a0a0"; C_TEAL="#a0b0b0"; C_VIOLET="#c0c0c0"; C_YELLOW="#c0b0a0"
        WARP_L1='                            [0.02, 0.02, 0.02],'; WARP_L2='                            [0.5, 0.5, 0.5],'
        WARP_L3='                            [0.02, 0.02, 0.02],'; WARP_L4='                            [0.8, 0.8, 0.8],' ;;
    3) PRIMARY="#ff2d78"; PRIMARY_RGB="255, 45, 120"; HOVER="#ff6b9d"; BACKGROUND="#0a0515"; INFO="#00d4ff"; THEME_COLOR="#ff2d78"
        BG_GRADIENT_START="#2d0a1e"; BG_GRADIENT_MID="#0f0515"; BG_GRADIENT_END="#050210"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#00d4ff"; C_CYAN="#00ffcc"; C_DARK="#12082a"; C_GRAPE="#ff6b9d"; C_GRAY="#6b7280"
        C_GREEN="#00ff88"; C_INDIGO="#7c3aed"; C_LIME="#c6ff00"; C_ORANGE="#ff6600"; C_PINK="#ff2d78"
        C_RED="#ff1744"; C_TEAL="#00d4aa"; C_VIOLET="#ff2d78"; C_YELLOW="#ffea00"
        WARP_L1='                            [0.04, 0.02, 0.08],'; WARP_L2='                            [1.0, 0.18, 0.47],'
        WARP_L3='                            [0.04, 0.02, 0.08],'; WARP_L4='                            [0.0, 0.83, 1.0],' ;;
    4) PRIMARY="#34d399"; PRIMARY_RGB="52, 211, 153"; HOVER="#6ee7b7"; BACKGROUND="#050f0a"; INFO="#34d399"; THEME_COLOR="#34d399"
        BG_GRADIENT_START="#0a2d1e"; BG_GRADIENT_MID="#050f0a"; BG_GRADIENT_END="#020a05"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#38bdf8"; C_CYAN="#2dd4bf"; C_DARK="#0a1a12"; C_GRAPE="#6ee7b7"; C_GRAY="#6b7280"
        C_GREEN="#34d399"; C_INDIGO="#818cf8"; C_LIME="#a3e635"; C_ORANGE="#fb923c"; C_PINK="#f472b6"
        C_RED="#f87171"; C_TEAL="#14b8a6"; C_VIOLET="#34d399"; C_YELLOW="#facc15"
        WARP_L1='                            [0.02, 0.06, 0.03],'; WARP_L2='                            [0.1, 0.9, 0.5],'
        WARP_L3='                            [0.02, 0.06, 0.03],'; WARP_L4='                            [0.3, 1.0, 0.6],' ;;
    5) PRIMARY="#f59e0b"; PRIMARY_RGB="245, 158, 11"; HOVER="#fbbf24"; BACKGROUND="#0f0a05"; INFO="#f59e0b"; THEME_COLOR="#f59e0b"
        BG_GRADIENT_START="#2d1a0a"; BG_GRADIENT_MID="#0f0a05"; BG_GRADIENT_END="#0a0502"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#93c5fd"; C_CYAN="#67e8f9"; C_DARK="#1a120a"; C_GRAPE="#fbbf24"; C_GRAY="#78716c"
        C_GREEN="#a3e635"; C_INDIGO="#a5b4fc"; C_LIME="#eab308"; C_ORANGE="#f97316"; C_PINK="#fb7185"
        C_RED="#ef4444"; C_TEAL="#2dd4bf"; C_VIOLET="#f59e0b"; C_YELLOW="#fbbf24"
        WARP_L1='                            [0.08, 0.04, 0.01],'; WARP_L2='                            [1.0, 0.7, 0.1],'
        WARP_L3='                            [0.08, 0.04, 0.01],'; WARP_L4='                            [0.1, 0.1, 0.1],' ;;
    6) PRIMARY="#60a5fa"; PRIMARY_RGB="96, 165, 250"; HOVER="#93bbfc"; BACKGROUND="#05080f"; INFO="#60a5fa"; THEME_COLOR="#60a5fa"
        BG_GRADIENT_START="#0a1e2d"; BG_GRADIENT_MID="#050a15"; BG_GRADIENT_END="#02050a"; BG_GLOW="rgba(var(--primary-rgb), 0.06)"
        C_BLUE="#60a5fa"; C_CYAN="#22d3ee"; C_DARK="#0a1628"; C_GRAPE="#818cf8"; C_GRAY="#6b7280"
        C_GREEN="#34d399"; C_INDIGO="#6366f1"; C_LIME="#a3e635"; C_ORANGE="#fb923c"; C_PINK="#f472b6"
        C_RED="#f87171"; C_TEAL="#14b8a6"; C_VIOLET="#60a5fa"; C_YELLOW="#facc15"
        WARP_L1='                            [0.02, 0.04, 0.08],'; WARP_L2='                            [0.3, 0.6, 1.0],'
        WARP_L3='                            [0.02, 0.04, 0.08],'; WARP_L4='                            [0.6, 0.85, 1.0],' ;;
    7) PRIMARY="#f9a8d4"; PRIMARY_RGB="249, 168, 212"; HOVER="#fbcfe8"; BACKGROUND="#10080c"; INFO="#f9a8d4"; THEME_COLOR="#f9a8d4"
        BG_GRADIENT_START="#2d1520"; BG_GRADIENT_MID="#12080c"; BG_GRADIENT_END="#080406"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#93c5fd"; C_CYAN="#fda4af"; C_DARK="#1a0f14"; C_GRAPE="#f0abfc"; C_GRAY="#9ca3af"
        C_GREEN="#86efac"; C_INDIGO="#c4b5fd"; C_LIME="#fde68a"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
        C_RED="#fca5a5"; C_TEAL="#fbcfe8"; C_VIOLET="#e879f9"; C_YELLOW="#fde68a"
        WARP_L1='                            [0.06, 0.03, 0.05],'; WARP_L2='                            [0.98, 0.66, 0.83],'
        WARP_L3='                            [0.06, 0.03, 0.05],'; WARP_L4='                            [0.85, 0.45, 0.65],' ;;
    8) PRIMARY="#ff6b6b"; PRIMARY_RGB="255, 107, 107"; HOVER="#fa5252"; BACKGROUND="#140808"; INFO="#ff6b6b"; THEME_COLOR="#ff6b6b"
        BG_GRADIENT_START="#5c1010"; BG_GRADIENT_MID="#1a0909"; BG_GRADIENT_END="#0a0505"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#4dabf7"; C_CYAN="#3bc9db"; C_DARK="#343a40"; C_GRAPE="#da77f2"; C_GRAY="#868e96"
        C_GREEN="#51cf66"; C_INDIGO="#5c7cfa"; C_LIME="#94d82d"; C_ORANGE="#ff922b"; C_PINK="#f783ac"
        C_RED="#ff6b6b"; C_TEAL="#38d9a9"; C_VIOLET="#9775fa"; C_YELLOW="#fcc419"
        WARP_L1='                            [0.08, 0.02, 0.02],'; WARP_L2='                            [1.0, 0.42, 0.42],'
        WARP_L3='                            [0.08, 0.02, 0.02],'; WARP_L4='                            [0.88, 0.18, 0.18],' ;;
    9) PRIMARY="#cc5de8"; PRIMARY_RGB="204, 93, 232"; HOVER="#be4bdb"; BACKGROUND="#100818"; INFO="#cc5de8"; THEME_COLOR="#cc5de8"
        BG_GRADIENT_START="#3d1550"; BG_GRADIENT_MID="#12081a"; BG_GRADIENT_END="#08040c"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#4dabf7"; C_CYAN="#3bc9db"; C_DARK="#343a40"; C_GRAPE="#cc5de8"; C_GRAY="#868e96"
        C_GREEN="#51cf66"; C_INDIGO="#748ffc"; C_LIME="#94d82d"; C_ORANGE="#ff922b"; C_PINK="#f06595"
        C_RED="#ff6b6b"; C_TEAL="#38d9a9"; C_VIOLET="#9775fa"; C_YELLOW="#fcc419"
        WARP_L1='                            [0.06, 0.02, 0.08],'; WARP_L2='                            [0.80, 0.36, 0.92],'
        WARP_L3='                            [0.06, 0.02, 0.08],'; WARP_L4='                            [0.68, 0.22, 0.78],' ;;
    10) PRIMARY="#20c997"; PRIMARY_RGB="32, 201, 151"; HOVER="#12b886"; BACKGROUND="#051210"; INFO="#20c997"; THEME_COLOR="#20c997"
        BG_GRADIENT_START="#0a3d32"; BG_GRADIENT_MID="#051210"; BG_GRADIENT_END="#020a08"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#4dabf7"; C_CYAN="#22b8cf"; C_DARK="#343a40"; C_GRAPE="#da77f2"; C_GRAY="#868e96"
        C_GREEN="#40c057"; C_INDIGO="#5c7cfa"; C_LIME="#94d82d"; C_ORANGE="#ff922b"; C_PINK="#f783ac"
        C_RED="#ff6b6b"; C_TEAL="#20c997"; C_VIOLET="#9775fa"; C_YELLOW="#fcc419"
        WARP_L1='                            [0.02, 0.06, 0.05],'; WARP_L2='                            [0.12, 0.80, 0.58],'
        WARP_L3='                            [0.02, 0.06, 0.05],'; WARP_L4='                            [0.22, 0.95, 0.72],' ;;
    11) PRIMARY="#fcc419"; PRIMARY_RGB="252, 196, 25"; HOVER="#fab005"; BACKGROUND="#121008"; INFO="#fcc419"; THEME_COLOR="#fcc419"
        BG_GRADIENT_START="#3d3010"; BG_GRADIENT_MID="#121008"; BG_GRADIENT_END="#0a0804"; BG_GLOW="rgba(var(--primary-rgb), 0.08)"
        C_BLUE="#4dabf7"; C_CYAN="#3bc9db"; C_DARK="#343a40"; C_GRAPE="#da77f2"; C_GRAY="#868e96"
        C_GREEN="#51cf66"; C_INDIGO="#748ffc"; C_LIME="#94d82d"; C_ORANGE="#ff922b"; C_PINK="#f783ac"
        C_RED="#ff6b6b"; C_TEAL="#38d9a9"; C_VIOLET="#9775fa"; C_YELLOW="#fcc419"
        WARP_L1='                            [0.08, 0.06, 0.02],'; WARP_L2='                            [0.98, 0.77, 0.10],'
        WARP_L3='                            [0.08, 0.06, 0.02],'; WARP_L4='                            [0.92, 0.62, 0.05],' ;;
esac
save_palette "D_"

# Light palette: reuse result if MODE was light, else run light case
if [ "$MODE_CHOICE" != "light" ]; then
    PRIMARY_TEXT="#1e293b"
    case "$theme_choice" in
        1) PRIMARY="#c4b5fd"; PRIMARY_RGB="196, 181, 253"; HOVER="#a78bfa"; BACKGROUND="#ede9fe"; INFO="#a78bfa"; THEME_COLOR="#c4b5fd"
            BG_GRADIENT_START="#8b5cf6"; BG_GRADIENT_MID="#ddd6fe"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.28)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#d8b4fe"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#c7d2fe"; C_LIME="#d9f99d"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#c4b5fd"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.94, 0.90, 0.99],'; WARP_L2='                            [0.62, 0.42, 0.92],'
            WARP_L3='                            [0.97, 0.95, 1.0],'; WARP_L4='                            [0.52, 0.32, 0.82],' ;;
        2) PRIMARY="#d4d4d8"; PRIMARY_RGB="212, 212, 216"; HOVER="#a1a1aa"; BACKGROUND="#e4e4e7"; INFO="#a1a1aa"; THEME_COLOR="#d4d4d8"
            BG_GRADIENT_START="#a1a1aa"; BG_GRADIENT_MID="#e4e4e7"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(100, 116, 139, 0.22)"
            C_BLUE="#cbd5e1"; C_CYAN="#cbd5e1"; C_DARK="#e2e8f0"; C_GRAPE="#d4d4d8"; C_GRAY="#94a3b8"
            C_GREEN="#d4d4d8"; C_INDIGO="#cbd5e1"; C_LIME="#e4e4e7"; C_ORANGE="#d4d4d8"; C_PINK="#d4d4d8"
            C_RED="#fca5a5"; C_TEAL="#cbd5e1"; C_VIOLET="#d4d4d8"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.94, 0.94, 0.96],'; WARP_L2='                            [0.72, 0.72, 0.78],'
            WARP_L3='                            [0.98, 0.98, 1.0],'; WARP_L4='                            [0.58, 0.58, 0.65],' ;;
        3) PRIMARY="#f9a8d4"; PRIMARY_RGB="249, 168, 212"; HOVER="#f472b6"; BACKGROUND="#fce7f3"; INFO="#7dd3fc"; THEME_COLOR="#f9a8d4"
            BG_GRADIENT_START="#ec4899"; BG_GRADIENT_MID="#fbcfe8"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#f0abfc"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#c4b5fd"; C_LIME="#d9f99d"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#f9a8d4"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.98, 0.92, 0.96],'; WARP_L2='                            [0.92, 0.45, 0.72],'
            WARP_L3='                            [0.99, 0.96, 0.98],'; WARP_L4='                            [0.45, 0.78, 0.95],' ;;
        4) PRIMARY="#6ee7b7"; PRIMARY_RGB="110, 231, 183"; HOVER="#34d399"; BACKGROUND="#d1fae5"; INFO="#5eead4"; THEME_COLOR="#6ee7b7"
            BG_GRADIENT_START="#10b981"; BG_GRADIENT_MID="#a7f3d0"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#bbf7d0"; C_GRAY="#94a3b8"
            C_GREEN="#6ee7b7"; C_INDIGO="#c7d2fe"; C_LIME="#d9f99d"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#a7f3d0"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.90, 0.98, 0.94],'; WARP_L2='                            [0.35, 0.82, 0.62],'
            WARP_L3='                            [0.96, 1.0, 0.98],'; WARP_L4='                            [0.55, 0.92, 0.75],' ;;
        5) PRIMARY="#fcd34d"; PRIMARY_RGB="252, 211, 77"; HOVER="#fbbf24"; BACKGROUND="#fef3c7"; INFO="#fdba74"; THEME_COLOR="#fcd34d"
            BG_GRADIENT_START="#f59e0b"; BG_GRADIENT_MID="#fde68a"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#fde68a"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#c7d2fe"; C_LIME="#fde68a"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#fcd34d"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.99, 0.97, 0.92],'; WARP_L2='                            [0.95, 0.72, 0.28],'
            WARP_L3='                            [1.0, 0.99, 0.96],'; WARP_L4='                            [0.88, 0.65, 0.22],' ;;
        6) PRIMARY="#93c5fd"; PRIMARY_RGB="147, 197, 253"; HOVER="#60a5fa"; BACKGROUND="#dbeafe"; INFO="#7dd3fc"; THEME_COLOR="#93c5fd"
            BG_GRADIENT_START="#3b82f6"; BG_GRADIENT_MID="#93c5fd"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#93c5fd"; C_CYAN="#a5f3fc"; C_DARK="#e2e8f0"; C_GRAPE="#c7d2fe"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#a5b4fc"; C_LIME="#d9f99d"; C_ORANGE="#fdba74"; C_PINK="#f9a8d4"
            C_RED="#fca5a5"; C_TEAL="#99f6e4"; C_VIOLET="#93c5fd"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.92, 0.96, 1.0],'; WARP_L2='                            [0.45, 0.68, 0.95],'
            WARP_L3='                            [0.97, 0.99, 1.0],'; WARP_L4='                            [0.55, 0.78, 0.98],' ;;
        7) PRIMARY="#fbcfe8"; PRIMARY_RGB="251, 207, 232"; HOVER="#f9a8d4"; BACKGROUND="#fce7f3"; INFO="#f9a8d4"; THEME_COLOR="#fbcfe8"
            BG_GRADIENT_START="#db2777"; BG_GRADIENT_MID="#f9a8d4"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.28)"
            C_BLUE="#93c5fd"; C_CYAN="#fda4af"; C_DARK="#e2e8f0"; C_GRAPE="#f5d0fe"; C_GRAY="#94a3b8"
            C_GREEN="#86efac"; C_INDIGO="#ddd6fe"; C_LIME="#fde68a"; C_ORANGE="#fdba74"; C_PINK="#fbcfe8"
            C_RED="#fca5a5"; C_TEAL="#fbcfe8"; C_VIOLET="#f0abfc"; C_YELLOW="#fde68a"
            WARP_L1='                            [0.98, 0.94, 0.97],'; WARP_L2='                            [0.88, 0.48, 0.72],'
            WARP_L3='                            [0.99, 0.97, 0.99],'; WARP_L4='                            [0.82, 0.38, 0.62],' ;;
        8) PRIMARY="#ffa8a8"; PRIMARY_RGB="255, 168, 168"; HOVER="#ff8787"; BACKGROUND="#fff5f5"; INFO="#ff6b6b"; THEME_COLOR="#ff6b6b"
            BG_GRADIENT_START="#fa5252"; BG_GRADIENT_MID="#ffc9c9"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#74c0fc"; C_CYAN="#66d9e8"; C_DARK="#dee2e6"; C_GRAPE="#e599f7"; C_GRAY="#adb5bd"
            C_GREEN="#8ce99a"; C_INDIGO="#91a7ff"; C_LIME="#c0eb75"; C_ORANGE="#ffc078"; C_PINK="#faa2c1"
            C_RED="#ffa8a8"; C_TEAL="#63e6be"; C_VIOLET="#b197fc"; C_YELLOW="#ffe066"
            WARP_L1='                            [1.0, 0.96, 0.96],'; WARP_L2='                            [0.98, 0.32, 0.32],'
            WARP_L3='                            [1.0, 0.99, 0.99],'; WARP_L4='                            [0.92, 0.45, 0.45],' ;;
        9) PRIMARY="#e599f7"; PRIMARY_RGB="229, 153, 247"; HOVER="#da77f2"; BACKGROUND="#f8f0fc"; INFO="#cc5de8"; THEME_COLOR="#cc5de8"
            BG_GRADIENT_START="#be4bdb"; BG_GRADIENT_MID="#eebefa"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#74c0fc"; C_CYAN="#66d9e8"; C_DARK="#dee2e6"; C_GRAPE="#e599f7"; C_GRAY="#adb5bd"
            C_GREEN="#8ce99a"; C_INDIGO="#91a7ff"; C_LIME="#c0eb75"; C_ORANGE="#ffc078"; C_PINK="#faa2c1"
            C_RED="#ffa8a8"; C_TEAL="#63e6be"; C_VIOLET="#b197fc"; C_YELLOW="#ffe066"
            WARP_L1='                            [0.98, 0.94, 1.0],'; WARP_L2='                            [0.75, 0.35, 0.92],'
            WARP_L3='                            [1.0, 0.98, 1.0],'; WARP_L4='                            [0.85, 0.55, 0.95],' ;;
        10) PRIMARY="#63e6be"; PRIMARY_RGB="99, 230, 190"; HOVER="#38d9a9"; BACKGROUND="#e6fcf5"; INFO="#20c997"; THEME_COLOR="#20c997"
            BG_GRADIENT_START="#12b886"; BG_GRADIENT_MID="#96f2d7"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#74c0fc"; C_CYAN="#66d9e8"; C_DARK="#dee2e6"; C_GRAPE="#e599f7"; C_GRAY="#adb5bd"
            C_GREEN="#8ce99a"; C_INDIGO="#91a7ff"; C_LIME="#c0eb75"; C_ORANGE="#ffc078"; C_PINK="#faa2c1"
            C_RED="#ffa8a8"; C_TEAL="#63e6be"; C_VIOLET="#b197fc"; C_YELLOW="#ffe066"
            WARP_L1='                            [0.94, 0.99, 0.97],'; WARP_L2='                            [0.07, 0.72, 0.53],'
            WARP_L3='                            [0.98, 1.0, 0.99],'; WARP_L4='                            [0.22, 0.85, 0.68],' ;;
        11) PRIMARY="#ffe066"; PRIMARY_RGB="255, 224, 102"; HOVER="#ffd43b"; BACKGROUND="#fff9db"; INFO="#fcc419"; THEME_COLOR="#fcc419"
            BG_GRADIENT_START="#fab005"; BG_GRADIENT_MID="#ffec99"; BG_GRADIENT_END="#ffffff"; BG_GLOW="rgba(var(--primary-rgb), 0.26)"
            C_BLUE="#74c0fc"; C_CYAN="#66d9e8"; C_DARK="#dee2e6"; C_GRAPE="#e599f7"; C_GRAY="#adb5bd"
            C_GREEN="#8ce99a"; C_INDIGO="#91a7ff"; C_LIME="#c0eb75"; C_ORANGE="#ffc078"; C_PINK="#faa2c1"
            C_RED="#ffa8a8"; C_TEAL="#63e6be"; C_VIOLET="#b197fc"; C_YELLOW="#ffe066"
            WARP_L1='                            [1.0, 0.98, 0.92],'; WARP_L2='                            [0.98, 0.75, 0.08],'
            WARP_L3='                            [1.0, 0.99, 0.96],'; WARP_L4='                            [0.92, 0.62, 0.12],' ;;
    esac
fi
save_palette "L_"

# ── Download or use local ─────────────────────────────────────────────────
echo ""
if [ -f index.html ]; then
    echo "  index.html найден, применяю тему к локальному файлу..."
else
    echo "  $MSG_DOWNLOAD"
    curl -L -s -o index.html "$REPO_URL/index.html"
fi

build_color_mode_css() {
    local mode_class="$1"
    local pre="$2"
    eval "local P_PRIMARY=\$${pre}PRIMARY"
    eval "local P_HOVER=\$${pre}HOVER"
    eval "local P_TEXT=\$${pre}PRIMARY_TEXT"
    eval "local P_BG=\$${pre}BACKGROUND"
    eval "local P_INFO=\$${pre}INFO"
    eval "local P_RGB=\$${pre}PRIMARY_RGB"
    eval "local P_GS=\$${pre}BG_GRADIENT_START"
    eval "local P_GM=\$${pre}BG_GRADIENT_MID"
    eval "local P_GE=\$${pre}BG_GRADIENT_END"
    eval "local P_GLOW=\$${pre}BG_GLOW"
    eval "local P_CB=\$${pre}C_BLUE"
    eval "local P_CC=\$${pre}C_CYAN"
    eval "local P_CD=\$${pre}C_DARK"
    eval "local P_CG=\$${pre}C_GRAPE"
    eval "local P_CGR=\$${pre}C_GRAY"
    eval "local P_CGN=\$${pre}C_GREEN"
    eval "local P_CI=\$${pre}C_INDIGO"
    eval "local P_CL=\$${pre}C_LIME"
    eval "local P_CO=\$${pre}C_ORANGE"
    eval "local P_CPK=\$${pre}C_PINK"
    eval "local P_CR=\$${pre}C_RED"
    eval "local P_CT=\$${pre}C_TEAL"
    eval "local P_CV=\$${pre}C_VIOLET"
    eval "local P_CY=\$${pre}C_YELLOW"
    if [ "$mode_class" = "color-mode-dark" ]; then
        cat <<CSSBLOCK
.${mode_class} {
    --primary-color: ${P_PRIMARY};
    --primary-hover: ${P_HOVER};
    --primary-text: ${P_TEXT};
    --background: ${P_BG};
    --info: ${P_INFO};
    --primary-rgb: ${P_RGB};
    --bg-gradient-start: ${P_GS};
    --bg-gradient-mid: ${P_GM};
    --bg-gradient-end: ${P_GE};
    --bg-glow: ${P_GLOW};
    --surface: rgba(255, 255, 255, 0.02);
    --border: rgba(255, 255, 255, 0.05);
    --text-primary: #e2e8f0;
    --text-secondary: #9ca3af;
    --text-muted: #6b7280;
    --card-bg: rgba(24, 24, 27, 0.50);
    --panel-bg: rgba(24, 24, 27, 0.70);
    --elevated-bg: rgba(39, 39, 42, 0.50);
    --elevated-bg-hover: rgba(39, 39, 42, 0.80);
    --color-blue: ${P_CB};
    --color-cyan: ${P_CC};
    --color-dark: ${P_CD};
    --color-grape: ${P_CG};
    --color-gray: ${P_CGR};
    --color-green: ${P_CGN};
    --color-indigo: ${P_CI};
    --color-lime: ${P_CL};
    --color-orange: ${P_CO};
    --color-pink: ${P_CPK};
    --color-red: ${P_CR};
    --color-teal: ${P_CT};
    --color-violet: ${P_CV};
    --color-yellow: ${P_CY};
}
CSSBLOCK
    else
        cat <<CSSBLOCK
.${mode_class} {
    --primary-color: ${P_PRIMARY};
    --primary-hover: ${P_HOVER};
    --primary-text: ${P_TEXT};
    --background: ${P_BG};
    --info: ${P_INFO};
    --primary-rgb: ${P_RGB};
    --bg-gradient-start: ${P_GS};
    --bg-gradient-mid: ${P_GM};
    --bg-gradient-end: ${P_GE};
    --bg-glow: ${P_GLOW};
    --surface: rgba(255, 255, 255, 0.88);
    --border: rgba(15, 23, 42, 0.14);
    --border-strong: rgba(15, 23, 42, 0.20);
    --divider: rgba(15, 23, 42, 0.12);
    --border-hover: rgba(15, 23, 42, 0.22);
    --surface-hover: rgba(var(--primary-rgb), 0.08);
    --text-primary: #0f172a;
    --text-secondary: #475569;
    --text-muted: #64748b;
    --card-bg: #ffffff;
    --panel-bg: #ffffff;
    --elevated-bg: #f8fafc;
    --elevated-bg-hover: #ffffff;
    --shadow: 0 4px 24px rgba(15, 23, 42, 0.10);
    --shadow-lg: 0 12px 40px rgba(15, 23, 42, 0.14);
    --color-blue: ${P_CB};
    --color-cyan: ${P_CC};
    --color-dark: ${P_CD};
    --color-grape: ${P_CG};
    --color-gray: ${P_CGR};
    --color-green: ${P_CGN};
    --color-indigo: ${P_CI};
    --color-lime: ${P_CL};
    --color-orange: ${P_CO};
    --color-pink: ${P_CPK};
    --color-red: ${P_CR};
    --color-teal: ${P_CT};
    --color-violet: ${P_CV};
    --color-yellow: ${P_CY};
}
CSSBLOCK
    fi
}

patch_between_markers() {
    local start_marker="$1"
    local end_marker="$2"
    local block_file="$3"
    python3 - "$start_marker" "$end_marker" "$block_file" index.html <<'PY'
import re, sys
start, end, block_path, path = sys.argv[1:5]
block = open(block_path, encoding='utf-8').read().strip()
html = open(path, encoding='utf-8').read()
pattern = re.compile(re.escape(f'/* {start} */') + r'.*?' + re.escape(f'/* {end} */'), re.DOTALL)
repl = f'/* {start} */\n' + block + f'\n/* {end} */'
new_html, n = pattern.subn(repl, html, count=1)
if n != 1:
    sys.exit(f'Marker block not found: {start}')
open(path, 'w', encoding='utf-8').write(new_html)
PY
}

warp_line_to_json() {
    echo "$1" | sed 's/^[[:space:]]*//;s/,$//'
}

build_warp_json() {
    local pre="$1"
    eval "local L1=\$${pre}WARP_L1"
    eval "local L2=\$${pre}WARP_L2"
    eval "local L3=\$${pre}WARP_L3"
    eval "local L4=\$${pre}WARP_L4"
    local j1 j2 j3 j4
    j1=$(warp_line_to_json "$L1")
    j2=$(warp_line_to_json "$L2")
    j3=$(warp_line_to_json "$L3")
    j4=$(warp_line_to_json "$L4")
    echo "[$j1,$j2,$j3,$j4]"
}

TMP_D=$(mktemp)
TMP_L=$(mktemp)
build_color_mode_css "color-mode-dark" "D_" > "$TMP_D"
build_color_mode_css "color-mode-light" "L_" > "$TMP_L"
patch_between_markers "@color-mode-dark" "@color-mode-dark-end" "$TMP_D"
patch_between_markers "@color-mode-light" "@color-mode-light-end" "$TMP_L"
rm -f "$TMP_D" "$TMP_L"

sed -i "s|content=\"#[0-9a-fA-F]*\" id=\"themeColor\" data-theme-light=\"#[0-9a-fA-F]*\" data-theme-dark=\"#[0-9a-fA-F]*\"|content=\"$L_THEME_COLOR\" id=\"themeColor\" data-theme-light=\"$L_THEME_COLOR\" data-theme-dark=\"$D_THEME_COLOR\"|" index.html
sed -i "s|id=\"warpColorsLight\">\\[.*\\]</script>|id=\"warpColorsLight\">$(build_warp_json L_)</script>|" index.html
sed -i "s|id=\"warpColorsDark\">\\[.*\\]</script>|id=\"warpColorsDark\">$(build_warp_json D_)</script>|" index.html

echo "  $MSG_OK"

# ── Docker compose: add volume & restart ────────────────────────────
# wrap in || true to prevent set -e from silently exiting
(
if [ -f docker-compose.yml ]; then DC="docker-compose.yml"
elif [ -f compose.yml ]; then DC="compose.yml"
else DC=""; fi

if [ -n "$DC" ]; then
    if ! grep -q 'index.html:/opt/app/frontend/index.html' "$DC" 2>/dev/null; then
        # Находим первый сервис и его отступ (ищем ключи с отступом >= 2)
        FIRST_SERVICE=$(grep -n '^[[:space:]]\{2,\}[a-zA-Z0-9_-]\+:' "$DC" 2>/dev/null | head -1)
        SERVICE_LINE=$(echo "$FIRST_SERVICE" | cut -d: -f1)
        SERVICE_INDENT=$(echo "$FIRST_SERVICE" | grep -oP '^[[:space:]]*(?=[a-zA-Z0-9_-]+:)' | wc -c)
        SERVICE_INDENT=$((SERVICE_INDENT - 1))
        [ "$SERVICE_INDENT" -lt 0 ] && SERVICE_INDENT=0

        # Находим отступ свойств внутри сервиса (первая строка вида "        image:" после сервиса)
        PROP_INDENT=0
        if [ -n "$SERVICE_LINE" ]; then
            # Берём первую строку со свойством (image:, container_name:, etc) и извлекаем её отступ
            PROP_LINE=$(sed -n "$((SERVICE_LINE+1)),\$p" "$DC" | grep -m1 '^[[:space:]]\{'"$((SERVICE_INDENT+2))"',\}[a-z_-]\+:')
            if [ -n "$PROP_LINE" ]; then
                PROP_INDENT=$(echo "$PROP_LINE" | sed 's/^\([[:space:]]*\).*/\1/' | wc -c)
                PROP_INDENT=$((PROP_INDENT - 1))
            fi
        fi
        [ "$PROP_INDENT" -lt 2 ] && PROP_INDENT=$((SERVICE_INDENT + 4))

        VOL_INDENT=$(printf '%*s' "$PROP_INDENT" '')
        VOL_ITEM_INDENT=$(printf '%*s' $((PROP_INDENT + 2)) '')

        if [ -n "$SERVICE_LINE" ]; then
            NEXT_SERVICE=$(grep -n '^[[:space:]]\{2,\}[a-zA-Z0-9_-]\+:' "$DC" 2>/dev/null | sed -n "2p" | cut -d: -f1)
            [ -z "$NEXT_SERVICE" ] && NEXT_SERVICE=$(wc -l < "$DC")

            # Ищем volumes между SERVICE_LINE и NEXT_SERVICE
            VOLUMES_LINE=$(sed -n "${SERVICE_LINE},${NEXT_SERVICE}p" "$DC" | grep -n "^${VOL_INDENT}volumes:" | head -1 | cut -d: -f1)

            if [ -n "$VOLUMES_LINE" ]; then
                # volumes уже есть — добавляем в конец блока
                ACTUAL_VOLUMES_LINE=$((SERVICE_LINE + VOLUMES_LINE - 1))

                # Ищем следующую строку с таким же отступом как volumes
                LAST_VOLUME_LINE=$(awk -v start="$ACTUAL_VOLUMES_LINE" -v indent="$VOL_INDENT" 'NR > start && $0 ~ "^" indent "[a-z_-]+:" {print NR; exit}' "$DC")
                [ -z "$LAST_VOLUME_LINE" ] && LAST_VOLUME_LINE=$(awk -v start="$ACTUAL_VOLUMES_LINE" -v indent="$VOL_INDENT" 'NR > start && length($0) > 0 && !/^[[:space:]]/ {print NR-1; exit}' "$DC")
                [ -z "$LAST_VOLUME_LINE" ] && LAST_VOLUME_LINE=$(wc -l < "$DC")

                awk -v line="$LAST_VOLUME_LINE" -v vol="$VOL_ITEM_INDENT- ./index.html:/opt/app/frontend/index.html" 'NR==line {print; print vol; next} 1' "$DC" > "${DC}.tmp" && mv "${DC}.tmp" "$DC"
                echo "  → Volume mount добавлен в существующий блок volumes"
            else
                # volumes нет — создаём новый блок после SERVICE_LINE
                awk -v line="$SERVICE_LINE" -v vol1="${VOL_INDENT}volumes:" -v vol2="${VOL_ITEM_INDENT}- ./index.html:/opt/app/frontend/index.html" 'NR==line {print; print vol1; print vol2; next} 1' "$DC" > "${DC}.tmp" && mv "${DC}.tmp" "$DC"
                echo "  → Создан новый блок volumes с mount point"
            fi
        fi
    fi

    if [ -n "$THEME_ARG" ]; then
        echo "  → Перезапускаю контейнер..."
        docker compose down --remove-orphans 2>/dev/null || true
        docker compose up -d 2>/dev/null || true
        echo "  ✓ Контейнер перезапущен"
    else
        if [ "$L" = "ru" ]; then
            echo "  Хочешь перезапустить контейнер сейчас?"
            read -rp "  Добавить volume и перезапустить? [Y/n]: " restart_choice
        else
            echo "  Restart container now?"
            read -rp "  Add volume and restart? [Y/n]: " restart_choice
        fi
        case "$restart_choice" in
            n|N|no|No) echo "  → Добавь volume и перезапусти вручную: docker compose restart" ;;
            *) echo "  → Перезапускаю контейнер..."
               docker compose down --remove-orphans 2>/dev/null || true
               docker compose up -d 2>/dev/null || true
               echo "  ✓ Контейнер перезапущен" ;;
        esac
    fi
else
    echo "  docker-compose.yml не найден."
    if [ "$L" = "ru" ]; then
        echo "  Добавь volume mount в docker-compose.yml и перезапусти:"
    else
        echo "  Add volume mount and restart manually:"
    fi
    echo "    volumes:"
    echo "      - ./index.html:/opt/app/frontend/index.html"
    echo "  docker compose down && docker compose up -d"
fi
) || true
