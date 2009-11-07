Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZKGSul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZKGSul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 13:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZKGSuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 13:50:40 -0500
Received: from mail.perches.com ([173.55.12.10]:1255 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbZKGSu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 13:50:27 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: Correct SECURITY SUBSYSTEM git entry
Date: Sat,  7 Nov 2009 10:50:31 -0800
Message-Id: <70b6f4e806fe816cc7cbf46fa6a80482d12bb64a.1257618926.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f
In-Reply-To: <cover.1257618926.git.joe@perches.com>
References: <cover.1257618926.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use git.kernel.org not www.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 53f416a..3e028b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4636,7 +4636,7 @@ F:	drivers/mmc/host/sdhci-s3c.c
 SECURITY SUBSYSTEM
 M:	James Morris <jmorris@namei.org>
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
-T:	git git://www.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 W:	http://security.wiki.kernel.org/
 S:	Supported
 F:	security/
-- 
1.6.5.1.65.gc2fd

