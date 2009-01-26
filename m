Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZAZCJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZAZCJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZAZCI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:08:59 -0500
Received: from vps1.tull.net ([66.180.172.116]:36475 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753594AbZAZCI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:08:58 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 18/20] Fix misspelling of firmware in hpmain.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:08:51 +1100
Message-ID: <20090126020851.15168.7912.stgit@marcab.local.tull.net>
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of firmware in hpmain.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/staging/otus/hal/hpmain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/otus/hal/hpmain.c b/drivers/staging/otus/hal/hpmain.c
index 2e65c46..dab2783 100644
--- a/drivers/staging/otus/hal/hpmain.c
+++ b/drivers/staging/otus/hal/hpmain.c
@@ -152,7 +152,7 @@ u16_t zfHpInit(zdev_t* dev, u32_t frequency)
     else
     {
     #ifndef ZM_OTUS_LINUX_PHASE_2
-        /* donwload the normal frimware */
+        /* download the normal firmware */
         if ((ret = zfFirmwareDownload(dev, (u32_t*)zcFwImage,
                 (u32_t)zcFwImageSize, ZM_FIRMWARE_WLAN_ADDR)) != ZM_SUCCESS)
         {

