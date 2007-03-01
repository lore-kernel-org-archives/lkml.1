Return-Path: <linux-kernel-owner+w=401wt.eu-S965050AbXCANeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050AbXCANeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965051AbXCANeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:34:12 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52819 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965050AbXCANeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:34:10 -0500
Date: Thu, 1 Mar 2007 16:30:20 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301133018.GB30177@2ka.mipt.ru>
References: <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301110022.GA28260@elte.hu> <20070301111629.GA27381@2ka.mipt.ru> <20070301114137.GB897@elte.hu> <20070301114734.GA3508@elte.hu> <20070301121020.GC20773@2ka.mipt.ru> <20070301124336.GA24464@elte.hu> <20070301130135.GA20554@2ka.mipt.ru> <20070301131118.GA30228@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301131118.GA30228@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 16:32:12 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 02:11:18PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> ok?

I undesrtood you couple of mails ago.
No problem, I can put processing into the same function called from
different servers :)

> Btw., am i correct that in this particular 'ab' test, the 'immediately' 
> flag is always zero, i.e. kweb_kevent_remove() is always called?

Yes.

> 	Ingo

-- 
	Evgeniy Polyakov
