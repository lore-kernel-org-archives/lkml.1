Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYIVAZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYIVAZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 20:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYIVAZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 20:25:17 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:49109 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbYIVAZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 20:25:16 -0400
Date: Mon, 22 Sep 2008 04:18:17 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, arjan@infradead.org, johannes@sipsolutions.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw2100-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, reinette.chatre@intel.com, jgarzik@pobox.com,
       linville@tuxdriver.com
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080922001817.GB1878@2ka.mipt.ru>
References: <20080921205706.GA24545@2ka.mipt.ru> <20080921233819.32714483@lxorguk.ukuu.org.uk> <20080921234403.GA17946@2ka.mipt.ru> <20080921.164829.156985548.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921.164829.156985548.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 04:48:29PM -0700, David Miller (davem@davemloft.net) wrote:
> Evgeniy, you're bordering on being an asshole, if not actually
> being one.

Out of curiosity, what's worse: being an asshole and pretend to be good
or vice versa? Whatever... :)

> If you behaved this way for a bug I was responsible for, I would
> absolutely ignore you until you settled down and started to behave
> more reasonably.

That's the main point: 'until you started to behave more reasonably'.
For example filling another bug in rh/suse/ubuntu bugzilla?
Put yourself to the user's place, and suddenly picture changes
dramatically.

We got some progress on this bug, at least there is direct suggestion
from Matthew about power state, if it will fix the issue, I think it is
a good deal: one bug fix for lot of users for the mail in the killfile
and a worsened 'reputation'.

I provded a patch like Arjan wanted, and it can only change something
because of all this talks I started being an asshole. In my opinion.
Maybe there were some other ways around, but it looks like being a
provocative is the only way to get to the cloud. Who knows :)

-- 
	Evgeniy Polyakov
