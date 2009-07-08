Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZGHF4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZGHF4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZGHFzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:55:51 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3005 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZGHFzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:55:50 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/7] MAINTAINERS: QLGE 10Gb ETHERNET - pair P:/M: entries properly
Date: Tue,  7 Jul 2009 22:55:41 -0700
Message-Id: <bbe668cdb70826ff825c2fd7fcff1b4fc544c113.1247032324.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247032324.git.joe@perches.com>
References: <cover.1247032324.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bfb4c43..888996d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4810,8 +4810,8 @@ F:	drivers/net/qla3xxx.*
 
 QLOGIC QLGE 10Gb ETHERNET DRIVER
 P:	Ron Mercer
-M:	linux-driver@qlogic.com
 M:	ron.mercer@qlogic.com
+M:	linux-driver@qlogic.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/qlge/
-- 
1.6.3.1.10.g659a0.dirty

