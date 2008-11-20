Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYKTLm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYKTLm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbYKTLm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:42:28 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:61963 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbYKTLm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:42:26 -0500
Message-Id: <20081120112736.093415566@I-love.SAKURA.ne.jp>
References: <20081120112543.799450455@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 20:25:54 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>
Subject: [TOMOYO #13 (mmotm 2008-11-19-02-19) 11/11] MAINTAINERS info
Content-Disposition: inline; filename=tomoyo-maintainers.patch
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

--- linux-2.6.28-rc5-mm1.orig/MAINTAINERS
+++ linux-2.6.28-rc5-mm1/MAINTAINERS
@@ -4193,6 +4193,19 @@ L:	tlan-devel@lists.sourceforge.net (sub
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
