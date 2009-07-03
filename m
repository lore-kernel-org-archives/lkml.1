Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbZGCP5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbZGCP5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbZGCP51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:57:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34380 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308AbZGCP50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:57:26 -0400
Date: Fri, 3 Jul 2009 17:57:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703155717.GA19714@elte.hu>
References: <20090703091655.GB3902@elte.hu> <20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk> <20090703095432.GC21141@elte.hu> <20090703110620.64fd1283@lxorguk.ukuu.org.uk> <20090703102234.GA32128@elte.hu> <20090703114431.37abd528@lxorguk.ukuu.org.uk> <20090703131727.GA3207@elte.hu> <20090703143746.0379b2ee@lxorguk.ukuu.org.uk> <20090703144754.GA13246@elte.hu> <20090703160230.093e422c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703160230.093e422c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > It's an argument you made on false premises.
> > 
> > The thing is, my review wasnt about old code being moved around. It 
> > was about new code being introduced by you:
> 
> Ingo, if you've nothing better to do than quote out of context and 
> be offensive, perhaps you should go fix voyager support or 
> something productive instead.

Btw., i'd like to know which reply of mine you found offensive.

Pointing out when your code is unclean does not count as an offense 
on lkml, i hope. The rest was disagreements about how to handle 
cleanups - i dont think i made any personal/offensive comment in 
this thread, nor do i intend to.

	Ingo
