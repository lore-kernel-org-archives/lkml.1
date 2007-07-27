Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbXG0AET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbXG0AET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXG0AEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:04:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14051 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbXG0AEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:04:09 -0400
Date: Thu, 26 Jul 2007 17:08:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: use relevant mailing lists
Message-Id: <20070726170857.dbb42674.randy.dunlap@oracle.com>
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

Add text on using relevant mailing lists.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- linux-2623-rc1g2.orig/MAINTAINERS
+++ linux-2623-rc1g2/MAINTAINERS
@@ -23,15 +23,18 @@ trivial patch so apply some common sense
 4.	When you are happy with a change make it generally available for
 	testing and await feedback.
 
-5.	Make a patch available to the relevant maintainer in the list. Use
-	'diff -u' to make the patch easy to merge. Be prepared to get your
-	changes sent back with seemingly silly requests about formatting
-	and variable names.  These aren't as silly as they seem. One
-	job the maintainers (and especially Linus) do is to keep things
+5.	Make a patch available to the relevant maintainer(s) and mailing
+	list(s). Use 'diff -u' to make the patch easy to merge. Be prepared
+	to get your changes sent back with seemingly silly requests about
+	formatting and variable names.  These aren't as silly as they seem.
+	One job the maintainers (and especially Linus) do is to keep things
 	looking the same. Sometimes this means that the clever hack in
 	your driver to get around a problem actually needs to become a
 	generalized kernel feature ready for next time.
 
+	Use the relevant mailing list(s) -- don't just send everything to
+	lkml (linux-kernel@vger.kernel.org).
+
 	PLEASE check your patch with the automated style checker
 	(scripts/checkpatch.pl) to catch trival style violations.
 	See Documentation/CodingStyle for guidance here.
