Return-Path: <linux-kernel-owner+w=401wt.eu-S945098AbXHMMP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945098AbXHMMP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967550AbXHMGkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:49 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2514 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967534AbXHMGkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:23 -0400
Date: Sun, 12 Aug 2007 23:40:09 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [556/2many] MAINTAINERS - ZS DECSTATION Z85C30 SERIAL
 DRIVER
Message-ID: <46bffcc9.xEomfuDqimc2Vc6y%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f4d5119..321f064 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5258,6 +5258,7 @@ ZS DECSTATION Z85C30 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
+F:	drivers/serial/zs.*
 
 THE REST
 P:	Linus Torvalds
