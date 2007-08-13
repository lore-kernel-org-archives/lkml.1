Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbXHMKG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbXHMKG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967148AbXHMGeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1513 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966511AbXHMGeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:14 -0400
Date: Sun, 12 Aug 2007 23:33:52 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-abi-devel@lists.sourceforge.net, hch@infradead.org,
       akpm@linux-foundation.org
Subject: [PATCH] [376/2many] MAINTAINERS - PERSONALITY HANDLING
Message-ID: <46bffb50.uWxNuHKqu6kdmXJR%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 05615e6..b81c8bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3614,6 +3614,7 @@ P:	Christoph Hellwig
 M:	hch@infradead.org
 L:	linux-abi-devel@lists.sourceforge.net
 S:	Maintained
+F:	include/linux/personality.h
 
 PHRAM MTD DRIVER
 P:	Jörn Engel
