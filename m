Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbXCAMVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbXCAMVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933259AbXCAMVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:21:48 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50361 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbXCAMVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:21:47 -0500
Date: Thu, 1 Mar 2007 15:19:40 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20070301121940.GA20952@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <200703011214.45144.dada1@cosmosbay.com> <20070301112017.GB27381@2ka.mipt.ru> <200703011228.01144.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200703011228.01144.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 15:20:24 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:28:00PM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> I used the CVS version of oprofile plus a patch you can find in the mailing 
> list archives. Dont remember exactly, since I hit this some months ago

Ugh, I started - but CVS compilation requires about 40mb of additional
libs (according to debian testing dependencies on my very light
installation), so with my miserable 1-1.6 kb/sec do not expect it today :)

-- 
	Evgeniy Polyakov
