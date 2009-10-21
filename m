Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbZJURlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbZJURlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZJURlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 13:41:20 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:65129 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbZJURlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 13:41:20 -0400
Date: Wed, 21 Oct 2009 10:40:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Corey Minyard <minyard@acm.org>
Subject: [PATCH] MAINTAINERS: openipmi list is moderated
Message-Id: <20091021104039.dfb0d771.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4ADF47B0.00E6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

openipmi list is moderated.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2632-rc5.orig/MAINTAINERS
+++ lnx-2632-rc5/MAINTAINERS
@@ -2829,7 +2829,7 @@ F:	drivers/infiniband/hw/ipath/
 
 IPMI SUBSYSTEM
 M:	Corey Minyard <minyard@acm.org>
-L:	openipmi-developer@lists.sourceforge.net
+L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://openipmi.sourceforge.net/
 S:	Supported
 F:	Documentation/IPMI.txt
