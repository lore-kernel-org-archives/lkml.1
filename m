Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYGVFnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYGVFnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbYGVFZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:54095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565AbYGVFZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 64/79] uio-howto.tmpl: use standard copyright/legal markings
Date: Mon, 21 Jul 2008 22:19:28 -0700
Message-Id: <1216703983-21448-64-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

The Userspace I/O HOWTO document uses straight <sect1> tags and plain text
to describe copyright/legal information.  It should instead use the
<copyright> and <legalnotice> tags like all other documents in the kernel.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/uio-howto.tmpl |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index c4d1873..d799a26 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -21,6 +21,18 @@
     </affiliation>
 </author>
 
+<copyright>
+	<year>2006-2008</year>
+	<holder>Hans-Jürgen Koch.</holder>
+</copyright>
+
+<legalnotice>
+<para>
+This documentation is Free Software licensed under the terms of the
+GPL version 2.
+</para>
+</legalnotice>
+
 <pubdate>2006-12-11</pubdate>
 
 <abstract>
@@ -66,17 +78,6 @@
 <?dbhtml filename="about.html"?>
 <title>About this document</title>
 
-<sect1 id="copyright">
-<?dbhtml filename="copyright.html"?>
-<title>Copyright and License</title>
-<para>
-      Copyright (c) 2006-2008 by Hans-Jürgen Koch.</para>
-<para>
-This documentation is Free Software licensed under the terms of the
-GPL version 2.
-</para>
-</sect1>
-
 <sect1 id="translations">
 <?dbhtml filename="translations.html"?>
 <title>Translations</title>
-- 
1.5.6.3

