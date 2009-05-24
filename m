Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZEXClE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZEXClE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZEXCiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:14 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1438 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbZEXCiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:05 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] MAINTAINERS - Mark ALSA lists as moderated
Date: Sat, 23 May 2009 19:37:46 -0700
Message-Id: <2ef1a2b00b2d0461bc6f2d6c636c36e28a918724.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e55bace..11231fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -487,7 +487,7 @@ AOA (Apple Onboard Audio) ALSA DRIVER
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
 L:	linuxppc-dev@ozlabs.org
-L:	alsa-devel@alsa-project.org (subscribers-only)
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Maintained
 F:	sound/aoa/
 
@@ -1413,7 +1413,7 @@ F:	drivers/usb/host/ohci-ep93xx.c
 CIRRUS LOGIC CS4270 SOUND DRIVER
 P:	Timur Tabi
 M:	timur@freescale.com
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 
@@ -2316,7 +2316,7 @@ F:	drivers/serial/ucc_uart.c
 FREESCALE SOC SOUND DRIVERS
 P:	Timur Tabi
 M:	timur@freescale.com
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 F:	sound/soc/fsl/fsl*
@@ -5278,7 +5278,7 @@ P:	Jaroslav Kysela
 M:	perex@perex.cz
 P:	Takashi Iwai
 M:	tiwai@suse.de
-L:	alsa-devel@alsa-project.org (subscribers-only)
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://www.alsa-project.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
 T:	git git://git.alsa-project.org/alsa-kernel.git
@@ -5293,7 +5293,7 @@ M:	lrg@slimlogic.co.uk
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-asoc
-L:	alsa-devel@alsa-project.org (subscribers-only)
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://alsa-project.org/main/index.php/ASoC
 S:	Supported
 F:	sound/soc/
-- 
1.6.3.1.10.g659a0.dirty

