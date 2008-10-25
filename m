Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYJYQQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYJYQQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 12:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYJYQQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 12:16:45 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:35882 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYJYQQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 12:16:44 -0400
Date: Sat, 25 Oct 2008 18:16:42 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?B?SmnFmcOtIE1vcmF2ZWM=?= <jim.lkml@gmail.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Typo in drivers/video/modedb.c
In-Reply-To: <49033AE4.3000502@gmail.com>
Message-ID: <Pine.LNX.4.64.0810251816040.15317@anakin>
References: <49033AE4.3000502@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808415-1685231847-1224951376=:15317"
Content-ID: <Pine.LNX.4.64.0810251816360.15317@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808415-1685231847-1224951376=:15317
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0810251816361.15317@anakin>

On Sat, 25 Oct 2008, JiÅ~YÃ­ Moravec wrote:
> When I viewed drivers/video/modedb.c, so I accidentally noticed a very old typo already contained in 2.6.0.
> This typo remained unheeded at least 5 years. Clear evidence of its importance.  ;) 

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
> diff -Nupr a/drivers/video/modedb.c b/drivers/video/modedb.c
> --- a/drivers/video/modedb.c	2008-10-25 16:18:00.000000000 +0200
> +++ b/drivers/video/modedb.c	2008-10-25 16:18:10.000000000 +0200
> @@ -329,7 +329,7 @@ const struct fb_videomode vesa_modes[] =
>  	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
>  	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
>  	/* 17 1152x864-75 VESA */
> -	{ NULL, 75, 1153, 864, 9259, 256, 64, 32, 1, 128, 3,
> +	{ NULL, 75, 1152, 864, 9259, 256, 64, 32, 1, 128, 3,
>  	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
>  	  FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
>  	/* 18 1280x960-60 VESA */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808415-1685231847-1224951376=:15317--
