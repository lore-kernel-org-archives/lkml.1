Return-Path: <linux-kernel-owner+w=401wt.eu-S967122AbXHMGdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967122AbXHMGdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXHMGWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:45 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3510 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965695AbXHMGWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:41 -0400
Date: Sun, 12 Aug 2007 23:22:25 -0700
From: joe@perches.com
To: zippel@linux-m68k.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [33/2many] MAINTAINERS - AFFS FILE SYSTEM
Message-ID: <46bff8a1./+9VpioKvMgx+Tdi%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b84e0e6..e973233 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -332,6 +332,7 @@ AFFS FILE SYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 S:	Maintained
+F:	fs/affs/
 
 AGPGART DRIVER
 P:	David Airlie
