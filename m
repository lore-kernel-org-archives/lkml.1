Return-Path: <linux-kernel-owner+w=401wt.eu-S941780AbXHMIRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941780AbXHMIRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966690AbXHMG2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4511 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966686AbXHMG2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:38 -0400
Date: Sun, 12 Aug 2007 23:28:25 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rlove@rlove.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [212/2many] MAINTAINERS - HARD DRIVE ACTIVE PROTECTION
 SYSTEM (HDAPS) DRIVER
Message-ID: <46bffa09.cLhTxEqWbYCKsa8P%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 14cef9a..0b6b514 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2031,6 +2031,7 @@ M:	rlove@rlove.org
 M:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
 S:	Maintained
+F:	drivers/hwmon/hdaps.c
 
 HARMONY SOUND DRIVER
 P:	Kyle McMartin
