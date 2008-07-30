Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYG3SEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYG3SEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYG3SEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:04:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYG3SEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:04:47 -0400
Date: Wed, 30 Jul 2008 20:04:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] x86: use arch/x86/include
Message-ID: <20080730180411.GA7896@elte.hu>
References: <20080730124952.GA23413@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730124952.GA23413@uranus.ravnborg.org>
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

> Hi x86 guys.
> 
> It turned out to be easy to enable um to use arch/x86/include so here 
> is a git pull.

hm, we have a _ton_ of changes to include files queued up already, so 
this is rather inconvenient.

I missed the discussion on this, what's the point of renaming all these 
files?

	Ingo
