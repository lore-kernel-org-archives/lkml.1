Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbXLTU3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbXLTU3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbXLTU3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:29:12 -0500
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:55028 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbXLTU3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:29:10 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Thu, 20 Dec 2007 21:29:07 +0100
User-Agent: KMail/1.9.7
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712201912.37416.volker.armin.hemmann@tu-clausthal.de> <20071220190419.GA23620@elte.hu>
In-Reply-To: <20071220190419.GA23620@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712202129.07192.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 20. Dezember 2007, Ingo Molnar wrote:
> * Hemmann, Volker Armin <volker.armin.hemmann@tu-clausthal.de> wrote:
> > On Donnerstag, 20. Dezember 2007, you wrote:
> > > Hemmann, Volker Armin wrote:
> > > > [ 5194.131014] Pid: 22490, comm: sleep Tainted: P       
> > > > 2.6.23.11reiser4 #4
> > >
> > > The subject line is wrong.
> > > You apparently run Linux, but not Linux 2.6.23.y.
> >
> > first of all, apart from this oops all other oopses I reported were
> > with a not-tainted kernel. You might want to read the other mails I
> > have sent.
> >
> > Also, besides of the reiser4 patch there is no other patch added to
> > the kernel. And since people have had successfully reported problems
> > with heavily distro-patched kernels in the past it looks a little bit
> > hypocritical to put my reports aside because of one single patch -
> > don't you think?
>
> reiser4 isnt just a single random patch, it's a huge patch with lots of
> interactions with file and memory management. Would it be hard for you
> to reproduce the crash without reiser4? (or is all your stuff on
> reiser4?)

/home (and /var, /tmp) is on reiser4 and my biggest partition. And since it 
needs up to 3 days to reproduce this - yes, hard to do without r4.

Glück Auf,
 Volker
