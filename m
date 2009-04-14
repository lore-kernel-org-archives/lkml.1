Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbZDNKek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbZDNKek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZDNKeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:34:31 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:54107 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZDNKeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Dsnm4O6OOwCfsdl/8ouUQYHBaOyfZFO2dD8U8ahz1sjYhrvFmuyzi342GPPhRHdk+d
         r6Mq6Pe9r9LPoJBB8yHOM1WnESzpb5GrFWxg9Dw8zhhBIIBRm+gpyeDmYg+i5mYCBhsi
         IRYtHXjYPOL2GrBYgvkMDjyswKn8fsCM9Q0eo=
From: Alessio Igor Bogani <abogani@texware.it>
To: Daniel Mack <daniel@caiaq.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Trivial <trivial@kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] misc: Fix typo in Kconfig
Date: Tue, 14 Apr 2009 12:34:22 +0200
Message-Id: <1239705262-6415-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/input/misc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 203abac..674f755 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -232,7 +232,7 @@ config INPUT_GPIO_ROTARY_ENCODER
 	depends on GPIOLIB && GENERIC_GPIO
 	help
 	  Say Y here to add support for rotary encoders connected to GPIO lines.
-	  Check file:Documentation/incput/rotary_encoder.txt for more
+	  Check file:Documentation/input/rotary_encoder.txt for more
 	  information.
 
 	  To compile this driver as a module, choose M here: the
-- 
1.6.0.4

