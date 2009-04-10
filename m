Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbZDJKCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbZDJKCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZDJKBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:01:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:56757 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZDJKBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=xEVoTe13jqiVZK1U4yIV2oQY7seuR+d2zZJpbKC2Wk7vLOQs9T7Wd3ukVM4GIsX+yF
         5oHVN/WutyS6gmMOTywjsXpSm8cp/lIpitsqWoIMDb1iCEnUaxErhrwEWky/OLgQi+nZ
         iazFQEmKx56PFOeeKJVJCQLErs+tnUX1Ok+YQ=
MIME-Version: 1.0
From: Kim Kyuwon <chammoru@gmail.com>
Date: Fri, 10 Apr 2009 19:01:33 +0900
Message-ID: <4d34a0a70904100301x4171a0a3p8d881be9fd1a8e60@mail.gmail.com>
Subject: [PATCH 2/3] leds: change the license information
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the license to 'GPL v2'

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
---
 drivers/leds/leds-bd2802.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 6832b9f..7a03efd 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -756,4 +756,4 @@ module_exit(bd2802_exit);

 MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
 MODULE_DESCRIPTION("BD2802 LED driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
1.5.2.5


-- 
Kyuwon (±Ô¿ø)
