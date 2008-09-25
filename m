Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYIYRIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYIYRIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbYIYRIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:08:01 -0400
Received: from senator.holtmann.net ([87.106.208.187]:36273 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYIYRIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:08:00 -0400
Subject: Re: pull request: wireless-2.6 2008-09-24
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>, "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080925114133.GA5044@tuxdriver.com>
References: <20080924231720.GD3639@tuxdriver.com>
	 <1222321622.2510.455.camel@debian.sh.intel.com>
	 <20080925114133.GA5044@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 21:09:01 +0200
Message-Id: <1222369742.6442.0.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

> > > One more for 2.6.27 -- a fix for a possible interrupt storm.  There is
> > > even a link in the commit log to a youtube video of the storm in
> > > progress. :-)
> > > 
> > > Let me know if there are problems!
> > 
> > Can you also add this one? It doesn't panic the kernel when a frame from
> > firmware is invalid.
> > 
> > http://marc.info/?l=linux-wireless&m=122219037706528&w=2
> 
> Is there an open bug report for that anywhere?  Is this something
> that real users (no offense to Johannes) are likely to hit?

I was hitting this one a frequent basis on a 64-bit Linux running on an
off-the-shelf X61.

Regards

Marcel


