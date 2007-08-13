Return-Path: <linux-kernel-owner+w=401wt.eu-S935820AbXHMKZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935820AbXHMKZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967263AbXHMGf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1692 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967232AbXHMGfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:19 -0400
Date: Sun, 12 Aug 2007 23:35:04 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, schwidefsky@de.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Subject: [PATCH] [412/2many] MAINTAINERS - S390
Message-ID: <46bffb98.6fqsmBN7GskJtI8V%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 88bff1a..21b14d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3929,6 +3929,8 @@ M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	arch/s390/
+F:	include/asm-s390/
 
 S390 NETWORK DRIVERS
 P:	Frank Pavlic
