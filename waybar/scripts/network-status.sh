#!/usr/bin/env bash
set -u

json_escape() {
  local value=${1-}
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/}
  printf '%s' "$value"
}

emit() {
  local text=$1
  local class=$2
  local tooltip=${3-}

  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' \
    "$(json_escape "$text")" \
    "$(json_escape "$class")" \
    "$(json_escape "$tooltip")"
}

field_after() {
  local key=$1
  awk -v key="$key" '{
    for (i = 1; i <= NF; i++) {
      if ($i == key && i < NF) {
        print $(i + 1)
        exit
      }
    }
  }'
}

route=$(ip -o -4 route show default 2>/dev/null | head -n 1)
iface=$(printf '%s\n' "$route" | field_after dev)
gateway=$(printf '%s\n' "$route" | field_after via)

if [[ -z "$iface" ]]; then
  route=$(ip -o -6 route show default 2>/dev/null | head -n 1)
  iface=$(printf '%s\n' "$route" | field_after dev)
  gateway=$(printf '%s\n' "$route" | field_after via)
fi

if [[ -z "$iface" ]]; then
  for path in /sys/class/net/en* /sys/class/net/eth*; do
    [[ -e "$path" ]] || continue

    candidate=$(basename "$path")
    carrier=$(cat "$path/carrier" 2>/dev/null || printf '0')
    if [[ "$carrier" == "1" ]]; then
      tooltip=$'Network: Linked, no default route\n'
      tooltip+="Interface: $candidate"
      emit "󱘖 $candidate (No IP)" "linked" "$tooltip"
      exit 0
    fi
  done

  emit "󰖪 Disconnected" "disconnected" "No default route"
  exit 0
fi

ipaddr=$(ip -o -4 addr show dev "$iface" 2>/dev/null | awk '{print $4; exit}')

case "$iface" in
  en*|eth*)
    speed=$(cat "/sys/class/net/$iface/speed" 2>/dev/null || true)
    if [[ -n "$speed" && "$speed" != "-1" ]]; then
      link_detail="${speed}Mbps"
    else
      link_detail="wired"
    fi

    tooltip=$'Network: Wired\n'
    tooltip+="Interface: $iface"$'\n'
    tooltip+="IP: ${ipaddr:-unknown}"$'\n'
    tooltip+="Gateway: ${gateway:-unknown}"$'\n'
    tooltip+="Link: $link_detail"
    emit "󱘖 Wired" "ethernet" "$tooltip"
    ;;
  wl*)
    ssid=$(iwctl station "$iface" show 2>/dev/null | awk '
      /Connected network/ {
        sub(/^.*Connected network[[:space:]]+/, "")
        sub(/[[:space:]]+$/, "")
        print
        exit
      }
    ')

    if [[ -z "$ssid" ]]; then
      ssid=$(iwgetid "$iface" -r 2>/dev/null || true)
    fi

    tooltip=$'Network: Wi-Fi\n'
    tooltip+="SSID: ${ssid:-unknown}"$'\n'
    tooltip+="Interface: $iface"$'\n'
    tooltip+="IP: ${ipaddr:-unknown}"$'\n'
    tooltip+="Gateway: ${gateway:-unknown}"
    emit " ${ssid:-Wi-Fi}" "wifi" "$tooltip"
    ;;
  *)
    tooltip=$'Network: Connected\n'
    tooltip+="Interface: $iface"$'\n'
    tooltip+="IP: ${ipaddr:-unknown}"$'\n'
    tooltip+="Gateway: ${gateway:-unknown}"
    emit "󰈀 $iface" "connected" "$tooltip"
    ;;
esac
