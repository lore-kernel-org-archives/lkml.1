Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbXEJHXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbXEJHXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXEJHWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:22:53 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:41676 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXEJHWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:22:52 -0400
Date: Thu, 10 May 2007 09:22:44 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: John Anthony Kazos Jr <jakj@j-a-k-j.com>, Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: include files: convert "include" subdirectory to UTF-8
In-Reply-To: <200705092102.l49L2axT029607@hera.kernel.org>
Message-ID: <Pine.LNX.4.64.0705100921230.13222@anakin>
References: <200705092102.l49L2axT029607@hera.kernel.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-1711465675-1178781764=:13222"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-1711465675-1178781764=:13222
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 9 May 2007, Linux Kernel Mailing List wrote:
> diff --git a/include/asm-m68k/atarihw.h b/include/asm-m68k/atarihw.h
> index f28acd0..6211363 100644
> --- a/include/asm-m68k/atarihw.h
> +++ b/include/asm-m68k/atarihw.h
> @@ -2,7 +2,7 @@
>  ** linux/atarihw.h -- This header defines some macros and pointers for
>  **                    the various Atari custom hardware registers.
>  **
> -** Copyright 1994 by Bj”rn Brauel
> +** Copyright 1994 by BjÂ”rn Brauel
>  **
>  ** 5/1/94 Roman Hodek:
>  **   Added definitions for TT specific chips.
> diff --git a/include/asm-m68k/atariints.h b/include/asm-m68k/atariints.h
> index 0ed454f..ce6c445 100644
> --- a/include/asm-m68k/atariints.h
> +++ b/include/asm-m68k/atariints.h
> @@ -1,7 +1,7 @@
>  /*
>  ** atariints.h -- Atari Linux interrupt handling structs and prototypes
>  **
> -** Copyright 1994 by Bj”rn Brauel
> +** Copyright 1994 by BjÂ”rn Brauel
>  **
>  ** 5/2/94 Roman Hodek:
>  **   TT interrupt definitions added.

These two seem to have failed.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-1711465675-1178781764=:13222--
