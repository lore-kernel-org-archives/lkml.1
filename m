Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYIKPBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYIKPBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYIKPAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:00:53 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:40617 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYIKPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=O1gIw/Kpw+0TOP921xWSM0R9CCU5HcRUPmIJSHRaMJrJMnrx577XKO/OmrvJlwN5Qu
         1Yin/TroNT3hX01bKzag44ah3J42ssj/ykm6j+X1FLLhKH8x8gmns9Tl3VBDWN3zCgvn
         EozyuGkhlIWT0lKSbJ9oI2iZ4cjvacS5TEtKY=
From: tom.leiming@gmail.com
To: laurent.pinchart@skynet.be, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] MAINTAINERS:fix USB VIDEO CLASS mail list address
Date: Thu, 11 Sep 2008 23:01:35 +0800
Message-Id: <1221145295-8936-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.5.6.rc2.45.gdc92c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

It should be linux-uvc-devel@lists.berlios.de.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index af27945..7e0b0be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4363,7 +4363,7 @@ S:	Maintained
 USB VIDEO CLASS
 P:	Laurent Pinchart
 M:	laurent.pinchart@skynet.be
-L:	linx-uvc-devel@berlios.de
+L:	linux-uvc-devel@lists.berlios.de
 L:	video4linux-list@redhat.com
 W:	http://linux-uvc.berlios.de
 S:	Maintained
-- 
1.5.6.rc2.45.gdc92c

