Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYLJMKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYLJMKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYLJMKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:10:00 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:60479 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYLJMJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:09:59 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: [PATCH 1/1] MAINTAINERS: mark linux-uvc-devel as subscribers only
Date: Wed, 10 Dec 2008 13:09:27 +0100
Message-Id: <1228910967-25548-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Posting to linux-uvc-devel is restricted to members.
You can subscribe to the list at ...

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>
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

