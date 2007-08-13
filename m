Return-Path: <linux-kernel-owner+w=401wt.eu-S970992AbXHMJCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970992AbXHMJCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966831AbXHMGbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4936 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966895AbXHMGbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:15 -0400
Date: Sun, 12 Aug 2007 23:31:01 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, paulus@au.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [287/2many] MAINTAINERS - LINUX FOR IBM pSERIES (RS/6000)
Message-ID: <46bffaa5.L7wWLRrjFwLlnubU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 836c58d..f833a74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2754,6 +2754,8 @@ P:	Paul Mackerras
 M:	paulus@au.ibm.com
 W:	http://www.ibm.com/linux/ltc/projects/ppc
 S:	Supported
+F:	arch/powerpc/boot/rs6000.h
+F:	arch/ppc/boot/include/rs6000.h
 
 LINUX FOR NCR VOYAGER
 P:	James Bottomley
