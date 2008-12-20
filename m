Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYLTA2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYLTA2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 19:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYLTA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 19:28:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41846 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbYLTA2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 19:28:34 -0500
Date: Sat, 20 Dec 2008 00:27:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: GIT head doesn't seem to want to build on 32bit..
Message-ID: <20081220002756.6505de5f@lxorguk.ukuu.org.uk>
In-Reply-To: <20081219220210.GB3090@uranus.ravnborg.org>
References: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0812160946410.14014@localhost.localdomain>
	<20081216181133.2342b49e@lxorguk.ukuu.org.uk>
	<20081216183817.GA25108@uranus.ravnborg.org>
	<20081217100727.5cf6248c@lxorguk.ukuu.org.uk>
	<20081219220210.GB3090@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 23:02:10 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Dec 17, 2008 at 10:07:27AM +0000, Alan Cox wrote:
> > 
> > > Smells like a kbuild issue.
> > > Please copy me and linux-kbuild@vger.kernel.org on any findings.
> > > 
> > > [My 64 bit toolchain is br0ken atm so I could not try to reproduce]
> > 
> > Yes I do indeed need to build x86_64 first, then make distclean or
> > mrproper and then 32bit build fails
> 
> Hi Alan.
> 
> Can I ask you to persuade this a bit more?

I will take a serious look at it when I get time. I hit it while fighting
a pair of ATA controller problems and really I have to sort those out
before I got back and beat up the other stuff.

Alan
