Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYJTHlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYJTHlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYJTHhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:37:35 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:51733 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYJTHhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:37:09 -0400
Message-Id: <20081020073702.071053175@nttdata.co.jp>
References: <20081020073423.024299308@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Mon, 20 Oct 2008 16:34:34 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kentaro Takeda <takedakn@nttdata.co.jp>
Subject: [TOMOYO #11 (linux-next) 11/11] MAINTAINERS info
X-OriginalArrivalTime: 20 Oct 2008 07:37:07.0050 (UTC) FILETIME=[A74B34A0:01C93286]
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

--- linux-next.orig/MAINTAINERS
+++ linux-next/MAINTAINERS
@@ -4110,6 +4110,19 @@ L:	tlan-devel@lists.sourceforge.net (sub
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

