Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZHLPAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZHLPAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZHLPAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:00:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbZHLPAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:00:47 -0400
Date: Wed, 12 Aug 2009 12:00:40 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] intel txt: Fix typos in Kconfig help
Message-ID: <20090812150040.GH3180@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 security/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/Kconfig b/security/Kconfig
index edc7cbd..6631774 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -123,7 +123,7 @@ config INTEL_TXT
 	  of the kernel. If the system does not support Intel(R) TXT, this
 	  will have no effect.
 
-	  Intel TXT will provide higher assurance of sysem configuration and
+	  Intel TXT will provide higher assurance of system configuration and
 	  initial state as well as data reset protection.  This is used to
 	  create a robust initial kernel measurement and verification, which
 	  helps to ensure that kernel security mechanisms are functioning
@@ -132,7 +132,7 @@ config INTEL_TXT
 
 	  Intel TXT also helps solve real end user concerns about having
 	  confidence that their hardware is running the VMM or kernel that
-	  it was conigured with, especially since they may be responsible for
+	  it was configured with, especially since they may be responsible for
 	  providing such assurances to VMs and services running on it.
 
 	  See <http://www.intel.com/technology/security/> for more information
-- 
1.6.2.5


