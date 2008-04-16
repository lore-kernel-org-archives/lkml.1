Return-Path: <linux-kernel-owner+w=401wt.eu-S1765482AbYDPUvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765482AbYDPUvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYDPUvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:51:07 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:6849 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYDPUvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:51:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Rd8k9gSOAfqjnhTeQq2v/crvE4qAaV12vNnKj/K4WDgL5/YdysabMFoUqwx7231wn2BtpVaYuXC19hRG8eYW8EQEEuBW0Ysn5Yadr4JaJ86MVbaw6OUyfZDeFoNAf/uttiomNjHT8WO77o1yI/HBQyYeBCozKh23sLpyeVRnQvQ=
Date: Wed, 16 Apr 2008 22:50:57 +0200
From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH -mm 1/3] misc,acpi,backlight: Compal Laptop Extras - add
 entry to MAINTAINERS
Message-ID: <20080416225057.57b8c25b@debian>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>

Add me to MAINTAINERS

Signed-off-by: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
---
diff -Nuar a/MAINTAINERS b/MAINTAINERS
--- a/MAINTAINERS	2008-04-16 19:42:42.000000000 +0200
+++ b/MAINTAINERS	2008-04-16 19:49:49.000000000 +0200
@@ -1137,6 +1137,11 @@
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
 
+COMPAL LAPTOP SUPPORT
+P:	Cezary Jackiewicz
+M:	cezary.jackiewicz@gmail.com
+S:	Maintained
+
 COMPUTONE INTELLIPORT MULTIPORT CARD
 P:	Michael H. Warfield
 M:	mhw@wittsend.com
