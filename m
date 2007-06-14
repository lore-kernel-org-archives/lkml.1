Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbXFNUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbXFNUQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXFNUQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:16:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbXFNUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:16:04 -0400
Date: Thu, 14 Jun 2007 13:15:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706141311330.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <200706132140.13490.dhazelton@enter.net>
 <20070614020827.GO3588@stusta.de> <200706132243.14651.dhazelton@enter.net>
 <20070614025640.GQ3588@stusta.de> <9578.1181793617@turing-police.cc.vt.edu>
 <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
 <20070614131409.9a5800dc.seanlkml@sympatico.ca>
 <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org>
 <orzm32cr8v.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141153550.14121@woody.linux-foundation.org>
 <or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Alexandre Oliva wrote:
> 
> Then would you consider relicensing Linux under GPLv3 + additional
> permission for Tivoization?

No. I'm not stupid.

The GPLv3 explicitly allows removing additional permissions.

So anybody who does "GPLv3 + additional permissions" is basically setting 
himself up for people taking those permissions away.

Since the Tivo kind of permission is in my opinion a *fundamental right* 
(or call if "freedom" if you want), then "GPLv3 + additional permissions" 
simply is not a viable alternative, since anybody could just decide to 
make improvements and strip those permissions.

The whole notion of "additional permissions" in the GPLv3 is totally 
pointless, since it's legally *exactly* the same as allowing dual 
licensing (which a license doesn't even have to spell out: you can 
dual-license *regardless* of the license!).

The reason for the "additional permissions" is just to make the LGPL go 
away, and become a sub-clause of the GPLv3.

If you really thought anything else, you're just uninformed and stupid, 
and didn't think things through.

			Linus
