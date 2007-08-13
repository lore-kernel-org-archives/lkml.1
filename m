Return-Path: <linux-kernel-owner+w=401wt.eu-S969006AbXHMIsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969006AbXHMIsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966866AbXHMGa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4775 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966825AbXHMGaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:20 -0400
Date: Sun, 12 Aug 2007 23:30:00 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, e1000-devel@lists.sourceforge.net,
       ayyappan.veeraiyan@intel.com, auke-jan.h.kok@intel.com,
       akpm@linux-foundation.org
Subject: [PATCH] [258/2many] MAINTAINERS - INTEL PRO/10GbE SUPPORT
Message-ID: <46bffa68.1NjvtbKDIYNXGAWj%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cf1579..fbefe07 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2469,6 +2469,7 @@ M:	auke-jan.h.kok@intel.com
 L:	e1000-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/e1000/
 S:	Supported
+F:	drivers/net/ixgb/
 
 INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
 P:	Yi Zhu
