Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZFEHxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZFEHxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZFEHxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:53:01 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:39923 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZFEHxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:53:01 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Fri, 5 Jun 2009 02:52:59 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090605072412.GF6411@prithivi.gnumonks.org> <200906050244.51984.lkml@morethan.org>
In-Reply-To: <200906050244.51984.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906050253.01261.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 5 2009, Michael S. Zick wrote:
> On Fri June 5 2009, Harald Welte wrote:
> > On Thu, Jun 04, 2009 at 12:18:42PM -0500, Michael S. Zick wrote:
> > > > In any case, if somebody can ship me a system that exposes one of those
> > > > lock-ups, together with a pre-installed test case that exposes the problem
> > > > within let's say less than one day, plus the full kernel sources used in
> > > > that particular system:  I'm happy to spend time to investigate the issue,
> > > > try to run the same test case on a VIA board, etc.
> > > 
> > > I am about at my wits end with this Everex product -
> > > 
> > > Give me a couple more weeks at the problem and if I haven't solved it;
> > > I'll give you this machine if you promise to update LKML with any fix.
> > 
> > Well, I cannnot promise that I will actually find the problem and find a fix.
> > But I can promise to look into the issue and potentially ask other people
> > at VIA/Centaur to help with investigating it.
> > 
> > And as soon as the problem can be reproduced, or we have a fix, or I give up,
> > you would get the system back, obviously.
> > 
> 
> I would not want it back, obviously.
> 
> > I'll try to figure out how we can do the shipping while billing it to VIA's
> > account.
> >
> 
> Collect?
>  
> > In any case, let's wait until I hear from VIA if they can provide one of those
> > machines to me.
> > 
> 
> Just ask for an Everex CrapBook - they will know what you mean.
> The company went out of the NetBook business for a good reason.
> 

Oh, I am within a hundred miles of offices of the company that
FIC sold the 75% interest in Everex to - I even recognize a
few of the officer's names - not that I have seen them for years.

Mike
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


