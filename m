Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbZACHuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbZACHuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZACHuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:50:11 -0500
Received: from vps1.tull.net ([66.180.172.116]:49097 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750767AbZACHuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:50:10 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 00/11] Fix misspelling of "firmware"
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:49:33 +1100
Message-ID: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspellings of "firmware" which I noticed in 2.6.28. All are comment
changes except for the change to drivers/scsi/qla4xxx/ql4_mbx.c which
is in a string argument to dev_info().

Nick.
---

Nick Andrew (11):
      Fix misspelling of "firmware" in docs for ncr53c8xx/sym53c8xx
      Fix misspelling of "firmware" in powerpc Makefile
      Fix misspelling of "firmware" in usb.c
      Fix misspelling of "firmware" in qla1280.c
      Fix misspelling of "firmware" in a100u2w.c
      Fix misspelling of "firmware" in megaraid.c
      Fix misspelling of "firmware" in ql4_mbx.c
      Fix misspelling of "firmware" in acpi_memhotplug.c
      Fix misspelling of "firmware" in ipw2100.c
      Fix misspelling of "firmware" in atmel.c
      Fix misspelled firmware in Kconfig


 Documentation/scsi/ChangeLog.ncr53c8xx |    2 +-
 Documentation/scsi/ChangeLog.sym53c8xx |    2 +-
 arch/powerpc/boot/Makefile             |    2 +-
 drivers/acpi/acpi_memhotplug.c         |    2 +-
 drivers/base/Kconfig                   |    2 +-
 drivers/net/wireless/atmel.c           |    2 +-
 drivers/net/wireless/ipw2100.c         |    2 +-
 drivers/scsi/a100u2w.c                 |    2 +-
 drivers/scsi/megaraid.c                |    4 ++--
 drivers/scsi/qla1280.c                 |    4 ++--
 drivers/scsi/qla4xxx/ql4_mbx.c         |    2 +-
 drivers/uwb/i1480/dfu/usb.c            |    2 +-
 12 files changed, 14 insertions(+), 14 deletions(-)

-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
