Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbYFLNJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbYFLNJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759026AbYFLNJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:09:43 -0400
Received: from www.tglx.de ([62.245.132.106]:33779 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786AbYFLNJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:09:42 -0400
Date: Thu, 12 Jun 2008 15:09:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 0/6] AMD C1E aware idle support
In-Reply-To: <200806121431.24305.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0806121507570.3193@apollo.tec.linutronix.de>
References: <20080610171639.551369443@linutronix.de> <200806121431.24305.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Rafael J. Wysocki wrote:
> On Thursday, 12 of June 2008, Thomas Gleixner wrote:
> > For those who are interested to test those patches on top of 2.6.26-rc
> > I extracted a patch and added it to the c1e series. It's available
> > from:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.gz
> > or
> > http://www.kernel.org/pub/linux/kernel/people/tglx/c1e/2.6.26-rc5-c1e-patches.tar.bz2
> 
> I guess the x86-next-apic-timer-fixes.patch is a combination of all patches in
> this series.  Is that correct?

Yes. It's the combi patch of everything in the x86/apic branch of
linux-2.6-tip.git.

Thanks,
	tglx
