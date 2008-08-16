Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbYHPTw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbYHPTw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYHPTwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:52:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51284 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYHPTwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:52:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Aug 2008 21:52:28 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: Kconfig help update
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.ac88926e10eb85ca@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

--- linux.orig/drivers/firewire/Kconfig
+++ linux/drivers/firewire/Kconfig
@@ -12,8 +12,8 @@ config FIREWIRE
 	  This is the "Juju" FireWire stack, a new alternative implementation
 	  designed for robustness and simplicity.  You can build either this
 	  stack, or the old stack (the ieee1394 driver, ohci1394 etc.) or both.
-	  Please read http://wiki.linux1394.org/JujuMigration before you
-	  enable the new stack.
+	  Please read http://ieee1394.wiki.kernel.org/index.php/Juju_Migration
+	  before you enable the new stack.
 
 	  To compile this driver as a module, say M here: the module will be
 	  called firewire-core.

-- 
Stefan Richter
-=====-==--- =--- =----
http://arcgraph.de/sr/

