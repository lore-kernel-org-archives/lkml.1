Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYDSUjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYDSUjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 16:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbYDSUjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 16:39:01 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:44831 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbYDSUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 16:38:58 -0400
From: Bob Copeland <me@bobcopeland.com>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, alan@lxorguk.ukuu.org.uk, miklos@szeredi.hu,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 8/8] omfs: add MAINTAINERS entry
Date: Sat, 19 Apr 2008 16:37:37 -0400
Message-Id: <1208637457-24969-9-git-send-email-me@bobcopeland.com>
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
--- linux-2.6.orig/MAINTAINERS	2008-04-19 12:55:43.000000000 -0400
+++ linux-2.6/MAINTAINERS	2008-04-19 12:55:56.000000000 -0400
@@ -2959,6 +2959,12 @@
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

