Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbYFBLVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbYFBLVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYFBLVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:21:06 -0400
Received: from www.sophics.cz ([92.61.80.24]:41369 "EHLO www.sophics.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbYFBLVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:21:05 -0400
X-Greylist: delayed 1559 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2008 07:21:04 EDT
Message-ID: <4843D179.7070809@sophics.cz>
Date: Mon, 02 Jun 2008 12:54:49 +0200
From: Petr Stehlik <pstehlik@sophics.cz>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       =?UTF-8?B?77+9?= <rene.scharfe@lsrfire.ath.cx>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] msdos fs: remove unsettable atari option
References: <1211717062.5782.16.camel@ubuntu> <87ve12s849.fsf@duaron.myhome.or.jp> <20080601221035.GA9107@nineveh.local> <87zlq4rd30.fsf@duaron.myhome.or.jp> <Pine.LNX.4.64.0806020930170.7351@anakin>
In-Reply-To: <Pine.LNX.4.64.0806020930170.7351@anakin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
>>> Geert Uytterhoeven has a patch in his POSTPONED queue that is supposed
>>> to fix Atari FAT.  I can't speak to whether it works or why it's
>>> postponed, but it seems to compile.
>> I see. Although I don't know the patch, I'd like to add this part to
>> Geert's patch if possible. And when the patch can be posted, we can
>> re-add this part again.
>>
>> Geert, what do you think?
> 
> It's in POSTPONED state because nobody speaks up for/against it.
> Personally, I don't know how much it is (still) needed...
> But a few years ago somebody contacted me that he used it succesfully
> on PA-RISC and i386 ;-)
> 
> BTW, the patch is
> http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-patches-2.6/POSTPONED/134-atari-fat.diff
> 
> Atari people, I think now is the time to let it live or die...

The patch looks good, how can I let it live?

Petr

