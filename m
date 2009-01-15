Return-Path: <linux-kernel-owner+w=401wt.eu-S1765602AbZAOOv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765602AbZAOOv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761627AbZAOOvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:51:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563AbZAOOvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:51:12 -0500
Date: Thu, 15 Jan 2009 15:50:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PULL -tip] fixed few make headers_check warnings
Message-ID: <20090115145046.GB872@elte.hu>
References: <1231836016.3212.41.camel@jaswinder.satnam> <Pine.LNX.4.64.0901140954250.27308@anakin> <3f9a31f40901140129i1389f47frf32808f3a695a118@mail.gmail.com> <20090114153825.GB32082@uranus.ravnborg.org> <3f9a31f40901140759s1542e6cclae1808b796c2b1a9@mail.gmail.com> <Pine.LNX.4.64.0901141732450.26663@anakin> <20090114201513.GC1556@uranus.ravnborg.org> <20090115111134.GB22850@elte.hu> <20090115143717.GA11991@uranus.ravnborg.org> <3f9a31f40901150647n7ef5b2dfuf5c588f584c2a472@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901150647n7ef5b2dfuf5c588f584c2a472@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> Hello Sam,
> 
> On Thu, Jan 15, 2009 at 8:07 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > I can disable the warnings around -rc7 if we think they are too noisy 
> > when we release the next kernel.
> 
> I will like to question the approach how you get this number '-rc7'
> 
> Do you think people can bear this noise till -rc7 or they will solve all 
> these warnings before -rc7

the noise is not bearable, it hides a lot of real bugs. We should do the 
fixes you posted and get them to Linus.

	Ingo
