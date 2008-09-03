Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYICUWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYICUWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYICUWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:22:06 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:38384 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbYICUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:22:06 -0400
Message-ID: <48BEF1E7.1040708@euromail.se>
Date: Wed, 03 Sep 2008 22:21:59 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, akpm@osdl.org,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] bcm5974-0.64: minor cleanups for scripts/checkpatch.pl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.39.57
X-Scan-Result: No virus found in message 1KayrY-0006Xt-6Q.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KayrY-0006Xt-6Q 4bfb21dddee85adcbb2a64cb4a8beb61
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

Diff is against v2.6.27-rc5-103-g0a7574e
