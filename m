Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZAEMce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZAEMce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZAEMc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:32:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60541 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZAEMcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:32:25 -0500
Date: Mon, 5 Jan 2009 13:32:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090105123202.GB29758@elte.hu>
References: <20090105092110.GA11941@elte.hu> <20090105093931.GA17944@uranus.ravnborg.org> <20090105101006.GA2059@elte.hu> <20090105.023654.61507348.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105.023654.61507348.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 5 Jan 2009 11:10:06 +0100
> 
> > That is quite backwards, no matter how i look at it. Why doesnt Sparc do 
> > the obvious and turn off -Werror until it has gotten around to fix those 
> > few remaining warnings?
> 
> Are you kidding me?
> 
> -Werror has been on for 5+ years under arch/sparc, and the tree in those 
> subdirectories always built warning free.
> 
> For crying out loud, Sam and I are asking for a few days to freshen up 
> these patches so they build properly.  What is the big deal?
>
> The changes will go in, probably within the next week, just give us a 
> chance to fix them up.
> 
> I really can't believe what a big stink is being made in response to an 
> arch maintainer and one of his helpers wanting to clean up a patch 
> before it gets integrated.

I'm glad that things are accelerating that it will only take a few days 
now. Your earlier reaction of asking Andrew to remove it from -mm gave me 
the opposite impression - your reactions made it seem as if you saw it the 
duty of Sam to fix any problems with this patch.

Thanks,

	Ingo
