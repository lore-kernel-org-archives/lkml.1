Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZC0Pqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZC0Pqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZC0PqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:46:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:57580 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752281AbZC0PqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:46:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Rk8ptZk/RXx1eeNTb3nr258Oy9cybMr13+2ilBf
	4+dqTGhEJ0+fjp
Subject: Re: Linux 2.6.29
From: Mike Galbraith <efault@gmx.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LRH.2.00.0903271552080.11064@vixen.sonytel.be>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <200903271435.23116.hpj@urpla.net>
	 <alpine.LRH.2.00.0903271552080.11064@vixen.sonytel.be>
Content-Type: text/plain; charset=utf-8
Date: Fri, 27 Mar 2009 16:46:17 +0100
Message-Id: <1238168777.5969.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 15:53 +0100, Geert Uytterhoeven wrote:
> On Fri, 27 Mar 2009, Hans-Peter Jansen wrote:
> > Am Dienstag, 24. März 2009 schrieb Linus Torvalds:
> > > This obviously starts the merge window for 2.6.30, although as usual,
> > > I'll probably wait a day or two before I start actively merging.
> > 
> > It would be very nice, if you could start with a commit to Makefile, that 
> > reflects the new series: e.g.:
> > 
> > VERSION = 2
> > PATCHLEVEL = 6
> > SUBLEVEL = 30
> > EXTRAVERSION = -pre
> > 
> > -pre for preparing state.
> 
> If you're using the kernel-of-they-day, you're probably using git, and
> CONFIG_LOCALVERSION_AUTO=y should be mandatory.

I sure hope it never becomes mandatory, I despise that thing.  I don't
even do -rc tags.  .nn is .nn until baked and nn.1 appears.

(would be nice if baked were immediately handed to stable .nn.0 instead
of being in limbo for a bit, but I don't drive the cart, just tag along
behind [w. shovel];)

	-Mike

