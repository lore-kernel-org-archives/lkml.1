Return-Path: <linux-kernel-owner+w=401wt.eu-S1750785AbXB1IFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750785AbXB1IFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXB1IFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:05:10 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:36681 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbXB1IFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:05:08 -0500
Date: Wed, 28 Feb 2007 11:02:26 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070228080226.GA9639@2ka.mipt.ru>
References: <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <f2b55d220702271903o6bc418efu7d72a564a7ade365@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <f2b55d220702271903o6bc418efu7d72a564a7ade365@mail.gmail.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 28 Feb 2007 11:02:52 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 07:03:21PM -0800, Michael K. Edwards (medwards.linux@gmail.com) wrote:
> 
> State machines are much harder to write without going through a real
> on-paper design phase first.  But multi-threaded code is much harder
> for a team of average working coders to write correctly, judging from
> the numerous train wrecks that I've been called in to salvage over the
> last ten years or so.

130 lines skipped...

I have only one question - wasn't it too lazy to write all that? :)

> Cheers,
> - Michael

-- 
	Evgeniy Polyakov
