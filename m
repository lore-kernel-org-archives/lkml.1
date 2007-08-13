Return-Path: <linux-kernel-owner+w=401wt.eu-S1764432AbXHMKI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764432AbXHMKI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967155AbXHMGe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1536 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967158AbXHMGeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:23 -0400
Date: Sun, 12 Aug 2007 23:34:06 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       ambx1@neo.rr.com, akpm@linux-foundation.org
Subject: [PATCH] [382/2many] MAINTAINERS - PNP SUPPORT
Message-ID: <46bffb5e.jDxKwMkFbgCGiGQQ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f526cf5..5601fe6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3665,6 +3665,7 @@ PNP SUPPORT
 P:	Adam Belay
 M:	ambx1@neo.rr.com
 S:	Maintained
+F:	drivers/pnp/
 
 PNXxxxx I2C DRIVER
 P:	Vitaly Wool
