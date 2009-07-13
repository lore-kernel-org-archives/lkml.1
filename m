Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZGMVPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZGMVPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZGMVPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:15:09 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4012 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbZGMVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:04 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/16] MAINTAINERS: Move ARPD to CREDITS
Date: Mon, 13 Jul 2009 14:14:52 -0700
Message-Id: <395b055e4607d4ce27ddeee2e2d93ecb77c679e5.1247517374.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Layes is hard to find.

Signed-off-by: Joe Perches <joe@perches.com>
---
 CREDITS     |    3 +++
 MAINTAINERS |    6 ------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/CREDITS b/CREDITS
index 2b88fb3..af93191 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2006,6 +2006,9 @@ E: paul@laufernet.com
 D: Soundblaster driver fixes, ISAPnP quirk
 S: California, USA
 
+N: Jonathan Layes
+D: ARPD support
+
 N: Tom Lees
 E: tom@lpsg.demon.co.uk
 W: http://www.lpsg.demon.co.uk/
diff --git a/MAINTAINERS b/MAINTAINERS
index 4da4190..2851cec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -951,12 +951,6 @@ W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/vfp/
 
-ARPD SUPPORT
-P:	Jonathan Layes
-L:	netdev@vger.kernel.org
-S:	Maintained
-F:	net/ipv4/arp.c
-
 ASUS ACPI EXTRAS DRIVER
 P:	Corentin Chary
 M:	corentincj@iksaif.net
-- 
1.6.3.1.10.g659a0.dirty

