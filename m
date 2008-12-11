Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbYLKXEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbYLKXEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757831AbYLKXEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:04:44 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45184 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708AbYLKXEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:04:41 -0500
Date: Thu, 11 Dec 2008 17:04:40 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, phillip@hellewell.homeip.net,
       tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Subject: [PATCH] eCryptfs: Update maintainers
Message-ID: <20081211230440.GC13627@halcrowt61p.lan>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tyler Hicks and Dustin Kirkland are now the primary contact points for
eCryptfs issues that may arise from this point forward.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Acked-by: Dustin Kirkland <kirkland@canonical.com>

---
diff --git a/MAINTAINERS b/MAINTAINERS
index d643e86..0022754 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1526,10 +1526,10 @@ W:	http://ebtables.sourceforge.net/
 S:	Maintained
 
 ECRYPT FILE SYSTEM
-P:	Mike Halcrow, Phillip Hellewell
-M:	mhalcrow@us.ibm.com, phillip@hellewell.homeip.net
-L:	ecryptfs-devel@lists.sourceforge.net
-W:	http://ecryptfs.sourceforge.net/
+P:	Tyler Hicks, Dustin Kirkland
+M:	tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
+L:	ecryptfs-devel@lists.launchpad.net
+W:	https://launchpad.net/ecryptfs
 S:	Supported
 
 EDAC-CORE
