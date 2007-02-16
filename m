Return-Path: <linux-kernel-owner+w=401wt.eu-S1945974AbXBPQH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945974AbXBPQH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945973AbXBPQH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:07:58 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:39455 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945975AbXBPQH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:07:57 -0500
Date: Fri, 16 Feb 2007 19:05:25 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070216160525.GA21160@2ka.mipt.ru>
References: <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org> <20070216085706.GA22868@2ka.mipt.ru> <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 16 Feb 2007 19:05:34 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 07:54:22AM -0800, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > Interfaces can be created and destroyed - they do not affect overall
> > system design in anyway (well, if they do, something is broken).
> 
> I'm sorry, but you've obviously never maintained any piece of software 
> that actually has users.

Strong. But saying for others usualy tends to show own problems.

> As long as you think that interfaces can change, this discussion is 
> pointless. 

That is too cool phrase to be heared - if you will make me a favour and
reread what was written you will (hopefully) detect that there were no
words about interfaces being changed after put into the wild - talk was 
only about time when system is designed and implemented, and there is
time for discussion about its rough edges - if its design is good, then
interface can be changed in a moment without any problem - that is what
we see with syslets right now - they are designed and implemented (the
formed was done several years ago), and it is time to shape its edges -
like change userspace API - it is easy, but you do not (want/like to) 
see that.

> So go away, ponder things.

But my above words are too lame for self-hearing Olympus liver.
Definitely.

> 		Linus

-- 
	Evgeniy Polyakov
