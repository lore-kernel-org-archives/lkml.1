Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYFBHes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYFBHes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYFBHej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:34:39 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:40860 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbYFBHei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:34:38 -0400
Date: Mon, 2 Jun 2008 09:34:35 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: =?UTF-8?Q?Ren=E9_Scharfe?= <rene.scharfe@lsrfire.ath.cx>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] msdos fs: remove unsettable atari option
In-Reply-To: <87zlq4rd30.fsf@duaron.myhome.or.jp>
Message-ID: <Pine.LNX.4.64.0806020930170.7351@anakin>
References: <1211717062.5782.16.camel@ubuntu> <87ve12s849.fsf@duaron.myhome.or.jp>
 <20080601221035.GA9107@nineveh.local> <87zlq4rd30.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808415-1289763891-1212391823=:7351"
Content-ID: <Pine.LNX.4.64.0806020930290.7351@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808415-1289763891-1212391823=:7351
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0806020930291.7351@anakin>

On Mon, 2 Jun 2008, OGAWA Hirofumi wrote:
> Joseph Fannin <jfannin@gmail.com> writes:
> > On Mon, May 26, 2008 at 12:42:29AM +0900, OGAWA Hirofumi wrote:
> >> René Scharfe <rene.scharfe@lsrfire.ath.cx> writes:
> >>
> >> > It has been impossible to set the option 'atari' of the MSDOS filesystem
> >> > for several years.  Since nobody seems to have missed it, let's remove
> >> > its remains.
> >> >
> >> > Signed-off-by: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
> >> > ---
> >>
> >> Looks good to me. Thanks.
> >>
> >> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> >
> > Geert Uytterhoeven has a patch in his POSTPONED queue that is supposed
> > to fix Atari FAT.  I can't speak to whether it works or why it's
> > postponed, but it seems to compile.
> 
> I see. Although I don't know the patch, I'd like to add this part to
> Geert's patch if possible. And when the patch can be posted, we can
> re-add this part again.
> 
> Geert, what do you think?

It's in POSTPONED state because nobody speaks up for/against it.
Personally, I don't know how much it is (still) needed...
But a few years ago somebody contacted me that he used it succesfully
on PA-RISC and i386 ;-)

BTW, the patch is
http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-patches-2.6/POSTPONED/134-atari-fat.diff

Atari people, I think now is the time to let it live or die...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808415-1289763891-1212391823=:7351--
