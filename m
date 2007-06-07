Return-Path: <linux-kernel-owner+w=401wt.eu-S966725AbXFGXE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966725AbXFGXE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbXFGXES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:04:18 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50297 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbXFGXES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:04:18 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Date: Thu, 7 Jun 2007 19:04:12 -0400
User-Agent: KMail/1.9.6
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
References: <20070607162251.5f291325@the-village.bc.nu> <200706071832.13486.dhazelton@enter.net> <9a8748490706071546k1f34a39s92102f7345ba4192@mail.gmail.com>
In-Reply-To: <9a8748490706071546k1f34a39s92102f7345ba4192@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071904.12762.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007 18:46:25 Jesper Juhl wrote:
> On 08/06/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Thursday 07 June 2007 17:17:18 Krzysztof Halasa wrote:
> > > Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > > > The intel-rng printed a nice well formatted message when the port was
> > > > disabled. Someone then came along and blindly trashed it by screwing
> > > > up a trim down to 80 columns.
> > >
> > > Perhaps we should drop that 80-column style and use some 120+?
> > > X or no X, almost all people now have more lines and columns on their
> > > displays than MDA 20 years ago.
> > >
> > > 132 to match text VGA perhaps?
> > > 80 can be left for the actual _output_, I mean number of chars printed
> > > by kernel code.
> >
> > Why? My consoles are *all* still 80x24 text mode. It's only if I decide
> > to monkey with the settings (and why fix what isn't broken?) or when I'm
> > in X that I get a bigger screen than that.
> >
> > I think the general consensus on the 80 character lines isn't for the
> > average home user, but for the people that have things like old Wyse
> > terminals and such hooked up.
>
> Hmm, perhaps my eyes are just not as good as other peoples, but my X
> runs at 1600x1200 and I have konsole in KDE configured so that when it
> is maximized it is very close to a 80x25 window (actually it is 82x31
> with a size 18 font).
> Nice and readable, if I make the font any smaller to fit more
> cols/rows then the text gets too small and my eyes hurt.
> Reading kernel code formatted for 80cols fits perfectly for me.

I know the feeling Jesper. There are times when I like to take my glasses off 
and set them to the side. When I do that I usually also kill X and work using 
nothing more than the console. The why is simple - my eyes are just that bad. 
If I stay in X and try to use it I wind up with a massive headache after only 
thirty minutes or so.

DRH

