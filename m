Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbZKLIIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbZKLIIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZKLIIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:08:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49288 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZKLIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:08:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: mmotm 2009-11-01-10-01 uploaded
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Emmanuel Benisty <benisty.e@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0911052010050.12138@localhost.localdomain>
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org> <alpine.LFD.2.00.0911052010050.12138@localhost.localdomain>
Message-Id: <20091112170027.33AA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 12 Nov 2009 17:08:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 1 Nov 2009, akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> 
> Does "soon" mean within this century ?
> 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> # git pull git://git.zen-sources.org/zen/mmotm.git master
> git.zen-sources.org[0: 216.98.141.250]: errno=Connection timed out
> git.zen-sources.org[0: 69.72.142.98]: errno=Connection refused
> fatal: unable to connect a socket (Connection refused)
> 
> Thanks,

I asked the same question to mmotm git tree maintainer last month.
Currently mmotm git was gone by unhappy thing. and akpm stoped his recovery.
because akpm plan to get -mm into linux-next. He said please wait few weeks.

I guess akpm is pretty busy now. (guessing because recent mmotm commit mail
was not so active). then, I'd like to answer you instead. I hope this mail help you.

Thanks.



