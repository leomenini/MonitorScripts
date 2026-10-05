#!/usr/bin/env bash
set -euo pipefail

PRIMARY_OUTPUT="DVI-D-0"
SECONDARY_OUTPUT="HDMI-0"

usage() {
    cat <<EOF
Uso: $(basename "$0") <comando>

Comandos:
  list, ls        Muestra los monitores conectados
  primary, p       Solo monitor principal ($PRIMARY_OUTPUT)
  secondary, s      Solo monitor secundario ($SECONDARY_OUTPUT)
  extended, e       Ambos monitores extendidos

Sin argumentos, muestra un menu interactivo.
EOF
}

list_monitors() {
    xrandr | grep " connected"
}

set_primary_only() {
    xrandr --output "$PRIMARY_OUTPUT" --auto --primary --output "$SECONDARY_OUTPUT" --off
    echo "Modo: solo monitor principal ($PRIMARY_OUTPUT)"
}

set_secondary_only() {
    xrandr --output "$SECONDARY_OUTPUT" --auto --primary --output "$PRIMARY_OUTPUT" --off
    echo "Modo: solo monitor secundario ($SECONDARY_OUTPUT)"
}

set_extended() {
    xrandr --output "$PRIMARY_OUTPUT" --primary --auto --output "$SECONDARY_OUTPUT" --auto --left-of "$PRIMARY_OUTPUT"
    echo "Modo: ambos monitores extendidos"
}

interactive_menu() {
    echo "Monitores conectados:"
    list_monitors
    echo
    echo "Selecciona un modo:"
    echo "  1) Solo monitor principal ($PRIMARY_OUTPUT)"
    echo "  2) Solo monitor secundario ($SECONDARY_OUTPUT)"
    echo "  3) Ambos extendidos"
    echo "  4) Cancelar"
    read -rp "Opcion: " opt
    case "$opt" in
        1) set_primary_only ;;
        2) set_secondary_only ;;
        3) set_extended ;;
        *) echo "Cancelado" ;;
    esac
}

case "${1:-}" in
    list|ls) list_monitors ;;
    primary|p) set_primary_only ;;
    secondary|s) set_secondary_only ;;
    extended|e) set_extended ;;
    -h|--help) usage ;;
    "") interactive_menu ;;
    *) echo "Comando desconocido: $1"; usage; exit 1 ;;
esac
