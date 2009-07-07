Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZGGPj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZGGPj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbZGGPjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:39:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39022 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758127AbZGGPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:39:47 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] tty: maintainers data was edited wrongly by someone
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2009 16:39:54 +0100
Message-ID: <20090707153946.3642.58218.stgit@localhost.localdomain>
In-Reply-To: <20090707153625.3642.70750.stgit@localhost.localdomain>
References: <20090707153625.3642.70750.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Move tty entries to tty not trivial. Noted by David Brownell.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 MAINTAINERS |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 381190c..e4b1a3d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5803,17 +5803,17 @@ P:	Jiri Kosina
 M:	trivial@kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
 S:	Maintained
-F:	drivers/char/tty_*
-F:	drivers/serial/serial_core.c
-F:	include/linux/serial_core.h
-F:	include/linux/serial.h
-F:	include/linux/tty.h
 
 TTY LAYER
 P:	Alan Cox
 M:	alan@lxorguk.ukuu.org.uk
 S:	Maintained
 T:	stgit http://zeniv.linux.org.uk/~alan/ttydev/
+F:	drivers/char/tty_*
+F:	drivers/serial/serial_core.c
+F:	include/linux/serial_core.h
+F:	include/linux/serial.h
+F:	include/linux/tty.h
 
 TULIP NETWORK DRIVERS
 P:	Grant Grundler

