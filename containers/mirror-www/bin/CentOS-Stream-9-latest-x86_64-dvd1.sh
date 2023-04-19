#!/usr/bin/env bash

set -e

ISO='CentOS-Stream-9-latest-x86_64-dvd1.iso'
SUM='CentOS-Stream-9-latest-x86_64-dvd1.iso.sha256sum'
ISO_URL='https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso&redirect=1&protocol=https'
SUM_URL='https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso.SHA256SUM&redirect=1&protocol=https'

script_path=$(realpath -e "$0")
script_dir=$(dirname "${script_path}")
download_dir="${script_dir}/../data/iso"

function info  { printf "INFO:  %s\n" "$*"; }
function error { printf "ERROR: %s\n" "$*" >&2; exit 1; }

cd "${download_dir}" || error "download dir missing (${script_path})"

if [[ -f "${SUM}" && -f "${ISO}" ]]; then
  info "iso already downloaded and verified"
  exit 0
fi

if [[ ! -f "${ISO}" ]]; then
  if [[ -f "${ISO}.tmp" ]]; then info "resuming ${ISO} download"; else info "downloading ${ISO}"; fi
  curl -sSL -C - -o "${ISO}.tmp" "${ISO_URL}"
fi

info "downloading ${SUM}"
curl -sSL -o "${SUM}" "${SUM_URL}" || error "checksum download failed"

info "generating temp ${ISO} checksum"
tmp_sum=$(sha256sum "${ISO}.tmp" | grep -oP '^[A-Fa-f0-9]+')

if sha256sum "${ISO}.tmp" | grep -qw "${tmp_sum}"; then
  info "checksum validated"
  mv "${ISO}.tmp" "${ISO}"
fi
