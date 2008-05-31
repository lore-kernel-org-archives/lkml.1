Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYEaA57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYEaA57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYEaA5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:57:51 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47539 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751484AbYEaA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:57:51 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Randy Dunlap" <rdunlap@xenotime.net>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 30 May 2008 17:57:49 -0700
Message-Id: <20080531005749.2232.66620.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH v2] doc: document the kernel-doc conventions for kernel hackers grammar fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 Documentation/kernel-doc-nano-HOWTO.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.orig/Documentation/kernel-doc-nano-HOWTO.txt	2008-05-30 17:54:54.508884185 -0700
+++ linux-2.6/Documentation/kernel-doc-nano-HOWTO.txt	2008-05-30 17:54:54.868890267 -0700
@@ -4,14 +4,14 @@ kernel-doc nano-HOWTO
 How to format kernel-doc comments
 ---------------------------------
 
-In order to provide an embedded, 'C' friendly, easy to maintain,
+In order to provide embedded, 'C' friendly, easy to maintain,
 but consistent and extractable documentation of the functions and
 data structures in the Linux kernel, the Linux kernel has adopted
 a consistent style for documenting functions and their parameters,
 and structures and their members.
 
 The format for this documentation is called the kernel-doc format.
-It as documented in this Documentation/kernel-doc-nano-HOWTO.txt file.
+It is documented in this Documentation/kernel-doc-nano-HOWTO.txt file.
 
 This style embeds the documentation within the source files, using
 a few simple conventions.  The scripts/kernel-doc perl script, some

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
