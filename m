Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbYLVMQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbYLVMQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYLVMQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:16:19 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:40432 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbYLVMQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:16:18 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] MAINTAINERS: mark linux-uvc-devel as subscribers only
Date: Mon, 22 Dec 2008 13:14:56 +0100
Message-Id: <1229948096-5254-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1228767934-14193-1-git-send-email-jirislaby@gmail.com>
References: <1228767934-14193-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Posting to linux-uvc-devel is restricted to members.
You can subscribe to the list at ...

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d7de513..ec5a7c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4571,7 +4571,7 @@ S:	Maintained
 USB VIDEO CLASS
 P:	Laurent Pinchart
 M:	laurent.pinchart@skynet.be
-L:	linux-uvc-devel@lists.berlios.de
+L:	linux-uvc-devel@lists.berlios.de (subscribers-only)
 L:	video4linux-list@redhat.com
 W:	http://linux-uvc.berlios.de
 S:	Maintained
-- 
1.6.0.5

