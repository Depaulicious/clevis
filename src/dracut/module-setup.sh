#!/bin/bash
# vim: set tabstop=8 shiftwidth=4 softtabstop=4 expandtab smarttab colorcolumn=80:
#
# Copyright (c) 2016 Red Hat, Inc.
# Author: Nathaniel McCallum <npmccallum@redhat.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

depends() {
    echo crypt systemd network
    return 0
}

cmdline() {
    echo "rd.neednet=1"
}

install() {
    cmdline > "${initdir}/etc/cmdline.d/99clevis.conf"

    inst_hook initqueue/online 60 "$moddir/clevis-hook.sh"
    inst_hook initqueue/settled 60 "$moddir/clevis-hook.sh"

    inst_multiple /etc/services \
        clevis-decrypt-http \
        clevis-decrypt-tang \
        clevis-decrypt-tpm2 \
        clevis-decrypt-sss \
        clevis-decrypt \
        tpm2_createprimary \
        tpm2_pcrlist \
        tpm2_unseal \
        tpm2_load \
        luksmeta \
        clevis \
        mktemp \
        curl \
        jose \
        nc

    dracut_need_initqueue
}

installkernel() {
    hostonly='' instmods =drivers/char/tpm
}

