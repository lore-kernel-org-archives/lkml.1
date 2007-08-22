Return-Path: <linux-kernel-owner+w=401wt.eu-S1764251AbXHVJOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764251AbXHVJOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759930AbXHVIzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:55:50 -0400
Received: from mx12.go2.pl ([193.17.41.142]:38419 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758870AbXHVIzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:55:48 -0400
Date: Wed, 22 Aug 2007 10:56:51 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070822085651.GE1684@ff.dom.local>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <6101e8c40708211441g2ae20412u877082eb611f595e@mail.gmail.com> <Pine.LNX.4.64.0708220956540.20435@fbirervta.pbzchgretzou.qr> <20070822080854.GD1684@ff.dom.local> <Pine.LNX.4.64.0708221009010.20435@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708221009010.20435@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:10:16AM +0200, Jan Engelhardt wrote:
> 
> On Aug 22 2007 10:08, Jarek Poplawski wrote:
> >On Wed, Aug 22, 2007 at 09:57:04AM +0200, Jan Engelhardt wrote:
> >> 
> >> On Aug 21 2007 23:41, Oliver Pinter wrote:
> >> >I think it's bad idea, when removing support for gcc3.x, while some
> >> >people using debian 3.1 at now and under debian 3.1 the default
> >> >comiler is 3.3.5, when I good know or not!?
> >> 
> >> They always lag behind.
> >
> >Yes! Probably that's why they are so darn good!
> 
> ISTR that even Ubuntu overtook Debian... what about Debian 4.x?

I'm glad with KNOPPIX 4.0 too. But, I hope we don't think about Debian
3.1 etc. for a new box & new installation!

Since I've found lynx or links plus some html tool is not enough (too
dangerous) to configure locally cups or samba (don't remember now,
it was around the beginning of Ubuntu), and there is X and probably
gnome necessary for this, and it wasn't like this with other distros,
I think Ubuntu's way of thinking is definitely too good for me...

Jarek P.

PS: this could look like some flame war, or something, so let's say
all (GPL2) Linux distros and all gcc versions are extremely nice!
(...at least not less nice than BSDs...)
