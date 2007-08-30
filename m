Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbXH3Oud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbXH3Oud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXH3OuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:50:13 -0400
Received: from [212.12.190.120] ([212.12.190.120]:33051 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761913AbXH3OuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:50:10 -0400
From: Al Boldi <a1426z@gawab.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Designers and Builders (was: Who wants to maintain KR list for stable releases?)
Date: Thu, 30 Aug 2007 17:50:20 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200708300731.24413.a1426z@gawab.com> <200708301654.24516.a1426z@gawab.com> <20070830141746.GC9260@stusta.de>
In-Reply-To: <20070830141746.GC9260@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301750.20873.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Aug 30, 2007 at 04:54:24PM +0300, Al Boldi wrote:
> > Adrian Bunk wrote:
> > > On Thu, Aug 30, 2007 at 07:31:24AM +0300, Al Boldi wrote:
> > > > Adrian Bunk wrote
> > > >
> > > > > Tracking feature or implementation suggestions wouldn't make
> > > > > sense. Consider e.g. that there are several people on linux-kernel
> > > > > who often write what they think the kernel should do but who never
> > > > > write a single line of code themselves. There's no value in
> > > > > tracking such stuff.
> > > >
> > > > There are designers, and there are builders.
> > > >
> > > > Can you tell me who is more important?
> > >
> > > That's a distinction that doesn't exist in practice:
> > >
> > > Designing kernel features requires good knowledge of the area of the
> > > kernel that should be changed.
> > >
> > > IOW: If you don't have the skills to implement it yourself you don't
> > > have the skills to do any good design.
> >
> > I might agree with you on this wrt hacking around the kernel, but when
> > it comes to introducing new subsystems, then we have a two fold
> > situation:
> >
> >   1.  Designing the internals of the new subsystem
> >   2.  Interfacing it with the rest of the kernel
> >
> > Part 1 is completely independent of the implementation, it's part 2 that
> > needs intricate implementation knowledge.
>
> That's a perfect approach that works NOT.
>
> Your subsystem needs to interact with the VFS or the block layer or
> whatever else parts of the kernel.
>
> If you had ever written kernel code you would have known that your
> statement wasn't true.
>
> > We recently had an example of this:  kexec based hibernation
> >
> > So, what's wrong with tapping into people's design suggestions, and
> > allowing others to implement it?
>
> People soon realize that you are making a fool of yourself when your
> suggestions show that you don't have a clue what you are talking about.
>
> There's nothing wrong if this is the desired effect...

I really didn't expect this kind of a response, but I guess when somebody 
runs out of arguments, then that's probably one of the responses to expect.

Really sad.


Thanks anyway!

--
Al

