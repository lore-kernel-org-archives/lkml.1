Return-Path: <linux-kernel-owner+w=401wt.eu-S965147AbXA3Eej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147AbXA3Eej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 23:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965236AbXA3Eei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 23:34:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965147AbXA3Eeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 23:34:37 -0500
Date: Mon, 29 Jan 2007 23:34:21 -0500
From: Dave Jones <davej@redhat.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Greg Ungerer <greg_ungerer@securecomputing.com>,
       linux-kernel@vger.kernel.org, ksummit-2007-discuss@thunk.org
Subject: Re: [Ksummit-2007-discuss] Re: [Ksummit-2006-discuss] 2007 Linux Kernel Summit
Message-ID: <20070130043421.GE21772@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Paul Mundt <lethal@linux-sh.org>,
	Greg Ungerer <greg_ungerer@securecomputing.com>,
	linux-kernel@vger.kernel.org, ksummit-2007-discuss@thunk.org
References: <8355959a0701251646t4b7db48cj862268aad52e8e24@mail.gmail.com> <20070126032849.GB5589@thunk.org> <8355959a0701260704x6aea8141s3d0581fa33c74cf2@mail.gmail.com> <20070126195024.GE14759@thunk.org> <45BE8BF9.6020204@sgi.com> <20070130030430.GA21772@redhat.com> <45BEBBF0.3050102@snapgear.com> <20070130034111.GB21772@redhat.com> <45BEC303.2040205@securecomputing.com> <20070130040826.GA19362@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130040826.GA19362@linux-sh.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:08:26PM +0900, Paul Mundt wrote:
 > On Tue, Jan 30, 2007 at 02:01:07PM +1000, Greg Ungerer wrote:
 > > Dave Jones wrote:
 > > >Right, other than during the CPU architects panel, I don't remember
 > > >any non x86/ia64/ppc stuff being brought up at all.
 > > 
 > > Yep. IIRC the CPU architects panel was all x86/x86_64/ppc too wasn't it?
 > > 
 > Similarly, it would be nice if we could avoid marketing oriented CPU
 > roadmap presentations this year, before any other vendors start
 > getting ideas..

It might be worth putting together a list of do's and don'ts for the
CPU architects if we have a panel again this year (and its usually
a fairly popular session, so I'd be surprised if it got dropped).
something along the lines of

Do:
- Detail what new features next-gen cpu out in Q1'08 will have
  that we may need to care about
- Ask for input on what features _we_ would like in CPUs in Q1 2010
- Tell us how we're taking advantage of things before that other OS,
  it makes us happy ;)

Don't:
- Waffle about process shrink roadmaps.
  Whilst it's good to hear, it doesn't affect the code we write.
- Moves to new substrates are fascinating to CPU manufacturers,
  not so much for kernel engineers.
- If something can't be discussed other than under NDA, don't
  bother bringing it up.  Those interested will likely find
  out about it through their employers anyway.
  This came up last year with a number of "we can't tell you"
  reponses, which made one presentation almost worthless.
  or perhaps it was particularly "we can't tell hch" :-)

Any others?

		Dave

-- 
http://www.codemonkey.org.uk
