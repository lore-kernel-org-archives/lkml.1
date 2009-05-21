Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbZEUR41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbZEUR41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 13:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZEUR4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 13:56:20 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:62265 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZEUR4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 13:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=JR1zoqZD3CxYSq314ndA/IGLuEntWhaYsPOvPtYg1aBEAjxP5EJQtWwqc95fBuf7z3
         1pqDPtAt3EkzRyFijR0Mxtn5H0GrJBIvFT1cr95FNZkRPCxXGGGP+Ip1VgR5VyQ97TY/
         zAYUg7t6alRpEG+5ylcAAQhir5iIEDD5hBcDk=
From: Alessio Igor Bogani <abogani@texware.it>
To: Daniel Mack <daniel@caiaq.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] misc: Fix typo in Kconfig
Date: Thu, 21 May 2009 19:54:33 +0200
Message-Id: <1242928473-5633-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <alpine.LNX.2.00.0904151200400.13028@wotan.suse.de>
References: <alpine.LNX.2.00.0904151200400.13028@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/input/misc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 5c0a631..06f46fc 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -232,7 +232,7 @@ config INPUT_GPIO_ROTARY_ENCODER
 	depends on GPIOLIB && GENERIC_GPIO
 	help
 	  Say Y here to add support for rotary encoders connected to GPIO lines.
-	  Check file:Documentation/incput/rotary_encoder.txt for more
+	  Check file:Documentation/input/rotary-encoder.txt for more
 	  information.
 
 	  To compile this driver as a module, choose M here: the
-- 
1.6.0.4

