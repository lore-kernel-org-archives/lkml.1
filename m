Return-Path: <linux-kernel-owner+w=401wt.eu-S934423AbXHMKo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423AbXHMKo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967207AbXHMGgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1839 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967312AbXHMGgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:09 -0400
Date: Sun, 12 Aug 2007 23:35:55 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, nico@cam.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [439/2many] MAINTAINERS - SMC91x ETHERNET DRIVER
Message-ID: <46bffbcb.aO+0jolqL6AKxWob%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a3c6123..140eb07 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4175,6 +4175,7 @@ SMC91x ETHERNET DRIVER
 P:	Nicolas Pitre
 M:	nico@cam.org
 S:	Maintained
+F:	drivers/net/smc91x.*
 
 SMSC47B397 HARDWARE MONITOR DRIVER
 P:	Mark M. Hoffman
