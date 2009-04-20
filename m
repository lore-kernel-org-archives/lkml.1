Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbZDTVRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbZDTVRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZDTVQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:16:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42181 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756587AbZDTVQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:16:55 -0400
Date: Mon, 20 Apr 2009 22:16:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-14?B?Um9n6XJpbw==?= Brito <rbrito@ime.usp.br>
Cc: Jeff Garzik <jeff@garzik.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090420221645.3a7c79e4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090420204139.GA15230@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
	<49EB1A33.7050808@rtr.ca>
	<49EB1C9C.3000105@msgid.tls.msk.ru>
	<49EB1FB3.5000609@garzik.org>
	<20090419201132.GB2891@ime.usp.br>
	<49EB9758.3020506@garzik.org>
	<20090420173526.GA7935@ime.usp.br>
	<20090420194017.4edd5674@lxorguk.ukuu.org.uk>
	<20090420204139.GA15230@ime.usp.br>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right. I don't remember the kernel logging out errors when I was using a
> custom kernel and pure Debian userland with the promise IDE controller
> on this ASUS K7V motherboard (which has a VIA KT-133 chipset, not a
> KT-133A).

That strongly suggests its a software bug, probably misprogramming the
timing in UDMA33 mode.

> Hummm, now that you mention it, I will see if the loudspeakers installed
> may have any impact on it.

Would take a bit more than that I think

Alan
