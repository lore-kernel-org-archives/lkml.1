Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546Ab0AMV4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0AMV4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527Ab0AMV4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:56:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1128 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab0AMV4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:56:08 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] MAINTAINERS: Remove AMD GEODE F: arch/x86/kernel/geode_32.c
Date: Wed, 13 Jan 2010 13:56:03 -0800
Message-Id: <6f5ae0b70e7785b877a4006d18e9e61238d015f6.1263419518.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263419518.git.joe@perches.com>
References: <cover.1263419518.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c95d1e53ed89b75a4d7b68d1cbae4607b1479243 removed it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6914588..e461c0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -427,7 +427,6 @@ P:	Jordan Crouse
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
-F:	arch/x86/kernel/geode_32.c
 F:	drivers/char/hw_random/geode-rng.c
 F:	drivers/crypto/geode*
 F:	drivers/video/geode/
-- 
1.6.6.rc0.57.gad7a

