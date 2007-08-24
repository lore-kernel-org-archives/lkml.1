Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbXHXGwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbXHXGwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXHXGwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:52:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22452 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbXHXGwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:52:46 -0400
Date: Thu, 23 Aug 2007 23:50:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Joe Perches <joe@perches.com>, torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH v2] MAINTTAINERS: update DCO info
Message-Id: <20070823235043.ff1c5484.randy.dunlap@oracle.com>
In-Reply-To: <46CCC010.8070207@oracle.com>
References: <20070822082421.5c20b3da.randy.dunlap@oracle.com>
	<1187823476.24819.52.camel@localhost>
	<46CCC010.8070207@oracle.com>
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

Drop the URL for DCO (URL is invalid).
Also, point to SubmittingPatches for the current DCO.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc3-git6.orig/MAINTAINERS
+++ linux-2.6.23-rc3-git6/MAINTAINERS
@@ -44,9 +44,10 @@ trivial patch so apply some common sense
 	or does something very odd once a month document it.
 
 	PLEASE remember that submissions must be made under the terms
-	of the OSDL certificate of contribution
-	(http://www.osdl.org/newsroom/press_releases/2004/2004_05_24_dco.html)
-	and should include a Signed-off-by: line.
+	of the OSDL certificate of contribution and should include a
+	Signed-off-by: line.  The current version of this "Developer's
+	Certificate of Origin" (DCO) is listed in the file
+	Documentation/SubmittingPatches.
 
 6.	Make sure you have the right to send any changes you make. If you
 	do changes at work you may find your employer owns the patch
