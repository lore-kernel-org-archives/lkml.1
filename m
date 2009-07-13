Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZGMVQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZGMVQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbZGMVQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:16:50 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4024 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937AbZGMVPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:06 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 11/16] MAINTAINERS: Remove CS461x sound card section
Date: Mon, 13 Jul 2009 14:14:57 -0700
Message-Id: <a43654f2a0e1fcafbadb2b369f6b86813e1648c9.1247517374.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Woller's email address bounces
Nils Faerber isn't active

Added Thomas Woller to CREDITS, Nils already has an entry

Signed-off-by: Joe Perches <joe@perches.com>
---
 CREDITS     |    3 +++
 MAINTAINERS |    9 ---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/CREDITS b/CREDITS
index af93191..e0c5d9c 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3805,6 +3805,9 @@ S: van Bronckhorststraat 12
 S: 2612 XV Delft
 S: The Netherlands
 
+N: Thomas Woller
+D: CS461x Cirrus Logic sound driver
+
 N: David Woodhouse
 E: dwmw2@infradead.org
 D: JFFS2 file system, Memory Technology Device subsystem,
diff --git a/MAINTAINERS b/MAINTAINERS
index 9ec53ae..2931717 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1508,15 +1508,6 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 
-CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
-P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
-S:	Maintained
-F:	Documentation/input/cs461x.txt
-F:	sound/pci/cs46xx/
-
 CLK API
 P:	Russell King
 M:	linux@arm.linux.org.uk
-- 
1.6.3.1.10.g659a0.dirty

