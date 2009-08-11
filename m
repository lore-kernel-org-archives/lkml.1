Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbZHKNzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbZHKNzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZHKNzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:55:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:43099 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZHKNzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:55:50 -0400
Date: Tue, 11 Aug 2009 15:55:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com, julia@diku.dk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add networking wireless drivers section
In-Reply-To: <1248806896.18284.14.camel@Joe-Laptop.home>
Message-ID: <alpine.LRH.2.00.0908111555410.11142@twin.jikos.cz>
References: <Pine.LNX.4.64.0907281753540.28189@ask.diku.dk>  <20090728.103044.179053537.davem@davemloft.net>  <1248804397.18284.5.camel@Joe-Laptop.home>  <20090728.113353.08715297.davem@davemloft.net> <1248806896.18284.14.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009, Joe Perches wrote:

> > Why not just create a plain "WIRELESS" umbrella entry that contains 
> > all of drivers/net/wireless, net/mac80211, and net/wireless?
> Whatever works for John I suppose. John, do you have a preference?
> I was trying to avoid the "S: Maintained" label
> and was copying the form of this section:
> 
> NETWORKING DRIVERS
> L:	netdev@vger.kernel.org
> W:	http://www.linuxfoundation.org/en/Net
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
> S:	Odd Fixes
> F:	drivers/net/

Just out of curiosity, why is drivers/net marked as "Odd fixes" and not 
"Maintained"?

-- 
Jiri Kosina
SUSE Labs

