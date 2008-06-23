Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYFWDM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYFWDM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYFWDMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:12:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56824 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbYFWDMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:12:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: hjk@linutronix.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] uio-howto.tmpl: use standard copyright/legal markings
Date: Sun, 22 Jun 2008 23:12:42 -0400
Message-Id: <1214190762-26974-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Userspace I/O HOWTO document uses straight <sect1> tags and plain text
to describe copyright/legal information.  It should instead use the
<copyright> and <legalnotice> tags like all other documents in the kernel.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/DocBook/uio-howto.tmpl |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index fdd7f4f..3da4855 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -21,6 +21,18 @@
     </affiliation>
 </author>
 
+<copyright>
+	<year>2006</year>
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
@@ -60,17 +72,6 @@
 <?dbhtml filename="about.html"?>
 <title>About this document</title>
 
-<sect1 id="copyright">
-<?dbhtml filename="copyright.html"?>
-<title>Copyright and License</title>
-<para>
-      Copyright (c) 2006 by Hans-Jürgen Koch.</para>
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
1.5.5.3

