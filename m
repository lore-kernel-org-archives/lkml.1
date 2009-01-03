Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbZACH7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbZACH7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZACH7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:59:11 -0500
Received: from vps1.tull.net ([66.180.172.116]:37936 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750767AbZACH7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:59:10 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 09/11] Fix misspelling of "firmware" in usb.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:58:37 +1100
Message-ID: <20090103075827.27466.74555.stgit@marcab.local>
In-Reply-To: <20090103074923.27466.7287.stgit@marcab.local>
References: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of "firmware" in usb.c

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/uwb/i1480/dfu/usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/uwb/i1480/dfu/usb.c b/drivers/uwb/i1480/dfu/usb.c
index 98eeeff..56d2353 100644
--- a/drivers/uwb/i1480/dfu/usb.c
+++ b/drivers/uwb/i1480/dfu/usb.c
@@ -414,7 +414,7 @@ int i1480_usb_probe(struct usb_interface *iface, const struct usb_device_id *id)
 		goto error_create;
 	}
 
-	/* setup the fops and upload the firmare */
+	/* setup the fops and upload the firmware */
 	i1480->pre_fw_name = "i1480-pre-phy-0.0.bin";
 	i1480->mac_fw_name = "i1480-usb-0.0.bin";
 	i1480->mac_fw_name_deprecate = "ptc-0.0.bin";

