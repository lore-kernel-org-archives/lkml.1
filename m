Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbZATI0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbZATI0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZATI0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:26:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60228 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbZATIZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:25:59 -0500
Date: Tue, 20 Jan 2009 09:25:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: optimise page fault entry
Message-ID: <20090120082547.GB31473@elte.hu>
References: <20090120032426.GE16304@wotan.suse.de> <alpine.LFD.2.00.0901201605280.2915@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901201605280.2915@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4388]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 20 Jan 2009, Nick Piggin wrote:
> > 
> > Optimise x86's do_page_fault (C entry point for the page fault path).
> 
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

Applied to tip/x86/mm, with a v2.6.30 ETA, thanks guys!

	Ingo
