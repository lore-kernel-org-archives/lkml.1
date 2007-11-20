Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbXKTB6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbXKTB6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757860AbXKTBtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:49 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2095 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117AbXKTBtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:13 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "LinuxTV.org Project" <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
Subject: [PATCH 24/59] drivers/media/radio: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:16 -0800
Message-Id: <1195523331-15303-25-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-24-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
 <1195523331-15303-23-git-send-email-joe@perches.com>
 <1195523331-15303-24-git-send-email-joe@perches.com>
Message-Id: <150c45e2fd3ccb01decbe9aff70d13fb45b347b7.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/radio/radio-gemtek.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index 5e4b9dd..9dafc35 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -58,10 +58,10 @@ static int initmute	= 1;
 static int radio_nr	= -1;
 
 module_param(io, int, 0444);
-MODULE_PARM_DESC(io, "Force I/O port for the GemTek Radio card if automatic"
+MODULE_PARM_DESC(io, "Force I/O port for the GemTek Radio card if automatic "
 	 "probing is disabled or fails. The most common I/O ports are: 0x20c "
 	 "0x30c, 0x24c or 0x34c (0x20c, 0x248 and 0x28c have been reported to "
-	 " work for the combined sound/radiocard).");
+	 "work for the combined sound/radiocard).");
 
 module_param(probe, bool, 0444);
 MODULE_PARM_DESC(probe, "Enable automatic device probing. Note: only the most "
-- 
1.5.3.5.652.gf192c

