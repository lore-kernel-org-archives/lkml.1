Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbXB1WrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbXB1WrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932159AbXB1WrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:47:10 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4922 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbXB1WrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:47:08 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Feb 2007 14:47:04 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070228222210.GA4675@elte.hu>
Message-ID: <Pine.LNX.4.64.0702281445570.6806@alien.or.mcafeemobile.com>
References: <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com>
 <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com>
 <20070228202156.GA15846@elte.hu> <Pine.LNX.4.64.0702281259430.6806@alien.or.mcafeemobile.com>
 <20070228212306.GA27127@elte.hu> <Pine.LNX.4.64.0702281338510.6806@alien.or.mcafeemobile.com>
 <20070228222210.GA4675@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Ingo Molnar wrote:

> > Or with a simple/parellel async submission, coupled with threadlets, 
> > we can cover a pretty broad range of real life use cases?
> 
> sure, if we debate its virtualization driven market penetration via self 
> promoting technologies that also drive customer satisfaction, then we'll 
> be able to increase shareholder value by improving the user experience 
> and we'll also succeed in turning this vision into a supply/demand 
> marketplace. Or not?

Okkey then, I guess it's good to go as is :)



- Davide


