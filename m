Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbZLJVt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbZLJVt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761703AbZLJVt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:49:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761143AbZLJVt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:49:56 -0500
Date: Thu, 10 Dec 2009 22:49:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Xavier Bestel <xavier.bestel@free.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm
Message-ID: <20091210214948.GA14185@elte.hu>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
 <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
 <1260459601.18520.26.camel@skunk>
 <20091210164718.6b0acb59@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210164718.6b0acb59@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Last time they were asked that, they wanted to be free of changing their
> > kernel/userspace interface before upstreaming.
> 
> So put it in staging with a note to that effect. That'll also get it 
> more exposure and review.

Well, arguably that particular idea should have come from the people 
maintaining that area of code. There's this one missing driver which 
covers (more or less) like 40%-50% of the PC market, that's a glaringly 
significant issue, isnt it? It doesnt get any more significant, does it?

	Ingo
