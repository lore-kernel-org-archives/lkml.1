Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001Ab0AJJDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0AJJDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 04:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807Ab0AJJDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 04:03:22 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:38608 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab0AJJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 04:03:20 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH 1/1] MAINTAINERS: ivtv-devel is moderated
Date: Sun, 10 Jan 2010 10:03:17 +0100
Message-Id: <1263114197-8476-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark ivtv-devel@ivtvdriver.org as 'moderated for non-subscribers'.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linux-media@vger.kernel.org
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d4baf3d..6f088ac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1649,7 +1649,7 @@ F:	sound/pci/cs5535audio/
 CX18 VIDEO4LINUX DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 M:	Andy Walls <awalls@radix.net>
-L:	ivtv-devel@ivtvdriver.org
+L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://linuxtv.org
@@ -3037,7 +3037,7 @@ F:	drivers/isdn/hardware/eicon/
 
 IVTV VIDEO4LINUX DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
-L:	ivtv-devel@ivtvdriver.org
+L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.ivtvdriver.org
-- 
1.6.5.7

