Return-Path: <linux-kernel-owner+w=401wt.eu-S968623AbXHMIaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968623AbXHMIaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965672AbXHMG32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4637 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966660AbXHMG30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:26 -0400
Date: Sun, 12 Aug 2007 23:29:12 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, linux-altix@sgi.com, jes@sgi.com,
       akpm@linux-foundation.org
Subject: [PATCH] [236/2many] MAINTAINERS - SN-IA64 (Itanium) SUB-PLATFORM
Message-ID: <46bffa38./aNRec9VI7toFMT5%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f68199b..1844d23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2247,6 +2247,7 @@ L:	linux-altix@sgi.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.sgi.com/altix
 S:	Maintained
+F:	arch/ia64/sn/
 
 IBM MCA SCSI SUBSYSTEM DRIVER
 P:	Michael Lang
