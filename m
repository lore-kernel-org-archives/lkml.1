Return-Path: <linux-kernel-owner+w=401wt.eu-S1764023AbYFTU2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764023AbYFTU2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbYFTUU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:20:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35203 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761347AbYFTUUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:20:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 37/70] funsoft: Switch to linux/uaccess
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:02:56 +0100
Message-ID: <20080620200253.1479.49914.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/funsoft.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/funsoft.c b/drivers/usb/serial/funsoft.c
index e8ba2cb..d30f736 100644
--- a/drivers/usb/serial/funsoft.c
+++ b/drivers/usb/serial/funsoft.c
@@ -14,7 +14,7 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static int debug;
 

