Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbYDZV3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbYDZV3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbYDZV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:28:14 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:47997 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbYDZV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:28:12 -0400
From: Bob Copeland <me@bobcopeland.com>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, alan@lxorguk.ukuu.org.uk, miklos@szeredi.hu,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 8/8] omfs: add MAINTAINERS entry
Date: Sat, 26 Apr 2008 17:26:45 -0400
Message-Id: <1209245205-10096-9-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    omfs: add MAINTAINERS entry
    
    Add the MAINTAINERS entry for OMFS.
    
    Signed-off-by: Bob Copeland <me@bobcopeland.com>

---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS	2008-04-26 15:33:32.000000000 -0400
+++ linux-2.6/MAINTAINERS	2008-04-26 15:34:08.000000000 -0400
@@ -2980,6 +2980,12 @@
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
 S:	Supported
 
+OMFS FILESYSTEM
+P:	Bob Copeland
+M:	me@bobcopeland.com
+L:	linux-karma-devel@lists.sourceforge.net
+S:	Maintained
+
 OMNIKEY CARDMAN 4000 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org

