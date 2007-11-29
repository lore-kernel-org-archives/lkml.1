Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbXK2UEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbXK2UEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759914AbXK2UDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:03:53 -0500
Received: from s2.ukfsn.org ([217.158.120.143]:60464 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759703AbXK2UDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:03:52 -0500
Date: Thu, 29 Nov 2007 20:03:32 +0000
From: Nick Warne <nick@ukfsn.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Peculiar out-of-sync boot log lines
Message-ID: <20071129200332.2130298b@linuxamd.linicks.net>
In-Reply-To: <1196365871.6473.107.camel@perihelion>
References: <20071129193728.2f1c237e@linuxamd.linicks.net>
	<1196365871.6473.107.camel@perihelion>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Thu, 29 Nov 2007 14:51:11 -0500
Jon Masters <jonathan@jonmasters.org> wrote:

> 
> On Thu, 2007-11-29 at 19:37 +0000, Nick Warne wrote:
> > Hi all,
> > 
> > 2.6.23.9
> > 
> > I have noticed after applying Bart's patch to word93 blacklist my
> > new DVD drive:
> > 
> > http://lkml.org/lkml/2007/10/23/475
> > 
> > I see now in logs (look at the hdd line:
> > 
> > [dmesg]
> > hdc: 39876480 sectors (20416 MB) w/2048KiB Cache, CHS=39560/16/63,
> > UDMA(66)
> > hdc: cache flushes not supported
> >  hdc: hdc1
> > hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd:
> > skipping word 93 validity check
> > , UDMA(66)
> > Uniform CD-ROM driver Revision: 3.20
> 
> Only very early in boot are you guaranteed for things to execute
> sequentially, and for logs to look nice and pretty.
> 

Yes, but where does the <7> come from?

Nick

-- 
Free Software Foundation Associate Member 5508
