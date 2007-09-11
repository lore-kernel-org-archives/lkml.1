Return-Path: <linux-kernel-owner+w=401wt.eu-S966771AbXIKUPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966771AbXIKUPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934075AbXIKUFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:05:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276AbXIKUFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:05:21 -0400
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
From: Peter Zijlstra <peterz@infradead.org>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
In-Reply-To: <75b66ecd0709111138xb5f6120qee40345378b188eb@mail.gmail.com>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
	 <1189532202.21778.84.camel@twins>
	 <75b66ecd0709111138xb5f6120qee40345378b188eb@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 20:52:14 +0200
Message-Id: <1189536734.5739.2.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-09-11 at 14:38 -0400, Lee Revell wrote:
> On 9/11/07, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2007-09-11 at 10:16 -0700, Randy Dunlap wrote:
> >
> > > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > +Evolutions (GUI)
> >
> > I take it you mean: Evolution
> >
> > > +Some people seem to use this successfully for patches.
> > > +
> > > +What config options are needed?
> >
> > When composing mail select: Preformat
> >   from Format->Heading->Preformatted (Ctrl-7)
> >   or the toolbar
> >
> > Then use:
> >   Insert->Text File... (Alt-n x)
> >
> > to insert the patch.
> 
> You can also diff -Nru old.c new.c | xclip, select Preformat, then
> paste with the middle button.

Ah, I shall try:

  cat `quilt top` | xclip

next time I have a single patch to send.

