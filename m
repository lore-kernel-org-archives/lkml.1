Return-Path: <linux-kernel-owner+w=401wt.eu-S965986AbXHMLT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965986AbXHMLT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967069AbXHMGiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2111 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966280AbXHMGhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:46 -0400
Date: Sun, 12 Aug 2007 23:37:33 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [485/2many] MAINTAINERS - TURBOCHANNEL SUBSYSTEM
Message-ID: <46bffc2d.vTsXRftei0BUoJDT%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1fe5487..374ee9b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4601,6 +4601,8 @@ TURBOCHANNEL SUBSYSTEM
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
+F:	drivers/tc/
+F:	include/linux/tc.h
 
 U14-34F SCSI DRIVER
 P:	Dario Ballabio
