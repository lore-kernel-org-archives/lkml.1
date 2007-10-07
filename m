Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbXJGMCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbXJGMCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 08:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXJGMCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 08:02:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44582 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXJGMCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 08:02:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 7 Oct 2007 14:02:07 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] last minute FireWire update
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.e4d177adf50f4c94@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following simple but hopefully effective update.

 drivers/firewire/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

commit a1134dd48d59e532b801659163539bf01cae7673
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Oct 7 12:31:22 2007 +0200

    firewire: point to migration document
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index d011a76..fe9e768 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
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

