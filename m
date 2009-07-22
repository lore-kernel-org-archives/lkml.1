Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZGVUzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZGVUzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZGVUzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:55:00 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:51053 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZGVUzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:55:00 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jul 2009 16:54:59 EDT
Message-ID: <4A677A27.30203@freemail.hu>
Date: Wed, 22 Jul 2009 22:44:23 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Trivial Patch Monkey <trivial@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gcov: fix typo in CONFIG_DEBUG_FS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32721; Body=2 Fuz1=2
	Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The correct name is CONFIG_DEBUG_FS, add the missing underscore.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.31-rc3/Documentation/gcov.txt.orig	2009-07-20 19:56:05.000000000 +0200
+++ linux-2.6.31-rc3/Documentation/gcov.txt	2009-07-21 22:53:20.000000000 +0200
@@ -47,7 +47,7 @@

 Configure the kernel with:

-        CONFIG_DEBUGFS=y
+        CONFIG_DEBUG_FS=y
         CONFIG_GCOV_KERNEL=y

 and to get coverage data for the entire kernel:
