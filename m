Return-Path: <linux-kernel-owner+w=401wt.eu-S1765581AbXJFVl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765581AbXJFVl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbXJFVlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:41:21 -0400
Received: from barikada.upol.cz ([158.194.242.200]:45856 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbXJFVlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:41:21 -0400
Date: Sat, 6 Oct 2007 23:55:27 +0200
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: About summary in the subject (Re: [PATCH 0/2] Colored kernel output (run2))
Message-ID: <20071006215527.GI22435@flower.upol.cz>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <Pine.LNX.4.64.0710062300200.30354@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710062300200.30354@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 11:03:38PM +0200, Jan Engelhardt wrote:
> 
> On Oct 6 2007 23:03, Oleg Verych wrote:
> >> 
> >> (btw., i corrected the subject line to remove the 'NAK'. Why do you 
> >> think you can 'NAK' a patch in this field?)
> >
> >I added comment (like this), so anyone can skip reading body, if headers
> >are "Oleg Verych && NAK". In case if `NAK' have a magic meaning in the
> >LKML, like control characters in the tty, i'm sorry.
> >
> >But how to express opinion quickly and easily?
> 
> You can't. I think that people will usually be interested _why_ you
> voted for or against something

Do you really think so? Yes, there are possibly LKML bots, that will
read all messages in every thread. But i doubt they are humans.

I also think, that kill-files and kill-names are common tools of the LKML
readers. Thus, if someone sees my name with something like NAK in the
subject, then nothing to worry about: next, please. I just amazed how
inefficiently Subject, To, Cc headers are used. Everybody hurry through
huge mail backlogs with subjects in thread all like one.

Summary and keywords headers are not used, so why not to make
greping/selecting interesting/useful messages more efficient (and not
only for those who is in Cc list)?

Every mail/news reader displays To and Subject, so latter is last hope of
increasing of efficiency, even in small threads.

> (given the number of vote-submitters does not go through the roof).
> That clearly won't fit into the subject,

Sorry, i cannot see, what you are trying to say here. To place all
acks-by to subject? No, just to get summary in one particular reply.

> and even if RFC822 allowed it, it's only displayed like 40 chars wide.
> The submitter (me in this case) will even look at *all* mails, so as to
> (1) address the NAKs and (2) address the hidden feature requests in
> ACKs.  :-)
____
