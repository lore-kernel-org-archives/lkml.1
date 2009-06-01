Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZFAHiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZFAHiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZFAHh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:37:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:37186 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZFAHh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=mjhIRsxuTNvILSpIy3MGwQRtNIAbc7pAJw8mxtclqRGllmSrsNb24Dw03ePmcy6uQ9
         Dpfvo+6dyiMjqmnF7tOsa6hH72x9VNrMXQPyen/wXdfeW+xUpF1JXSUyNFYS/NI3Majn
         01eObao92he/bVPRLQNrBKZ7jcExjzfMto5QE=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 1 Jun 2009 09:37:54 +0200
Subject: [PATCH] MAINTAINERS: take maintainership of the cpmac Ethernet driver
MIME-Version: 1.0
X-Length: 1358
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906010937.55673.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, David,

Not sure who is going to take this patch, therefore I am sending it
to both of you. Thanks.
--
From: Florian Fainelli <florian@openwrt.org>
Subject: [PATCH] MAINTAINERS: take maintainership of the cpmac Ethernet driver

This patch adds me as the maintainer of the CPMAC (AR7)
Ethernet driver.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 77f277e..e18baa4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1545,6 +1545,13 @@ W:	http://www.fi.muni.cz/~kas/cosa/
 S:	Maintained
 F:	drivers/net/wan/cosa*
 
+CPMAC ETHERNET DRIVER
+P:	Florian Fainelli
+M:	florian@openwrt.org
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/cpmac.c
+
 CPU FREQUENCY DRIVERS
 P:	Dave Jones
 M:	davej@redhat.com
