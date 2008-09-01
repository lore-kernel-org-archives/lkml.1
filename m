Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYIAUFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYIAUFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYIAUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:05:46 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:36494 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbYIAUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:05:45 -0400
Message-ID: <48BC4B0A.7090601@euromail.se>
Date: Mon, 01 Sep 2008 22:05:30 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: akpm@osdl.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] input: Cleanup for new scripts/checkpatch.pl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.39.57
X-Scan-Result: No virus found in message 1KaFeh-0002C3-9R.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KaFeh-0002C3-9R a98fe00a7809402fdfad3935e5ea650a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 2ec921b..ae78bb8 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -63,7 +63,7 @@
 }

 /* table of devices that work with this driver */
-static const struct usb_device_id bcm5974_table [] = {
+static const struct usb_device_id bcm5974_table[] = {
 	/* MacbookAir1.1 */
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING_ISO),
-- 
1.5.4.3

