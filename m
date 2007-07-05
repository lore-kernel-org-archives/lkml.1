Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbXGEKWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbXGEKWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 06:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758431AbXGEKWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 06:22:36 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40016 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036AbXGEKWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 06:22:35 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 5 Jul 2007 06:20:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Denis Vlasenko <vda.linux@googlemail.com>
cc: Jesper Juhl <jesper.juhl@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Some love to default profiler
In-Reply-To: <200707051216.29018.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707050619110.4294@localhost.localdomain>
References: <20070704213420.GA5864@martell.zuzino.mipt.ru>
 <9a8748490707041650s3b122007o46c8a34647b43af3@mail.gmail.com>
 <200707051216.29018.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Denis Vlasenko wrote:

> On Thursday 05 July 2007 01:50, Jesper Juhl wrote:
> > > Removes conditional branch from schedule(). Code savings on my
> > >    usual config:
> > >
> > >            text    data     bss     dec     hex filename
> > >         2921871  179895  180224 3281990  321446 vmlinux         before
> > >         2920141  179847  180224 3280212  320d54 vmlinux         after
> > >         --------------------------------------------------------------
> > >           -1730     -48           -1778
> >
> > Nice savings there. Not that 1.7K is huge, but it's kernel memory is
> > precious :-)
>
> Hehe. In busybox project people can kill for 1.7K :)
> --

true enough.  say ... whatever *did* you do with rob landley's body?
:-)

rday

p.s  that was, i say, that was a *joke*, son.
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
