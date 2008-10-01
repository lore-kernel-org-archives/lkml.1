Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYJAAOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYJAAOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 20:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYJAAO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 20:14:28 -0400
Received: from [206.117.136.22] ([206.117.136.22]:2154 "EHLO mail.perches.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYJAAO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 20:14:27 -0400
Subject: Re: [RFC] List of maintainers (draft #3)
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Pavel Machek <pavel@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ben Dooks <ben-linux@fluff.org>,
       Uwe Kleine-K?nig <ukleinek@strlen.de>,
       Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080930171058.9e5f48d0.rdunlap@xenotime.net>
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua>
	 <20080922081239.GA28726@strlen.de> <20080922091256.GH1916@fluff.org.uk>
	 <84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com>
	 <48D7CA62.1020805@zytor.com> <20080929175625.GA3676@ucw.cz>
	 <20080930171058.9e5f48d0.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 17:09:50 -0700
Message-Id: <1222819790.29215.126.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 17:10 -0700, Randy Dunlap wrote:
> On Mon, 29 Sep 2008 19:56:25 +0200 Pavel Machek wrote:
> > Yes please. Manually searching MAINTAINERS is  boring and hard... 'Is
> > it NETWORK BLOCK DEVICE' or 'NBD'? 'ALSA' or 'ADVANCED LINUX SOUND 
> > SYSTEM'? ... plus if you want subsystem maintainer, search tends to
> > give you about 179 individual driver maintainers, first.
> Well.... both the acronym and long name should be listed IMO.
> Especially the acronym/short name.

Human based visual searches are error prone.

There really does need to be some systematic and automated
mechanism to find the maintainers for a particular file.

Maintainer file patterns, either centralized in MAINTAINERS
or distributed in some mechanism in the file system or git
are useful.

Linus' original point about "hotness" of MAINTAINERS being
an issue was later refuted by Linus.

http://lkml.org/lkml/2008/2/13/414


