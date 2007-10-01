Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbXJAF6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbXJAF6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbXJAFzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:55:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32974 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbXJAFza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:55:30 -0400
Date: Mon, 1 Oct 2007 07:55:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20071001055514.GA30165@elte.hu>
References: <1191179736.6417.10.camel@earth> <1191217993.28797.5.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191217993.28797.5.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Sun, 2007-09-30 at 21:15 +0200, Dmitry Adamushko wrote:
> > 
> > remove obsolete code -- calc_weighted()
> > 
> 
> Here's another piece of low hanging obsolete fruit.
> 
> Remove obsolete TASK_NONINTERACTIVE.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

thanks, applied.

	Ingo
