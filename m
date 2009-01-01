Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZAAFXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZAAFXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 00:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZAAFVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 00:21:05 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:58417 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZAAFUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 00:20:48 -0500
Message-Id: <20090101050943.038428461@I-love.SAKURA.ne.jp>
References: <20090101050741.372438529@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 2009 14:07:51 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>
Subject: [TOMOYO #14 (mmotm 2008-12-30-16-05) 10/10] MAINTAINERS info
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

--- linux-2.6.28-mm1.orig/MAINTAINERS
+++ linux-2.6.28-mm1/MAINTAINERS
@@ -4251,6 +4251,19 @@ L:	tlan-devel@lists.sourceforge.net (sub
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
