Return-Path: <linux-kernel-owner+w=401wt.eu-S1031714AbXEHUzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031714AbXEHUzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031686AbXEHUzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:55:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28092 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031660AbXEHUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:55:03 -0400
Date: Tue, 8 May 2007 13:59:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jgarzik <jgarzik@pobox.com>
Subject: [PATCH] doc: what a patch series is
Message-Id: <20070508135922.a13a292d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Jeff:  would you update tpp.txt and patch-format.html
respectively to clarify this?  (I can send patches if you prefer that.)


From: Randy Dunlap <randy.dunlap@oracle.com>

It seems that we need to clarify that a patch series is a
series of related patches rather than "here are some of my
patches as multiple (numbered) emails."

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/SubmittingPatches |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.21-git10.orig/Documentation/SubmittingPatches
+++ linux-2.6.21-git10/Documentation/SubmittingPatches
@@ -363,7 +363,8 @@ area or subsystem of the kernel is being
 The "summary phrase" in the email's Subject should concisely
 describe the patch which that email contains.  The "summary
 phrase" should not be a filename.  Do not use the same "summary
-phrase" for every patch in a whole patch series.
+phrase" for every patch in a whole patch series (where a "patch
+series" is an ordered sequence of multiple, related patches).
 
 Bear in mind that the "summary phrase" of your email becomes
 a globally-unique identifier for that patch.  It propagates
