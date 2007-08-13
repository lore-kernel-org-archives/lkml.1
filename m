Return-Path: <linux-kernel-owner+w=401wt.eu-S939825AbXHMJZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939825AbXHMJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966974AbXHMGcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1153 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966321AbXHMGcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:19 -0400
Date: Sun, 12 Aug 2007 23:32:04 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jejb@steeleye.com, akpm@linux-foundation.org
Subject: [PATCH] [319/2many] MAINTAINERS - MISCELLANEOUS MCA-SUPPORT
Message-ID: <46bffae4.b2t3jASUqozXVwfq%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index cda5f15..5b4617f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3071,6 +3071,10 @@ P:	James Bottomley
 M:	jejb@steeleye.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/ia64/mca.txt
+F:	Documentation/mca.txt
+F:	drivers/mca/
+F:	include/linux/mca*
 
 MODULE SUPPORT
 P:	Rusty Russell
