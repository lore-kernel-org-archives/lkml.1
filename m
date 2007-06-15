Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbXFOATD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbXFOATD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbXFOASy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:18:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43445 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752197AbXFOASx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:18:53 -0400
Date: Fri, 15 Jun 2007 01:22:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Carlo Wood <carlo@alinoe.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexandre Oliva <aoliva@redhat.com>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615012201.19415e8b@the-village.bc.nu>
In-Reply-To: <20070615000232.GB9463@alinoe.com>
References: <20070614025640.GQ3588@stusta.de>
	<9578.1181793617@turing-police.cc.vt.edu>
	<20070614152034.GS3588@stusta.de>
	<alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
	<orwsy6e89s.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141100390.14121@woody.linux-foundation.org>
	<ork5u6cpc2.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141304210.14121@woody.linux-foundation.org>
	<20070614231812.GA9463@alinoe.com>
	<20070615003919.1abfb155@the-village.bc.nu>
	<20070615000232.GB9463@alinoe.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Like, they can release/sell the whole thing under some arbitrary
> other license at their choice. But once you license it with the GPLv2,
> then you can't stop anyone else (who got it under that license) from
> using the code under that license anymore, as such it doesn't matter that
> you are the original author.

This is true of most licences. Ask musicians about trying to get their
music back from a record company. 

> * This program is free software; you can redistribute it and/or modify
> * it under the terms of the GNU General Public License as published by
> * the Free Software Foundation; either version 2 of the License, or
> * (at your option) any later version.
> 
> I might be wrong, but I always thought that that meant that John Doe
> is free to redistribute the software under version 3 of the License,
> as published by the FSF.

For those marked parts yes - thats the authors choice. Some of the kernel
is dual licensed BSD even so you can use that bit for all sorts of stuff.
Again authors choice, some authors wanted to share code between Linux and
other projects. I believe you can buy proprietary licenses to reiserfs
too.

Some authors like GPLv2 or later, some don't trust the FSF, some will
decide once GPLv3 is out, some couldn't care etc.. as the kernel doesn't
do copyright assignment all these wishes are respected and that is how it
should be.

Alan
