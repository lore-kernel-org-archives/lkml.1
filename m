Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYIQAFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYIQAFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 20:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYIQAFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 20:05:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:48475 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbYIQAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 20:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=wPkPBrXNykEzjG2FEXJb+nkOI+ekQaLQc26hsUmJiZ+CVE4nC/b2Dq/DGbFPqL6K9h
         har9I6exYCJQjibjd82y2VfpWKcB/7PK2/DJw8lHxe99QsmSvzEwlgwBC0rkJN/wyKvp
         9crXgfJ39szod4cFG8an9yUe2WFbh4an9Xx7c=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Cc: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Fix typo in the FIRMWARE_IN_KERNEL help
Date: Tue, 16 Sep 2008 21:01:51 -0300
Message-Id: <1221609711-17615-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.0.87.g2858d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
drivers/base/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 6318f6b..d8e8c49 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -54,7 +54,7 @@ config FIRMWARE_IN_KERNEL
 	  such firmware, and do not wish to use an initrd.
 
 	  This single option controls the inclusion of firmware for
-	  every driver which usees request_firmare() and ships its
+	  every driver which uses request_firmare() and ships its
 	  firmware in the kernel source tree, to avoid a proliferation
 	  of 'Include firmware for xxx device' options.
 
-- 
1.6.0.87.g2858d

