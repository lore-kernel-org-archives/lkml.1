Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0AONKp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292Ab0AONKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:10:44 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56331 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab0AONKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:10:43 -0500
Date: Fri, 15 Jan 2010 14:10:40 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Miller <davem@davemloft.net>, stefanr@s5r6.in-berlin.de,
        adi@hexapodia.org, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>
Subject: Re: Changelog quality
In-Reply-To: <84144f021001150444j4f7f9dexe8486d06b7e45205@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1001151407480.23543@ask.diku.dk>
References: <4B502C6B.7000802@s5r6.in-berlin.de>  <20100115.005445.263291449.davem@davemloft.net>
  <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de>  <20100115.012233.202457727.davem@davemloft.net>
  <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk> 
 <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com> 
 <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk>  <20100115110845.GB28625@sirena.org.uk>
  <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk>
 <84144f021001150444j4f7f9dexe8486d06b7e45205@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-2034232403-1263561040=:23543"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-2034232403-1263561040=:23543
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 15 Jan 2010, Pekka Enberg wrote:

> Hi Julia,
> 
> On Fri, Jan 15, 2010 at 2:06 PM, Julia Lawall <julia@diku.dk> wrote:
> > On the other hand, one has to take into account the fact that at least in
> > my case, the patches that are submitted are the ones that I have carefully
> > checked for correctness.  Having a make target in the kernel might give
> > some suggestion of quality that is perhaps not appropriate?
> 
> I don't see the problem. No tool is perfect so the only thing that
> matters is whether or not the benefits outweigh the costs. The problem
> I see with Coccinelle is that the scripts seem to be lost in a black
> hole (even if they are part of the changelog) which also means that
> your efforts don't scale.
> 
> There seems to be a universal law regarding kernel development: if
> something is out-of-tree, it simply doesn't matter from "people
> scalability" point of view. It doesn't really matter if you like it or
> not but that's the way things are right now. I, for one, would love to
> run Coccinelle on the tree I maintain but unfortunately the tool fails
> my "can I set it up in two minutes" rule so I haven't gotten around to
> give it a try. And I suspect I am not the only one.
> 
> So why not try it out? If the signal to noise ratio is too low and we
> can't fix that, we can always just remove the damn thing from the
> tree. Speculating whether or not something will work seems pretty
> pointless to me when you don't have any hard data.

We would be happy to go ahead with it, but would like to hear from others 
to be sure to be setting things up in a good way.

For other software there is a tool on our web page called coccicheck that 
runs a collection of scripts on a given directory.  But we have only put 
scripts of general interest in there.

julia
---511516320-2034232403-1263561040=:23543--
