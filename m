Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbZKDRdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbZKDRdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbZKDRdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:33:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbZKDRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BEGntuPBumA2VI3QlbVAletZeleSCMl0rtu1xVg/WtD3XXODkl3zMVrN2DA0mRm1dd
         DxjSqNj7LscTiOyKWbyZfGd1sCu29c/FKeYUNbiTfsSgYzZ5CXY16/ynfBa4mdUxqD9m
         8XIZxPw0pfL7OHWZ7hTMl1zYqQUOO5txHZKs8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:32:50 +0100
Message-Id: <20091104173250.28463.45273.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/41] rt2x00: fix rt2x00usb_register_read() comment
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2x00: fix rt2x00usb_register_read() comment

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/net/wireless/rt2x00/rt2x00usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -232,7 +232,7 @@ static inline int rt2x00usb_eeprom_read(
 }
 
 /**
- * rt2x00usb_regbusy_read - Read 32bit register word
+ * rt2x00usb_register_read - Read 32bit register word
  * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
  * @offset: Register offset
  * @value: Pointer to where register contents should be stored
