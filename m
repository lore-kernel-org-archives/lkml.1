Return-Path: <linux-kernel-owner+w=401wt.eu-S1764625AbYEFQ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764625AbYEFQ6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYEFQ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:58:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51380 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbYEFQ6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:58:33 -0400
Date: Tue, 6 May 2008 18:58:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Yinghai Lu <yhlu.kernel.send@gmail.com>, Dave Jones <davej@redhat.com>
Subject: Re: [git pull] PCI updates for 2.6.26
Message-ID: <20080506165802.GB7801@elte.hu>
References: <200804291012.21832.jbarnes@virtuousgeek.org> <20080429202632.GA4967@elte.hu> <20080429210921.GA24067@elte.hu> <200805050945.39298.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805050945.39298.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tuesday, April 29, 2008 2:09 pm Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > > there are a few other PCI items in x86.git btw that you might want to
> > > have a look at and which you might want to pick up into your tree -
> > > they dont really belong into x86.git.
> >
> > there's some PCI impact in the "x86 GART" topic tree below, could you
> > have a look whether you can see anything objectionable:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-gart.git
> > for-linus
> >
> > if not we'd like to send this to Linus - those changes are stable and
> > tested.
> 
> Not sure I'm the right person to look at these, but they seem fine to 
> me.

was trolling for some extra review - the code _does_ touch a tiny bit of 
PCI code after all ;) Anyway, it's now delayed to v2.6.27, so if there's 
any problem with it we'll see it in linux-next/mm.

	Ingo
