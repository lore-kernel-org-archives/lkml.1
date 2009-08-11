Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbZHKOtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbZHKOtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZHKOto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:49:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51482
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509AbZHKOtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:49:43 -0400
Date: Tue, 11 Aug 2009 07:49:53 -0700 (PDT)
Message-Id: <20090811.074953.130816092.davem@davemloft.net>
To: jkosina@suse.cz
Cc: joe@perches.com, linville@tuxdriver.com, julia@diku.dk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add networking wireless drivers section
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.0908111555410.11142@twin.jikos.cz>
References: <20090728.113353.08715297.davem@davemloft.net>
	<1248806896.18284.14.camel@Joe-Laptop.home>
	<alpine.LRH.2.00.0908111555410.11142@twin.jikos.cz>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Tue, 11 Aug 2009 15:55:46 +0200 (CEST)

> On Tue, 28 Jul 2009, Joe Perches wrote:
> 
>> > Why not just create a plain "WIRELESS" umbrella entry that contains 
>> > all of drivers/net/wireless, net/mac80211, and net/wireless?
>> Whatever works for John I suppose. John, do you have a preference?
>> I was trying to avoid the "S: Maintained" label
>> and was copying the form of this section:
>> 
>> NETWORKING DRIVERS
>> L:	netdev@vger.kernel.org
>> W:	http://www.linuxfoundation.org/en/Net
>> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
>> S:	Odd Fixes
>> F:	drivers/net/
> 
> Just out of curiosity, why is drivers/net marked as "Odd fixes" and not 
> "Maintained"?

Because it depends upon the individual driver maintainers.  For
example, I don't think one could claim 3c515.c or other ISA ethernet
drivers to be in any kind of "Maintained" state.
