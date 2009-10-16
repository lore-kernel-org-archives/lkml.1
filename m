Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZJPH0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZJPH0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZJPH0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:26:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50695 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbZJPH0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:26:42 -0400
Date: Fri, 16 Oct 2009 09:25:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: david@lang.hm
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: removing existing working drivers via staging
Message-ID: <20091016072555.GB30019@elte.hu>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de> <200910152020.13080.bzolnier@gmail.com> <20091015184656.GA29858@suse.de> <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm> <4AD77AC3.7040905@s5r6.in-berlin.de> <alpine.DEB.2.00.0910151244561.22169@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910151244561.22169@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* david@lang.hm <david@lang.hm> wrote:

>> Hence the timeline of 3 releases per <20091015164726.GA10125@suse.de>
>> affects developers/ janitors much more than end users.
>
> it may be that I've jumped the gun here with my concerns, and should 
> just wait until something actually gets moved to staging to see what 
> the actual policies are going to be in practice, but the policies as 
> written seem to be very loose.

Note that nothing has changed: the same fine folks who worked for 15+ 
years to give you the OS with the most built-in drivers on this planet 
(more than 3000 drivers today and counting) are handling this too.

Please dont assume that this trend is now being reversed - to the 
contrary - Linux being able to boot out of box on 99% of the systems
out there is one of our biggest strengths.

	Ingo
