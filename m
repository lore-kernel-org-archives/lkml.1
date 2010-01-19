Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173Ab0ASIaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab0ASIaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648Ab0ASIay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:30:54 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59769 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab0ASIax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:30:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ihhvrq2fWBtFZW9s875Z8miUSvALqBQ84cQHqQuTX9rXq447jJYKf8fAVCMrsj13k/
         JzA9nNXQAMmWni9YltD5R1yBmyp3rlxknv5wSYVfJxcqeVgkGdSc69KUSh1j/PZJXT7Z
         5d6kruSSUpuT7eXIYD0k/CJ1enCMQz/9ifNhs=
Subject: [PATCH] backlight: l4f00242t03: Fix module licence absence.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1263889757.3121.10.camel@realization>
References: <20100119150836.bb975e4b.sfr@canb.auug.org.au>
	 <1263889757.3121.10.camel@realization>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 09:30:50 +0100
Message-ID: <1263889850.3121.12.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/video/backlight/l4f00242t03.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index 42d061e..74abd69 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -254,3 +254,4 @@ module_exit(l4f00242t03_exit);
 
 MODULE_AUTHOR("Alberto Panizzo <maramaopercheseimorto@gmail.com>");
 MODULE_DESCRIPTION("EPSON L4F00242T03 LCD");
+MODULE_LICENSE("GPL v2");
-- 
1.6.3.3



