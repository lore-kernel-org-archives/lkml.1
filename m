Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbXJGKb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbXJGKb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 06:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXJGKbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 06:31:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42546 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbXJGKbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 06:31:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 7 Oct 2007 12:31:22 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: point to migration document
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.b9037b776f5ccfbe@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/Kconfig
===================================================================
--- linux.orig/drivers/firewire/Kconfig
+++ linux/drivers/firewire/Kconfig
@@ -11,7 +11,8 @@ config FIREWIRE
 	  This is the "Juju" FireWire stack, a new alternative implementation
 	  designed for robustness and simplicity.  You can build either this
 	  stack, or the classic stack (the ieee1394 driver, ohci1394 etc.)
-	  or both.
+	  or both.  Please read http://wiki.linux1394.org/JujuMigration before
+	  you enable the new stack.
 
 	  To compile this driver as a module, say M here: the module will be
 	  called firewire-core.  It functionally replaces ieee1394, raw1394,

-- 
Stefan Richter
-=====-=-=== =-=- --===
http://arcgraph.de/sr/

