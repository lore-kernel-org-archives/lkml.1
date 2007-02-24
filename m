Return-Path: <linux-kernel-owner+w=401wt.eu-S933560AbXBXVEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560AbXBXVEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 16:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933562AbXBXVEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 16:04:25 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2027 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560AbXBXVEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 16:04:25 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 24 Feb 2007 13:04:21 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: "Michael K. Edwards" <medwards.linux@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <f2b55d220702241152o640abaf3jc10afefaae8476cb@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702241211440.17345@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> 
 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> 
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> 
 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> 
 <20070222125931.GB25788@elte.hu>  <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
  <20070223121751.GA6626@elte.hu> <f2b55d220702241152o640abaf3jc10afefaae8476cb@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007, Michael K. Edwards wrote:

> The preceding may contain errors in detail -- I am neither a CPU
> architect nor an x86 compiler writer nor even a serious kernel hacker.

Ok, roger that. But why are you playing "Google & Preach" games to Ingo, 
that ate bread and CPUs for the last 15 years?



- Davide


