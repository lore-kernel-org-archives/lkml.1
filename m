Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbZGMVQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbZGMVQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZGMVPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:15:08 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4009 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbZGMVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:04 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 03/16] MAINTAINERS: QLGE 10Gb ETHERNET - pair P:/M: entries properly
Date: Mon, 13 Jul 2009 14:14:49 -0700
Message-Id: <5ee46df5c79e964cf24d16d4fcb52679d35e554f.1247517374.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ff4cd3b..d8ade8d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4813,8 +4813,8 @@ F:	drivers/net/qla3xxx.*
 
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

