Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXHMHGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXHMHGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966094AbXHMGY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:26 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3797 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965959AbXHMGYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:21 -0400
Date: Sun, 12 Aug 2007 23:24:06 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       bryan.wu@analog.com, akpm@linux-foundation.org
Subject: [PATCH] [86/2many] MAINTAINERS - BLACKFIN EMAC DRIVER
Message-ID: <46bff906.gZXLWz7HNN88QHpa%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6afe57b..1db73be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -886,6 +886,7 @@ M:	bryan.wu@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/net/bfin_mac.*
 
 BLACKFIN RTC DRIVER
 P:	Mike Frysinger
