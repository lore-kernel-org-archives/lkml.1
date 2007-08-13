Return-Path: <linux-kernel-owner+w=401wt.eu-S942863AbXHMJWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942863AbXHMJWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967015AbXHMGcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:20 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1143 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966948AbXHMGcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:15 -0400
Date: Sun, 12 Aug 2007 23:32:02 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [318/2many] MAINTAINERS - MIPS
Message-ID: <46bffae2.5W/JqMcNOgZqqFED%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0c98162..cda5f15 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3062,6 +3062,9 @@ W:	http://www.linux-mips.org/
 L:	linux-mips@linux-mips.org
 T:	git www.linux-mips.org:/pub/scm/linux.git
 S:	Supported
+F:	Documentation/mips/
+F:	arch/mips/
+F:	include/asm-mips/
 
 MISCELLANEOUS MCA-SUPPORT
 P:	James Bottomley
