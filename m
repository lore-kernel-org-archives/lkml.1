Return-Path: <linux-kernel-owner+w=401wt.eu-S965529AbXCATbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbXCATbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965532AbXCATbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:31:18 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1974 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965529AbXCATbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:31:17 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 1 Mar 2007 11:31:14 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070301145454.GB12684@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu>
 <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com>
 <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007, Evgeniy Polyakov wrote:

> Ingo, do you really think I will send mails with faked benchmarks? :))

I don't think he ever implied that. He was only suggesting that when you 
post benchmarks, and even more when you make claims based on benchmarks, 
you need to be extra carefull about what you measure. Otherwise the 
external view that you give to others does not look good.
Kevent can be really faster than epoll, but if you post broken benchmarks 
(that can be, unrealiable HTTP loaders, broken server implemenations, 
etc..) and make claims based on that, the only effect that you have is to 
lose your point.



- Davide


