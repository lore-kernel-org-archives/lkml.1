Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030483Ab0B0Q4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:56:49 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030401Ab0B0Q4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=bECSl7RvcUvT5Swh0mUqdvdBwLOMKEtHLTXvyZYWUJoV1511qM0MotrlCSYyqLDGqd
         AKcvm+OGvvYc7mWGtxhRHYkrIsJ5gUEr+Sd4O4SyMbWNu8kT0Fp61dAy7R/IREyNK9mB
         ubBqXtnfFcEeX8GgUITvUOwVIx2fDDFAXEX3M=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 46/66] drivers/isdn/hardware/eicon/os_bri.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:27 +0100
Message-Id: <1267289508-31031-47-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/hardware/eicon/os_bri.h:6: ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/isdn/hardware/eicon/os_bri.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/os_bri.h b/drivers/isdn/hardware/eicon/os_bri.h
index a54f0ce..02e7456 100644
--- a/drivers/isdn/hardware/eicon/os_bri.h
+++ b/drivers/isdn/hardware/eicon/os_bri.h
@@ -3,6 +3,6 @@
 #ifndef __DIVA_OS_BRI_REV_1_H__
 #define __DIVA_OS_BRI_REV_1_H__
 
-int diva_bri_init_card(diva_os_xdi_adapter_t * a);
+int diva_bri_init_card(diva_os_xdi_adapter_t *a);
 
 #endif
-- 
1.7.0.90.g251a4

