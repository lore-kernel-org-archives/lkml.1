Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYJAAQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYJAAQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 20:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYJAAQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 20:16:46 -0400
Received: from xenotime.net ([66.160.160.81]:50369 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751696AbYJAAQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 20:16:45 -0400
Date: Tue, 30 Sep 2008 17:35:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Joe Perches <joe@perches.com>
Cc: Pavel Machek <pavel@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ben Dooks <ben-linux@fluff.org>,
       Uwe Kleine-K?nig <ukleinek@strlen.de>,
       Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] List of maintainers (draft #3)
Message-Id: <20080930173512.c221ade7.rdunlap@xenotime.net>
In-Reply-To: <1222819790.29215.126.camel@localhost>
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua>
	<20080922081239.GA28726@strlen.de>
	<20080922091256.GH1916@fluff.org.uk>
	<84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com>
	<48D7CA62.1020805@zytor.com>
	<20080929175625.GA3676@ucw.cz>
	<20080930171058.9e5f48d0.rdunlap@xenotime.net>
	<1222819790.29215.126.camel@localhost>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 17:09:50 -0700 Joe Perches wrote:

> On Tue, 2008-09-30 at 17:10 -0700, Randy Dunlap wrote:
> > On Mon, 29 Sep 2008 19:56:25 +0200 Pavel Machek wrote:
> > > Yes please. Manually searching MAINTAINERS is  boring and hard... 'Is
> > > it NETWORK BLOCK DEVICE' or 'NBD'? 'ALSA' or 'ADVANCED LINUX SOUND 
> > > SYSTEM'? ... plus if you want subsystem maintainer, search tends to
> > > give you about 179 individual driver maintainers, first.
> > Well.... both the acronym and long name should be listed IMO.
> > Especially the acronym/short name.
> 
> Human based visual searches are error prone.
> 
> There really does need to be some systematic and automated
> mechanism to find the maintainers for a particular file.
> 
> Maintainer file patterns, either centralized in MAINTAINERS
> or distributed in some mechanism in the file system or git
> are useful.
> 
> Linus' original point about "hotness" of MAINTAINERS being
> an issue was later refuted by Linus.
> 
> http://lkml.org/lkml/2008/2/13/414

I just don't think that it's a big problem like you and Pavel seem to.
IOW I'll just disagree.

---
~Randy
