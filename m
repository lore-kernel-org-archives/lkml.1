Return-Path: <linux-kernel-owner+w=401wt.eu-S943634AbXHMJhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943634AbXHMJhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762228AbXHMGcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1243 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbXHMGcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:50 -0400
Date: Sun, 12 Aug 2007 23:32:37 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Paul.Clements@steeleye.com
Subject: [PATCH] [337/2many] MAINTAINERS - NETWORK BLOCK DEVICE (NBD)
Message-ID: <46bffb05.6roiBCSkLzdOzM/u%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c448360..d9e9813 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3231,6 +3231,9 @@ NETWORK BLOCK DEVICE (NBD)
 P:	Paul Clements
 M:	Paul.Clements@steeleye.com
 S:	Maintained
+F:	Documentation/nbd.txt
+F:	drivers/block/nbd.c
+F:	include/linux/nbd.h
 
 NETWORK DEVICE DRIVERS
 P:	Andrew Morton
