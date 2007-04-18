Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXDRHHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXDRHHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932710AbXDRHHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:07:01 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:50783 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700AbXDRHG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:06:59 -0400
Date: Wed, 18 Apr 2007 09:06:35 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] documentation: convert the Documentation directory to
 UTF-8
In-Reply-To: <alpine.DEB.0.83.0704171247230.27446@sigma.j-a-k-j.com>
Message-ID: <Pine.LNX.4.64.0704180905070.3288@anakin>
References: <alpine.DEB.0.83.0704171247230.27446@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-1528985845-1176879995=:3288"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-1528985845-1176879995=:3288
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 17 Apr 2007, John Anthony Kazos Jr. wrote:
> --- linux-2.6.21-rc7.orig/Documentation/fb/framebuffer.txt	2007-02-04 13:44:54.000000000 -0500
> +++ linux-2.6.21-rc7.mod/Documentation/fb/framebuffer.txt	2007-04-17 12:44:09.000000000 -0400
> @@ -217,7 +217,7 @@ vsync length.
>    +----------+---------------------------------------------+----------+-------+
>    |          |                ^                            |          |       |
>    |          |                |upper_margin                |          |       |
> -  |          |                ¥                            |          |       |
> +  |          |                Â¥                            |          |       |

While you're at it, you may want to use a better suited UTF-8 arrow symbol
instead of the louse JPY symbol I chose many years ago ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-1528985845-1176879995=:3288--
