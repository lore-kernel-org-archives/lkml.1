Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbZE0W20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbZE0W20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbZE0W2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:28:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44639 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602AbZE0W2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:28:19 -0400
Date: Thu, 28 May 2009 00:26:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
Message-ID: <20090527222659.GB26193@elte.hu>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-18-git-send-email-jeremy@goop.org> <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain> <20090527211828.GA6166@elte.hu> <alpine.LFD.2.01.0905271436140.3435@localhost.localdomain> <adavdnm5hkx.fsf@cisco.com> <alpine.LFD.2.01.0905271511440.3435@localhost.localdomain> <adamy8y5gsh.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamy8y5gsh.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Roland Dreier <rdreier@cisco.com> wrote:

>  > I agree that that would work, but that way also lies endless 
>  > other tags. People seem to always want to have some magic tag 
>  > to grep for, if we can make 'impact:' be it rather than have 
>  > potentially lots of random ones, maybe impact: is simply 
>  > better?
> 
> Dunno... maybe just "Tag:"?  ;)
> 
> Maybe just "git log|grep 'bug url'" is good enough without having 
> to make any special format?

There's various other categories beyond bugfixes with urls where 
impact lines are useful in practice.

	Ingo
