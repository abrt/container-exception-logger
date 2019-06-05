#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of cel-sanity
#   Description: does sanity for container-exception-logger
#   Author: Martin Kutlak <mkutlak@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2019 Red Hat, Inc. All rights reserved.
#
#   This program is free software: you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation, either version 3 of
#   the License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be
#   useful, but WITHOUT ANY WARRANTY; without even the implied
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE.  See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see http://www.gnu.org/licenses/.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

. /usr/share/beakerlib/beakerlib.sh

export TEST="cel-sanity"
export PACKAGE="container-exception-logger"

rlJournalStart

    rlPhaseStartTest "Check --help"
        rlAssertRpm "container-exception-logger"
        rlRun -t "container-exception-logger --help" 0,1
        rlRun "container-exception-logger --help | grep 'Usage: container-exception-logger [--no-tag | --tag STRING | --help]'" 0,1
    rlPhaseEnd

    rlPhaseStartTest "Check unknown option (--hjalp)"
        rlRun -t "container-exception-logger --hjalp | grep 'Usage: container-exception-logger [--no-tag | --tag STRING | --help]'" 1
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
