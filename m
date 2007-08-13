Return-Path: <linux-kernel-owner+w=401wt.eu-S971305AbXHMJKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971305AbXHMJKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966845AbXHMGbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:37 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4993 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966940AbXHMGbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:31 -0400
Date: Sun, 12 Aug 2007 23:31:18 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, olof@lixom.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [296/2many] MAINTAINERS - LINUX FOR POWERPC PA SEMI
 PWRFICIENT
Message-ID: <46bffab6.9F8kfme4utaitNZV%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a289176..6fdca8b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2837,6 +2837,7 @@ M:	olof@lixom.net
 W:	http://www.pasemi.com/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
+F:	arch/powerpc/platforms/pasemi/
 
 LLC (802.2)
 P:	Arnaldo Carvalho de Melo
