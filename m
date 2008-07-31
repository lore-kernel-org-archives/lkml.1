Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYGaQlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYGaQlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYGaQkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:40:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYGaQky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:40:54 -0400
Date: Thu, 31 Jul 2008 12:40:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, greg@kroah.com,
       Chris Wright <chrisw@sous-sol.org>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] dual license ftrace.txt
In-Reply-To: <20080731093039.4afcb734@bike.lwn.net>
Message-ID: <alpine.DEB.1.10.0807311231290.5490@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0807302256180.21982@gandalf.stny.rr.com> <20080731093039.4afcb734@bike.lwn.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I asked legal about the licensing of ftrace.txt, and they told me that, 
unless the Documentation directory is specifically set up to handle non 
GPL licenses (which it does not appear to be), then it would be best to 
put ftrace.txt under the GPL.

This patch adds a dual license to ftrace.txt such that it is under both 
the FDL and the GPL.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/ftrace.txt |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.26/Documentation/ftrace.txt
===================================================================
--- linux-2.6.26.orig/Documentation/ftrace.txt	2008-07-31 12:29:23.000000000 -0400
+++ linux-2.6.26/Documentation/ftrace.txt	2008-07-31 12:31:04.000000000 -0400
@@ -4,6 +4,7 @@
 Copyright 2008 Red Hat Inc.
    Author:   Steven Rostedt <srostedt@redhat.com>
   License:   The GNU Free Documentation License, Version 1.2
+               (dual licensed under the GPL v2)
 Reviewers:   Elias Oltmanns, Randy Dunlap, Andrew Morton,
 	     John Kacur, and David Teigland.
 


