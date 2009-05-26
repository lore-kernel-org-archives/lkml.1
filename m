Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZEZJQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZEZJQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZEZJP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:15:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37411 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbZEZJP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:15:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 3/7] MAINTAINERS: update Blackfin items
Date: Tue, 26 May 2009 05:15:52 -0400
Message-Id: <1243329356-12644-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
References: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With Bryan Wu having moved on to another job, push the slack onto some
other ADI lackeys.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 MAINTAINERS |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 77cbfb1..7dd3475 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1132,16 +1132,16 @@ F:	fs/bfs/
 F:	include/linux/bfs_fs.h
 
 BLACKFIN ARCHITECTURE
-P:	Bryan Wu
-M:	cooloney@kernel.org
+P:	Mike Frysinger
+M:	vapier@gentoo.org
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	arch/blackfin/
 
 BLACKFIN EMAC DRIVER
-P:	Bryan Wu
-M:	cooloney@kernel.org
+P:	Michael Hennerich
+M:	michael.hennerich@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
-- 
1.6.3.1

