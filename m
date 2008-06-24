Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYFXKyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYFXKyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYFXKyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:54:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55790 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbYFXKyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:54:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: hjk@linutronix.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] uio-howto.tmpl: use standard copyright/legal markings
Date: Tue, 24 Jun 2008 06:54:37 -0400
Message-Id: <1214304877-1223-1-git-send-email-vapier@gentoo.org>
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
1.5.5.3

