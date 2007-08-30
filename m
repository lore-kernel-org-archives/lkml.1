Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXH3Nya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXH3Nya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXH3NyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:54:21 -0400
Received: from [212.12.190.102] ([212.12.190.102]:33024 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752415AbXH3NyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:54:20 -0400
From: Al Boldi <a1426z@gawab.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Designers and Builders (was: Who wants to maintain KR list for stable releases?)
Date: Thu, 30 Aug 2007 16:54:24 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200708300731.24413.a1426z@gawab.com> <20070830073226.GA9260@stusta.de>
In-Reply-To: <20070830073226.GA9260@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301654.24516.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Aug 30, 2007 at 07:31:24AM +0300, Al Boldi wrote:
> > Adrian Bunk wrote
> >
> > > Tracking feature or implementation suggestions wouldn't make sense.
> > > Consider e.g. that there are several people on linux-kernel who often
> > > write what they think the kernel should do but who never write a
> > > single line of code themselves. There's no value in tracking such
> > > stuff.
> >
> > There are designers, and there are builders.
> >
> > Can you tell me who is more important?
>
> That's a distinction that doesn't exist in practice:
>
> Designing kernel features requires good knowledge of the area of the
> kernel that should be changed.
>
> IOW: If you don't have the skills to implement it yourself you don't
> have the skills to do any good design.

I might agree with you on this wrt hacking around the kernel, but when it 
comes to introducing new subsystems, then we have a two fold situation:

  1.  Designing the internals of the new subsystem
  2.  Interfacing it with the rest of the kernel

Part 1 is completely independent of the implementation, it's part 2 that 
needs intricate implementation knowledge.

We recently had an example of this:  kexec based hibernation

So, what's wrong with tapping into people's design suggestions, and allowing 
others to implement it?


Thanks!

--
Al

