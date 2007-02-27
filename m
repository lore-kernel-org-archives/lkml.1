Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbXB0MZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbXB0MZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933078AbXB0MZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:25:39 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45624 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059AbXB0MZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:25:38 -0500
Date: Tue, 27 Feb 2007 15:22:50 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: threadlets as 'naive pool of threads', epoll, some measurements
Message-ID: <20070227122250.GA20235@2ka.mipt.ru>
References: <20070226104507.GA18470@elte.hu> <20070226114858.GA28836@elte.hu> <20070226122521.GA19039@2ka.mipt.ru> <20070226125054.GA6997@elte.hu> <20070226143201.GB31629@2ka.mipt.ru> <20070226202338.GA23357@elte.hu> <20070227081611.GB16295@2ka.mipt.ru> <20070227082757.GA23617@elte.hu> <20070227103711.GD23170@2ka.mipt.ru> <20070227121539.GA20089@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070227121539.GA20089@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 15:24:14 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 01:15:42PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > So, ok, no micro-thread name.
> 
> thanks!

:) no problem!

> 	Ingo

-- 
	Evgeniy Polyakov
