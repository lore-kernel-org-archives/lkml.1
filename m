Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568Ab0AMV5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0AMV5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494Ab0AMV4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:56:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1130 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab0AMV4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:56:08 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] MAINTAINERS: Remove HAYES ESP SERIAL DRIVER
Date: Wed, 13 Jan 2010 13:56:04 -0800
Message-Id: <1e3d9e25bef4db66aeeef48395d76d9205b3922c.1263419518.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263419518.git.joe@perches.com>
References: <cover.1263419518.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f53a2ade0bb9f2a81f473e6469155172a96b7c38 removed it

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e461c0a..5747aaf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2469,13 +2469,6 @@ L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/parisc/harmony.*
 
-HAYES ESP SERIAL DRIVER
-M:	"Andrew J. Robinson" <arobinso@nyx.net>
-W:	http://www.nyx.net/~arobinso
-S:	Maintained
-F:	Documentation/serial/hayes-esp.txt
-F:	drivers/char/esp.c
-
 HEWLETT-PACKARD SMART2 RAID DRIVER
 M:	Chirag Kantharia <chirag.kantharia@hp.com>
 L:	iss_storagedev@hp.com
-- 
1.6.6.rc0.57.gad7a

