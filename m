Return-Path: <linux-kernel-owner+w=401wt.eu-S1759840AbXEKNTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbXEKNTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbXEKNSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:18:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57082 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755384AbXEKNSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:18:53 -0400
Date: Fri, 11 May 2007 14:21:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070511142124.06aa2d2e@the-village.bc.nu>
In-Reply-To: <20070509203335.GA4290@ucw.cz>
References: <20070503213303.GH20067@zarina>
	<20070507140453.GD3868@ucw.cz>
	<1178550653.11851.191.camel@pmac.infradead.org>
	<20070507194949.GB3981@ucw.cz>
	<a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
	<Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
	<1178646751.2824.48.camel@pmac.infradead.org>
	<Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl>
	<1178721996.2824.199.camel@pmac.infradead.org>
	<20070509203335.GA4290@ucw.cz>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Even with fbdev... you are limited to 512 characters iirc. So.. who
> has authority to say which subset of utf-8 is ok?

This is a bug in fbdev and currently under discussion as there is no sane
reason to enforce the 512 symbol limit in the fbdev case (especially on a
large modern system)

> (Plus there is still lot of vga consoles out there -- all fedora users
> afaict?)

Fedora uses X.

Alan
--
Y sŵn y tonnau ar lan y môr
Y sŵn y gwynt yn bwrw'r dôr
Y sŵn y glaw ar y toeau
Y sŵn y storm ar y creigiau
