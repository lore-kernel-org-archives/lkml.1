Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbXBLHnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbXBLHnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933088AbXBLHnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:43:45 -0500
Received: from ns2.suse.de ([195.135.220.15]:49642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110AbXBLHiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:23 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Nicolas Kaiser <nikai@nikai.net>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [22/39] x86_64: Kconfig typos
Message-Id: <20070212073809.D070413D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Nicolas Kaiser <nikai@nikai.net>
Some typos in Kconfig.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 arch/x86_64/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/arch/x86_64/Kconfig
===================================================================
--- linux.orig/arch/x86_64/Kconfig
+++ linux/arch/x86_64/Kconfig
@@ -148,18 +148,18 @@ config MPSC
 	  Optimize for Intel Pentium 4 and older Nocona/Dempsey Xeon CPUs
 	  with Intel Extended Memory 64 Technology(EM64T). For details see
 	  <http://www.intel.com/technology/64bitextensions/>.
-	  Note the the latest Xeons (Xeon 51xx and 53xx) are not based on the
-          Netburst core and shouldn't use this option. You can distingush them
+	  Note that the latest Xeons (Xeon 51xx and 53xx) are not based on the
+          Netburst core and shouldn't use this option. You can distinguish them
 	  using the cpu family field
-	  in /proc/cpuinfo. Family 15 is a older Xeon, Family 6 a newer one
-	  (this rule only applies to system that support EM64T)
+	  in /proc/cpuinfo. Family 15 is an older Xeon, Family 6 a newer one
+	  (this rule only applies to systems that support EM64T)
 
 config MCORE2
 	bool "Intel Core2 / newer Xeon"
 	help
 	  Optimize for Intel Core2 and newer Xeons (51xx)
-	  You can distingush the newer Xeons from the older ones using
-	  the cpu family field in /proc/cpuinfo. 15 is a older Xeon
+	  You can distinguish the newer Xeons from the older ones using
+	  the cpu family field in /proc/cpuinfo. 15 is an older Xeon
 	  (use CONFIG_MPSC then), 6 is a newer one. This rule only
 	  applies to CPUs that support EM64T.
 
