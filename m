Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbYKCUTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbYKCUTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbYKCUS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:18:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42766 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbYKCUS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:18:58 -0500
Date: Mon, 3 Nov 2008 15:18:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace document version update
In-Reply-To: <alpine.DEB.1.10.0810311245160.22754@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811031518340.16323@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com> <20081026193339.91e0c644.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com> <20081031093152.efbb65c1.randy.dunlap@oracle.com>
 <alpine.DEB.1.10.0810311245160.22754@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Documentation update only
 
Update the version that the ftrace document was written for.
 
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/ftrace.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/Documentation/ftrace.txt
===================================================================
--- linux-tip.git.orig/Documentation/ftrace.txt	2008-10-31 12:44:28.000000000 -0400
+++ linux-tip.git/Documentation/ftrace.txt	2008-10-31 12:44:58.000000000 -0400
@@ -8,7 +8,7 @@ Copyright 2008 Red Hat Inc.
 Reviewers:   Elias Oltmanns, Randy Dunlap, Andrew Morton,
 	     John Kacur, and David Teigland.
 
-Written for: 2.6.27-rc1
+Written for: 2.6.28-rc2
 
 Introduction
 ------------
