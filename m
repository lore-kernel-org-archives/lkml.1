Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbXIBKKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbXIBKKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 06:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXIBKKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 06:10:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33360 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755187AbXIBKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 06:10:19 -0400
Date: Sun, 2 Sep 2007 11:18:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Gray <jsg@goblin.cx>
Cc: Jason Dixon <jason@dixongroup.net>, bunk@kernel.org, mureninc@gmail.com,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: That whole "Linux stealing our code" thing
Message-ID: <20070902111824.153bc036@the-village.bc.nu>
In-Reply-To: <20070902022253.GA18201@mail.netspace.net.au>
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
	<f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
	<46D99FB7.6030505@garzik.org>
	<f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>
	<20070901205457.GK9260@stusta.de>
	<3A831845-B630-42AD-B52F-DC9EA2060BAE@dixongroup.net>
	<20070902022253.GA18201@mail.netspace.net.au>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> co-operation. Together we advance our detective work and knowledge of
> the Macintosh platforms to the good of all Macintosh users dumped"
> 
> Alan Cox circa 1999.
> 
> http://lists.freedesktop.org/archives/xorg/2007-August/027419.html
> 
> "well I'd be quite happy to see X go GPL but I'm aware
> thats not the intention of the project ;)"
> Alan Cox circa 2007.
> 
> What changed? 

Nothing that I am aware of. You can't take Linux/Mac68K code back into
BSD either. BSD code is being used according to the BSD licence. You
could adopt a different licence if the way your code is being used
bothers you, thats.

Where I've reused BSD code I've aways tried to contribute it back to the
BSD people or share the knowledge (and the knowledge far more than the
code mattered both ways for Mac68K systems)

I suggest you read drivers/net/wan/syncppp.c, which is I think the only
BSD derived bit of code of mine left in the kernel - and its quite
specific what it says.

Ath5k isn't my code so I don't get to pick. Having the OpenBSD maintainer
make bogus remarks about that doesn't help anyone, especially when he's
wrong and doesn't appear to know about the subject in the first place.

Alan
