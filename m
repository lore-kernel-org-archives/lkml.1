Return-Path: <linux-kernel-owner+w=401wt.eu-S1762472AbXHMKDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762472AbXHMKDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967178AbXHMGeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:15 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1485 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967166AbXHMGeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:05 -0400
Date: Sun, 12 Aug 2007 23:33:50 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, nagar@watson.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [375/2many] MAINTAINERS - PER-TASK DELAY ACCOUNTING
Message-ID: <46bffb4e.IZ5N2o2oGRP3esRo%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f5b7c2..05615e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3606,6 +3606,8 @@ P:	Shailabh Nagar
 M:	nagar@watson.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	include/linux/delayacct.h
+F:	kernel/delayacct.c
 
 PERSONALITY HANDLING
 P:	Christoph Hellwig
