Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZBEJFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZBEJFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZBEJEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:04:40 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:53381 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZBEJEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:04:38 -0500
Message-Id: <20090205082235.917519942@nttdata.co.jp>
References: <20090205081810.331987920@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Thu, 05 Feb 2009 17:18:18 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp,
       Kentaro Takeda <takedakn@nttdata.co.jp>
Subject: [TOMOYO #15 8/8] MAINTAINERS info
X-OriginalArrivalTime: 05 Feb 2009 08:22:37.0073 (UTC) FILETIME=[E720A810:01C9876A]
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

--- security-testing-2.6.git.orig/MAINTAINERS
+++ security-testing-2.6.git/MAINTAINERS
@@ -4257,6 +4257,19 @@ L:	tlan-devel@lists.sourceforge.net (sub
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

