Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbZGHF5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbZGHF5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbZGHFzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:55:53 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3007 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbZGHFzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:55:50 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
Date: Tue,  7 Jul 2009 22:55:43 -0700
Message-Id: <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247032324.git.joe@perches.com>
References: <cover.1247032324.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from sections that should not have them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4da8c4d..5628b0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2197,7 +2197,6 @@ F:	drivers/scsi/lpfc/
 ENE CB710 FLASH CARD READER DRIVER
 P:	Michał Mirosław
 M:	mirq-linux@rere.qmqm.pl
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/cb710/
 F:	drivers/mmc/host/cb710-mmc.*
@@ -3473,13 +3472,11 @@ P:	Vegard Nossum
 M:	vegardno@ifi.uio.no
 P	Pekka Enberg
 M:	penberg@cs.helsinki.fi
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 KMEMLEAK
 P:	Catalin Marinas
 M:	catalin.marinas@arm.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/kmemleak.txt
 F:	include/linux/kmemleak.h
@@ -4298,7 +4295,6 @@ F:	drivers/video/omap/
 OMAP MMC SUPPORT
 P:	Jarkko Lavinen
 M:	jarkko.lavinen@nokia.com
-L:	linux-kernel@vger.kernel.org
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/*omap*
@@ -4577,7 +4573,6 @@ P:	Paul Mackerras
 M:	paulus@samba.org
 P:	Ingo Molnar
 M:	mingo@elte.hu
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 
 PERSONALITY HANDLING
-- 
1.6.3.1.10.g659a0.dirty

