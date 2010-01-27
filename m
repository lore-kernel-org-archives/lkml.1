Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375Ab0A0LKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab0A0LKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365Ab0A0LKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:10:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:58158 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0A0LKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:10:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GElqSpZHfSbADaobiwXySc/e1T1ofWC269x5vp/SSzbogWxHeS/fuegck83boE4n4B
         cEePxTe/IsLcJuRgTJOeEEiB09DMWuaW7sXgcU+z1d55qnGCEtBYpXA5pds0Gb9aKdNS
         LEAv7tCoGOvT5D+dUPT9PWVpG7tHwcHHoAO/Y=
Subject: Re: [PATCH] backlight: l4f00242t03: Fix module licence absence.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1263889850.3121.12.camel@realization>
References: <20100119150836.bb975e4b.sfr@canb.auug.org.au>
	 <1263889757.3121.10.camel@realization>
	 <1263889850.3121.12.camel@realization>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 12:10:02 +0100
Message-ID: <1264590602.2463.47.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---

Richard, can you pick this for "for-mm" branch of backlight tree?
in previous mail I explain my mistake..
Thanks.


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


