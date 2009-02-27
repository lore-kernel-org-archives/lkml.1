Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZB0ArA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZB0ArA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZB0Aqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:46:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:31500 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZB0Aqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:46:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,273,1233561600"; 
   d="scan'208";a="493480011"
From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH] net headers: export dcbnl.h
To: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Feb 2009 16:46:35 -0800
Message-ID: <20090227004635.10247.60814.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DCB netlink interface is required for building the userspace tools
available at e1000.sourceforge.net

Signed-off-by: Chris Leech <christopher.leech@intel.com>
---

 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b97cdc5..106c3ba 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -52,6 +52,7 @@ header-y += const.h
 header-y += cgroupstats.h
 header-y += cramfs_fs.h
 header-y += cycx_cfm.h
+header-y += dcbnl.h
 header-y += dlmconstants.h
 header-y += dlm_device.h
 header-y += dlm_netlink.h

