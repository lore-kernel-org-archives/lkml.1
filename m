Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbZEAPfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbZEAPfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZEAPfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:35:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37197 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527AbZEAPfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:35:18 -0400
Date: Fri, 1 May 2009 17:34:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/11] section name cleanup for x86
Message-ID: <20090501153434.GA11203@elte.hu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu> <20090501115849.GB24706@elte.hu> <20090501120757.GA23672@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501120757.GA23672@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Fri, May 01, 2009 at 01:58:49PM +0200, Ingo Molnar wrote:
> > 
> > * Tim Abbott <tabbott@MIT.EDU> wrote:
> > 
> > > This patch series cleans up the section names on the x86
> > > architecture.  It requires the architecture-independent macro
> > > definitions from this patch series:
> > > 
> > > <http://www.spinics.net/lists/mips/msg33499.html>
> > 
> > Hm, we cannot pick the x86 bits up into the x86 tree without 
> > having these macros upstream first. So those macros need acks 
> > from Sam and maybe Linus will take them out of order. (they are 
> > pure additions so they look fairly safe and uncontroversial)
> 
> Thats the plan.

Okay - it was a bit confusing at first because the patch-set was 
posted to us x86 maintainers but had such a generic dependency.
I'll wait for you to sort it all out :)

	Ingo
