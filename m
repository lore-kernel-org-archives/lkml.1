Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbZAZB7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbZAZB7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 20:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbZAZB7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 20:59:34 -0500
Received: from vps1.tull.net ([66.180.172.116]:50666 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750868AbZAZB7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 20:59:34 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 00/20] Fix misspelling of "firmware"
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 12:59:22 +1100
Message-ID: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix more misspellings of "firmware" which I noticed in v2.6.29-rc2. All are
comment changes.

Nick.
---

Nick Andrew (20):
      Fix misspelling of firmware in iwl-agn.c
      Fix misspelling of firmware in iwl3945-base.c
      Fix misspelling of firmware in hpmain.c
      Fix misspelling of firmware in head_64.S
      Fix misspelling of firmware in aica.c
      Fix misspelling of firmware in pss.c
      Fix misspelling of firmware in disk.c
      Fix misspelling of firmware in libata.h
      Fix misspelling of firmware in ChangeLog.history
      Fix misspelling of firmware in ueagle-atm.c
      Fix misspelling of firmware in pci.c
      Fix misspelling of firmware in cmd.c
      Fix misspelling of firmware in ipw2200.c
      Fix misspelling of firmware in ipw2100.c
      Fix misspelling of firmware in tg3.c
      Fix misspelling of firmware in sb1250-mac.c
      Fix misspelling of firmware in thinkpad_acpi.c
      Fix misspelling of "firmware" in ip27-smp.c
      Fix misspelling of "firmware" in firmware.txt
      Fix misspelling of "firmware" in ia64-kvm.txt


 Documentation/ia64/kvm.txt                         |    2 +-
 .../dts-bindings/fsl/cpm_qe/qe/firmware.txt        |    2 +-
 arch/mips/sgi-ip27/ip27-smp.c                      |    2 +-
 arch/sparc/kernel/head_64.S                        |    2 +-
 drivers/net/sb1250-mac.c                           |    2 +-
 drivers/net/tg3.c                                  |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |    2 +-
 drivers/net/wireless/libertas/cmd.c                |    2 +-
 drivers/pci/pci.c                                  |    2 +-
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/staging/otus/hal/hpmain.c                  |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/serial/ChangeLog.history               |    2 +-
 include/linux/libata.h                             |    2 +-
 kernel/power/disk.c                                |    4 ++--
 sound/oss/pss.c                                    |    2 +-
 sound/sh/aica.c                                    |    2 +-
 20 files changed, 21 insertions(+), 21 deletions(-)

-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
