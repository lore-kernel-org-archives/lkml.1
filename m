Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbYJ0PVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbYJ0PVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYJ0PVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:21:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36911 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751614AbYJ0PVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:21:11 -0400
Date: Mon, 27 Oct 2008 15:21:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: perex@perex.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] sound: use a common working email address
Message-ID: <20081027152119.2ab80672@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>


diff --git a/sound/oss/kahlua.c b/sound/oss/kahlua.c
index eb9bc36..c180598 100644
--- a/sound/oss/kahlua.c
+++ b/sound/oss/kahlua.c
@@ -1,7 +1,7 @@
 /*
  *	Initialisation code for Cyrix/NatSemi VSA1 softaudio
  *
- *	(C) Copyright 2003 Red Hat Inc <alan@redhat.com>
+ *	(C) Copyright 2003 Red Hat Inc <alan@lxorguk.ukuu.org.uk>
  *
  * XpressAudio(tm) is used on the Cyrix MediaGX (now NatSemi Geode) systems.
  * The older version (VSA1) provides fairly good soundblaster emulation
diff --git a/sound/pci/cs5530.c b/sound/pci/cs5530.c
index 7ff8b68..4ba2db2 100644
--- a/sound/pci/cs5530.c
+++ b/sound/pci/cs5530.c
@@ -2,7 +2,7 @@
  * cs5530.c - Initialisation code for Cyrix/NatSemi VSA1 softaudio
  *
  * 	(C) Copyright 2007 Ash Willis <ashwillis@programmer.net>
- *	(C) Copyright 2003 Red Hat Inc <alan@redhat.com>
+ *	(C) Copyright 2003 Red Hat Inc <alan@lxorguk.ukuu.org.uk>
  *
  * This driver was ported (shamelessly ripped ;) from oss/kahlua.c but I did
  * mess with it a bit. The chip seems to have to have trouble with full duplex
diff --git a/sound/sound_core.c b/sound/sound_core.c
index faef87a..a75b289 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -57,7 +57,7 @@ module_exit(cleanup_soundcore);
 /*
  *	OSS sound core handling. Breaks out sound functions to submodules
  *	
- *	Author:		Alan Cox <alan.cox@linux.org>
+ *	Author:		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	Fixes:
  *
