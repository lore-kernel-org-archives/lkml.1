Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbYE3F23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbYE3F23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYE3F2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:28:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42258 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755541AbYE3F2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:28:07 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Juan-Mariano de Goyeneche" <jmseyas@dit.upm.es>,
       "Randy Dunlap" <rdunlap@xenotime.net>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 29 May 2008 22:28:06 -0700
Message-Id: <20080530052806.125355.58257.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH - right file this time] doc: Update to URL and status of kernel-docs.txt entry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Update status and URL for the "Gary's Encyclopedia" entry.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 Documentation/kernel-docs.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.orig/Documentation/kernel-docs.txt	2007-12-18 20:38:50.000000000 -0800
+++ linux-2.6/Documentation/kernel-docs.txt	2008-05-29 21:55:28.488134402 -0700
@@ -715,14 +715,14 @@
 
      * Name: "Gary's Encyclopedia - The Linux Kernel"
        Author: Gary (I suppose...).
-       URL: http://www.lisoleg.net/cgi-bin/lisoleg.pl?view=kernel.htm
-       Keywords: links, not found here?.
+       URL: http://slencyclopedia.berlios.de/index.html
+       Keywords: linux, community, everything!
        Description: Gary's Encyclopedia exists to allow the rapid finding
        of documentation and other information of interest to GNU/Linux
        users. It has about 4000 links to external pages in 150 major
        categories. This link is for kernel-specific links, documents,
-       sites... Look there if you could not find here what you were
-       looking for.
+       sites...  This list is now hosted by developer.Berlios.de,
+       but seems not to have been updated since sometime in 1999.
 
      * Name: "The home page of Linux-MM"
        Author: The Linux-MM team.

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
