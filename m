Return-Path: <linux-kernel-owner+w=401wt.eu-S965681AbYD1Psy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965681AbYD1Psy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935404AbYD1Pk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:40:58 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59703 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965054AbYD1Pk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:40:56 -0400
Date: Mon, 28 Apr 2008 18:40:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080428154023.GU2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

This patch converts some non-UTF-8 encoded text in comments to UTF-8.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch is attached compressed to prevent my MUA from mangling it.

 Documentation/PCI/pcieaer-howto.txt |    2 -
 arch/arm/mach-omap2/io.c            |    2 -
 arch/s390/kernel/ebcdic.c           |   36 ++++++++++++++--------------
 drivers/hid/hid-input.c             |    2 -
 drivers/isdn/hisax/enternow_pci.c   |    2 -
 drivers/media/video/saa5249.c       |    2 -
 drivers/misc/ibmasm/command.c       |    2 -
 drivers/misc/ibmasm/dot_command.c   |    2 -
 drivers/misc/ibmasm/dot_command.h   |    2 -
 drivers/misc/ibmasm/event.c         |    2 -
 drivers/misc/ibmasm/heartbeat.c     |    2 -
 drivers/misc/ibmasm/i2o.h           |    2 -
 drivers/misc/ibmasm/ibmasm.h        |    2 -
 drivers/misc/ibmasm/ibmasmfs.c      |    2 -
 drivers/misc/ibmasm/lowlevel.c      |    2 -
 drivers/misc/ibmasm/lowlevel.h      |    2 -
 drivers/misc/ibmasm/module.c        |    2 -
 drivers/misc/ibmasm/r_heartbeat.c   |    2 -
 drivers/misc/ibmasm/remote.h        |    2 -
 drivers/misc/ibmasm/uart.c          |    2 -
 drivers/s390/ebcdic.c               |   36 ++++++++++++++--------------
 drivers/scsi/jazz_esp.c             |    2 -
 drivers/spi/omap2_mcspi.c           |    2 -
 drivers/usb/storage/cypress_atacb.c |    2 -
 drivers/video/omap/rfbi.c           |    2 -
 drivers/video/omap/sossi.c          |    2 -
 26 files changed, 60 insertions(+), 60 deletions(-)


--ikeVEW9yuYc//A+q
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="patch-fix-utf-8.gz"
Content-Transfer-Encoding: base64

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

--ikeVEW9yuYc//A+q--
