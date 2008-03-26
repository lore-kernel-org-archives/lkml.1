Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYCZK44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYCZK44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYCZK4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:56:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbYCZK4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:56:46 -0400
Date: Wed, 26 Mar 2008 11:56:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: joern@logfs.org, jirislaby@gmail.com, viro@ZenIV.linux.org.uk,
       joe@perches.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080326105628.GC17176@elte.hu>
References: <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325.161142.65862968.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325.161142.65862968.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 25 Mar 2008 14:45:56 +0100
> 
> > and let me give an example with the your very own code that you wrote 
> > and maintain, drivers/mtd/devices/block2mtd.c:
> > 
> >                                     errors   lines of code   errors/KLOC
> > drivers/mtd/devices/block2mtd.c         10             490          20.4
> 
> Ingo, this is devolving into a "code I maintain is great, code you 
> maintain sucks, checkpatch says so" kind of discussion, please stop.

Firstly, had you read my previous mails you'd realize that a score of 
20.4 errors/KLOC is pretty clean code for a driver. (and a manual view 
of drivers/mtd/devices/block2mtd.c confirmed that first quick 
impression.)

Secondly, it was you who claimed that checkpatch.pl warnings were bogus, 
i asked for hard data which you refused to provide, so i had to come up 
with examples to counter that.

What did you expect me to express my checkpatch.pl experience about, if 
not about code that i maintain? How did you expect me to show to you 
that the warnings are correct, if not code that you maintain? Why should 
i talk about any code that neither you nor i am directly interested in? 
Do you want me to talk about FreeBSD, so that i dont hurt anyone's 
feelings? Feel free to use my code as an example to make your points.

> You're not making any friends by making your arguments this way.

just to make it clear, i'm not here on lkml to "make friends", i'm here 
to make Linux better. The two goals are not fundamentally incompatible 
but sometimes they do clash ;-)

	Ingo
