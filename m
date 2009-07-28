Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZG1Sen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZG1Sen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZG1Sem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:34:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36696
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755390AbZG1Sel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:34:41 -0400
Date: Tue, 28 Jul 2009 11:34:48 -0700 (PDT)
Message-Id: <20090728.113448.258079823.davem@davemloft.net>
To: joe@perches.com
Cc: randy.dunlap@oracle.com, linville@tuxdriver.com, julia@diku.dk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add networking wireless drivers section
From: David Miller <davem@davemloft.net>
In-Reply-To: <1248805627.18284.11.camel@Joe-Laptop.home>
References: <1248804397.18284.5.camel@Joe-Laptop.home>
	<20090728111552.528a2c9a.randy.dunlap@oracle.com>
	<1248805627.18284.11.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 28 Jul 2009 11:27:07 -0700

> On Tue, 2009-07-28 at 11:15 -0700, Randy Dunlap wrote:
>> On Tue, 28 Jul 2009 11:06:37 -0700 Joe Perches wrote:
>> > On Tue, 2009-07-28 at 10:30 -0700, David Miller wrote:
>> > > Wireless patches need to be CC:'d to linux-wireless so that
>> > > John Linville can notice and pick them up
>> > Signed-off-by: Joe Perches <joe@perches.com>
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index ebc2691..0574aad 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -4186,6 +4186,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
>> >  S:	Odd Fixes
>> >  F:	drivers/net/
>> >  
>> > +NETWORKING WIRELESS DRIVERS
>> > +L:	linux-wireless@vger.kernel.org
>> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
>> > +S:	Odd Fixes
>> > +F:	drivers/net/wireless/
>> > +
>> 
>> Already have this:
>> 
>> NETWORKING [WIRELESS]
>> P:	John W. Linville
>> M:	linville@tuxdriver.com
>> L:	linux-wireless@vger.kernel.org
>> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
>> S:	Maintained
>> F:	net/wireless/
>> F:	include/net/ieee80211*
>> F:	include/linux/wireless.h
> 
> That section does not include drivers/net/wireless/

So just add it.

> I believe John Linville isn't maintaining all the
> wireless drivers, he's acting as a gatekeeper in
> a similar role as DavidM for drivers/net/.

It still needs to hit his inbox and linux-wireless
regardless.
