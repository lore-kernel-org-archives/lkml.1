Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271Ab0ANHSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0ANHSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645Ab0ANHRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:17:55 -0500
Received: from mail.perches.com ([173.55.12.10]:1172 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab0ANHN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:13:26 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/24] MAINTAINERS: IDE SUBSYSTEM - Add "Q" patchwork entry
Date: Wed, 13 Jan 2010 23:13:07 -0800
Message-Id: <7f74b205b911575c8b349ff0a65948e861ad63e1.1263452909.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263452908.git.joe@perches.com>
References: <cover.1263452908.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2e27c16..8258e66 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2683,6 +2683,7 @@ F:	drivers/scsi/ips.*
 IDE SUBSYSTEM
 M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-ide@vger.kernel.org
+Q:	http://patchwork.ozlabs.org/project/linux-ide/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git
 S:	Maintained
 F:	Documentation/ide/
-- 
1.6.6.rc0.57.gad7a

