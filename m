Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZAKEK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZAKEK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 23:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZAKEKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 23:10:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZAKEKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 23:10:09 -0500
Date: Sun, 11 Jan 2009 05:09:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/15] ACPICA: move common private headers under
	kernel/acpi/acpica/
Message-ID: <20090111040911.GH28520@elte.hu>
References: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com> <c6b6f68232ab6da57e764c64b23b4649c4e7c463.1230719801.git.len.brown@intel.com> <20090102191451.GB14249@elte.hu> <alpine.LFD.2.00.0901021438060.3590@localhost.localdomain> <20090107221017.GD17917@elte.hu> <20090108160304.GA30619@infradead.org> <alpine.LFD.2.00.0901082328160.4091@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901082328160.4091@localhost.localdomain>
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


* Len Brown <lenb@kernel.org> wrote:

> > On Wed, Jan 07, 2009 at 11:10:17PM +0100, Ingo Molnar wrote:
> > > i still tend to regard kernel/* as the core Linux kernel, as code that can 
> > > be improved infinitely (only subject to the laws of physics), without 
> > > having to worry about how the ACPI spec wants certain things done.
> 
> I want to move the Linux-ACPI code and the ACPICA core out of drivers/ 
> simply because they are not drivers, and never will be.

which files are these exactly, in Linus's latest tree?

	Ingo
