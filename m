Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbXLEUYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbXLEUYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXLEUYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:24:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35756 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbXLEUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:24:39 -0500
Date: Wed, 5 Dec 2007 21:24:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] UML - change sigcontext fields to match x86
Message-ID: <20071205202416.GC14570@elte.hu>
References: <20071205163024.GA7241@c2.user-mode-linux.org> <20071205164816.GB25641@elte.hu> <20071205180959.GA7934@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205180959.GA7934@c2.user-mode-linux.org>
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


* Jeff Dike <jdike@addtoit.com> wrote:

> On Wed, Dec 05, 2007 at 05:48:16PM +0100, Ingo Molnar wrote:
> > thanks, we indeed missed those. Should we carry this in x86.git, or 
> > would you like to carry this in your UML tree?
> 
> Probably better for it to go in x86.git - that way it travels with 
> your sigcontext patch.

ok, added it.

	Ingo
