Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZA0Aep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZA0Aep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZA0Aea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:34:30 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:18459 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbZA0Ae3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:34:29 -0500
Date: Mon, 26 Jan 2009 16:34:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: general@lists.openfabrics.org, rolandd@cisco.com,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH resend/lost] maintainers: moderated mailing list
Message-Id: <20090126163411.7aeaff7f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.497E5686.0218:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 23 Oct 2008 18:38:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: general@lists.openfabrics.org, rolandd@cisco.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH] maintainers: moderated mailing list


From: Randy Dunlap <randy.dunlap@oracle.com>

I got the "list is moderated message," so add it here.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20081023.orig/MAINTAINERS
+++ linux-next-20081023/MAINTAINERS
@@ -2144,7 +2144,7 @@ P:	Sean Hefty
 M:	sean.hefty@intel.com
 P:	Hal Rosenstock
 M:	hal.rosenstock@gmail.com
-L:	general@lists.openfabrics.org
+L:	general@lists.openfabrics.org (moderated for non-subscribers)
 W:	http://www.openib.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
--
