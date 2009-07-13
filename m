Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZGMVQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZGMVQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbZGMVPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:15:06 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4008 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbZGMVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:04 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/16] MAINTAINERS: Remove ivtv-user lists, add CX18 url
Date: Mon, 13 Jul 2009 14:14:48 -0700
Message-Id: <9d7d10ffd0e69e5b6e519d5c86682b03725c7dee.1247517374.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 326c07e..ff4cd3b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1721,10 +1721,10 @@ M:	hverkuil@xs4all.nl
 P:	Andy Walls
 M:	awalls@radix.net
 L:	ivtv-devel@ivtvdriver.org
-L:	ivtv-users@ivtvdriver.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://linuxtv.org
+W:	http://www.ivtvdriver.org/index.php/Cx18
 S:	Maintained
 F:	Documentation/video4linux/cx18.txt
 F:	drivers/media/video/cx18/
@@ -3276,7 +3276,6 @@ IVTV VIDEO4LINUX DRIVER
 P:	Hans Verkuil
 M:	hverkuil@xs4all.nl
 L:	ivtv-devel@ivtvdriver.org
-L:	ivtv-users@ivtvdriver.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.ivtvdriver.org
-- 
1.6.3.1.10.g659a0.dirty

