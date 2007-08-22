Return-Path: <linux-kernel-owner+w=401wt.eu-S1764439AbXHVP0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764439AbXHVP0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761287AbXHVP0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:26:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:29849 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764125AbXHVP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:26:04 -0400
Date: Wed, 22 Aug 2007 08:24:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] MAINTTAINERS: update DCO info
Message-Id: <20070822082421.5c20b3da.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update URL for DCO (old URL is invalid).
Also, point to SubmittingPatches for the current DCO.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc3-git2.orig/MAINTAINERS
+++ linux-2.6.23-rc3-git2/MAINTAINERS
@@ -45,8 +45,11 @@ trivial patch so apply some common sense
 
 	PLEASE remember that submissions must be made under the terms
 	of the OSDL certificate of contribution
-	(http://www.osdl.org/newsroom/press_releases/2004/2004_05_24_dco.html)
+	(http://old.linux-foundation.org/newsroom/press_releases/2004/2004_05_24_dco.html)
 	and should include a Signed-off-by: line.
+	The current certificate is also documented in
+	Documentation/SubmittingPatches as the Developer's Certificate
+	of Origin (DCO).
 
 6.	Make sure you have the right to send any changes you make. If you
 	do changes at work you may find your employer owns the patch
