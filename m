Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbXBEFpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbXBEFpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 00:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbXBEFpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 00:45:46 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:27483 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbXBEFpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 00:45:45 -0500
Date: Sun, 4 Feb 2007 21:41:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: airlied@linux.ie, akpm <akpm@osdl.org>
Subject: [PATCH] note that dri-devel is subscribers-only
Message-Id: <20070204214119.1a32dbcd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

dri-devel is subscribers-only, so note that in MAINTAINERS.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2620-pv.orig/MAINTAINERS
+++ linux-2620-pv/MAINTAINERS
@@ -1126,7 +1126,7 @@ S:	Supported
 DRM DRIVERS
 P:	David Airlie
 M:	airlied@linux.ie
-L:	dri-devel@lists.sourceforge.net
+L:	dri-devel@lists.sourceforge.net (subscribers-only)
 T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 
