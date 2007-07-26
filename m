Return-Path: <linux-kernel-owner+w=401wt.eu-S1765622AbXGZMlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765622AbXGZMlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbXGZMlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:41:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53840 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754864AbXGZMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:41:37 -0400
Date: Thu, 26 Jul 2007 13:47:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Marcin ??lusarz <marcin.slusarz@gmail.com>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH][netdrvr] lib8390: comment on locking by Alan Cox Re:
 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070726134714.31882b7e@the-village.bc.nu>
In-Reply-To: <20070726124401.GC3423@ff.dom.local>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com>
	<20070629150759.GC2771@ff.dom.local>
	<4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
	<20070724080534.GC18740@elte.hu>
	<20070724094202.GA11610@elte.hu>
	<alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org>
	<20070724200431.GA22190@elte.hu>
	<1185322771.4175.102.camel@chaos>
	<20070725135718.GB1843@ff.dom.local>
	<20070725154656.54fd6f13@the-village.bc.nu>
	<20070726124401.GC3423@ff.dom.local>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 14:44:01 +0200
Jarek Poplawski <jarkao2@o2.pl> wrote:

> Hi,
> 
> Very below is my patch proposal with a comment, which in my opinion
> is precious enough to save it for future help in reading and
> understanding the code.
> 
> I hope Alan will not blame me I've not asked for his permission before
> sending, and he would ack this patch as it is or at least most of this.

Fine by me

