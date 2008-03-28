Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYC1Ovw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYC1Ovw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbYC1Olx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:41:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51330 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758689AbYC1Olv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:41:51 -0400
Date: Fri, 28 Mar 2008 15:41:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080328144116.GG29218@elte.hu>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <2f11576a0803271008t7574ead1s9ea285d8df57ef1@mail.gmail.com> <20080328101500.GF30863@elte.hu> <y0mabkjvufd.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mabkjvufd.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> > [...]  furthermore, and because it's Friday again, let me remind 
> > folks that SystemTap has an even more significant bloat problem: the 
> > fact that it needs a huge download: [...the dwarf debugging 
> > information...]
> 
> It's a problem, and there are a few improvements under way or being 
> contemplated: [...]

it's been the primary usability problem ever since SystemTap has been 
incepted 3 years ago. The 229+850 MB size numbers i cited were from a 
bleeding-edge (Fedora 9 beta) distro. So whatever is being contemplated, 
it's not here today.

	Ingo
