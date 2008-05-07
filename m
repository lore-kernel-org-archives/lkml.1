Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYEGUmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYEGUmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYEGUmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:42:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:57134 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYEGUmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:42:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,450,1204531200"; 
   d="scan'208";a="381110370"
From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH] [MAINTAINERS] New maintainer for Intel ethernet adapters
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       greg@kroah.com, jeffrey.t.kirsher@intel.com
Date: Wed, 07 May 2008 13:42:33 -0700
Message-ID: <20080507204233.12837.92852.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2008 20:42:34.0266 (UTC) FILETIME=[E0BB2FA0:01C8B082]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm handing over maintainership to Jeff Kirsher and moving on
to other Linux/Open Source work within Intel. Good luck to Jeff ;)

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

 MAINTAINERS |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3a533d..0cc47b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2104,12 +2104,10 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 
 INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)
-P:	Auke Kok
-M:	auke-jan.h.kok@intel.com
-P:	Jesse Brandeburg
-M:	jesse.brandeburg@intel.com
 P:	Jeff Kirsher
 M:	jeffrey.t.kirsher@intel.com
+P:	Jesse Brandeburg
+M:	jesse.brandeburg@intel.com
 P:	Bruce Allan
 M:	bruce.w.allan@intel.com
 P:	John Ronciak

