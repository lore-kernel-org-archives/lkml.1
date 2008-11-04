Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYKDGN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYKDGN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYKDGKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:10:22 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:48392 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbYKDGKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:10:03 -0500
Message-Id: <20081104060959.801690897@nttdata.co.jp>
References: <20081104060847.086543472@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Tue, 04 Nov 2008 15:08:58 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Toshiharu Harada <haradats@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>
Subject: [TOMOYO #12 (2.6.28-rc2-mm1) 11/11] MAINTAINERS info
X-OriginalArrivalTime: 04 Nov 2008 06:10:00.0926 (UTC) FILETIME=[F87A37E0:01C93E43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The archive of tomoyo-users-en mailing list is available at
http://lists.sourceforge.jp/mailman/archives/tomoyo-users-en/ .
Mailing lists for Japanese users are at
http://lists.sourceforge.jp/mailman/archives/tomoyo-users/ and
http://lists.sourceforge.jp/mailman/archives/tomoyo-dev/ .

TOMOYO Linux English portal is at
http://elinux.org/TomoyoLinux .

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
---
 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- linux-2.6.28-rc2-mm1.orig/MAINTAINERS
+++ linux-2.6.28-rc2-mm1/MAINTAINERS
@@ -4130,6 +4130,19 @@ L:	tlan-devel@lists.sourceforge.net (sub
 W:	http://sourceforge.net/projects/tlan/
 S:	Maintained
 
+TOMOYO SECURITY MODULE
+P:	Kentaro Takeda
+M:	takedakn@nttdata.co.jp
+P:	Tetsuo Handa
+M:	penguin-kernel@I-love.SAKURA.ne.jp
+L:	linux-kernel@vger.kernel.org (kernel issues)
+L:	tomoyo-users-en@lists.sourceforge.jp (subscribers-only, for developers and users in English)
+L:	tomoyo-dev@lists.sourceforge.jp (subscribers-only, for developers in Japanese)
+L:	tomoyo-users@lists.sourceforge.jp (subscribers-only, for users in Japanese)
+W:	http://tomoyo.sourceforge.jp/
+T:	quilt http://svn.sourceforge.jp/svnroot/tomoyo/trunk/2.2.x/tomoyo-lsm/patches/
+S:	Maintained
+
 TOSHIBA ACPI EXTRAS DRIVER
 P:	John Belmonte
 M:	toshiba_acpi@memebeam.org

--

