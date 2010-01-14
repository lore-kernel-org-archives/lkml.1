Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132Ab0ANHRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0ANHRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984Ab0ANHQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:16:15 -0500
Received: from mail.perches.com ([173.55.12.10]:1176 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308Ab0ANHN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:13:26 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/24] MAINTAINERS: KCONFIG - Add "Q" patchwork entry
Date: Wed, 13 Jan 2010 23:13:10 -0800
Message-Id: <3cc6cc37ac3ae472bd04ec67b9a6cf59b429dd26.1263452909.git.joe@perches.com>
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
index 8c7505e..33dad05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3066,6 +3066,7 @@ F:	drivers/hwmon/k8temp.c
 KCONFIG
 M:	Roman Zippel <zippel@linux-m68k.org>
 L:	linux-kbuild@vger.kernel.org
+Q:	http://patchwork.kernel.org/project/linux-kbuild/list/
 S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
-- 
1.6.6.rc0.57.gad7a

