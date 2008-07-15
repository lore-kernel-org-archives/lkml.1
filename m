Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYGOR2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYGOR2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGOR2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:28:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50050 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYGOR2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:28:17 -0400
Date: Tue, 15 Jul 2008 13:28:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: maintainer
Message-ID: <Pine.LNX.4.58.0807151326220.12619@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm willing to take responsibility for ftrace, and follow up on any
issues that arise due to it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

Index: linus.git/MAINTAINERS
===================================================================
--- linus.git.orig/MAINTAINERS	2008-07-14 18:02:05.000000000 -0400
+++ linus.git/MAINTAINERS	2008-07-15 13:06:50.000000000 -0400
@@ -1770,6 +1770,11 @@ M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained

+FTRACE
+P:	Steven Rostedt
+M:	srostedt@redhat.com
+S:	Maintained
+
 FUJITSU FR-V (FRV) PORT
 P:	David Howells
 M:	dhowells@redhat.com

