Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZEKK4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZEKK4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZEKKzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:55:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37396 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751542AbZEKKzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:55:49 -0400
Date: Mon, 11 May 2009 11:55:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511115504.568c9a92@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de>
	<1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
	<m1pregmkld.fsf@fess.ebiederm.org>
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would be very careful with such statement if you want us to accept
> your namespace hacks in the future. I guess if we ask with your next
> round "do we want to to have to maintain this for forever" you get a
> very different answer than today.

Take your unpleasant threatening attitude somewhere else. There are a lot
of people very interested in namespaces.

> > I'm sorry you decided to ship the code before getting a review.  I
> > guess that is the definition of an experimental feature.  One not in
> > the upstream kernel.
> 
> No, I did decide to ship it in the distro which is how things work
> since forever. And it's not in the upstream kernel now, while this
> discussion happens.

And since forever the upstream approach has been "we don't care if you
shipped it first, that's *your* problem"

You've yet to demonstrate
- That your patches are a real speed up
- That dumping more crap in kernel without policy and management is a
  good idea
- That the other proposals are worse than yours.

Arjan produced detailed boot graphs and boots a box very fast indeed. I
see no boot graphs, no detailed analysis here. 

Instead we have obnoxious threats to Eric Biederman and an "I am going to
ram this into the kernel whatever" approach.

Neither are constructive or useful and this isn't the way the Linux
kernel project works. Yes maybe you can stuff things into Greg's tree
easily because you both work for SuSE but that isn't the right way to do
stuff for upstream.

Alan
