Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbXJGVXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbXJGVXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXJGVXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:23:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbXJGVXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 17:23:40 -0400
Date: Sun, 7 Oct 2007 23:23:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Willy Tarreau <w@1wt.eu>, Rene Herman <rene.herman@keyaccess.nl>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
	usage"
Message-ID: <20071007212311.GB27685@elte.hu>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu> <20071007194725.GS22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007194725.GS22435@flower.upol.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Verych <olecom@flower.upol.cz> wrote:

> > For instance, anyone who has experienced read errors on and IDE disk 
> > knows that it can literally take hours/days to boot, after 
> > displaying thousands of messages. Here, having the ability to see 
> > that no IRQ was assigned or something like this could help.
> 
> As i'm pretty much in all that text(tty)-mode stuff anyway, maybe 
> after some time i will propose something klibc/tty based. Mainly a bit 
> of user interface: split scrolling regions for errors and 
> notifications; flexible color schemas (keyword highlighting); keyboard 
> events. Of course it will work in such IDE cases, only if driver is a 
> module.

Jan's code is here today and it works fine for me. How can you 
coherently argue against the plain fact that his feature solves my 
usecases perfectly fine, while your hypothetical solution clearly does 
not solve them? (Although i'm not too hopeful you'll give me a straight 
answer to my straight question, given your track record on lkml. It is 
almost as if you were more interested in ranting and in controversy than 
in the progress of Linux.)

	Ingo
