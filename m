Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbXKQMUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbXKQMUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 07:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbXKQMUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 07:20:30 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41419 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750749AbXKQMUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 07:20:30 -0500
Date: Sat, 17 Nov 2007 13:20:10 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Theodore Tso <tytso@mit.edu>, Daniel Barkalow <barkalow@iabervon.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Benoit Boissinot <bboissin@gmail.com>, Mark Lord <liml@rtr.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071117122010.GC4250@stusta.de>
References: <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <40f323d00711130752k19cab8eauc3456721274b3267@mail.gmail.com> <20071113171356.GA25824@thunk.org> <Pine.LNX.4.64.0711141810110.12193@iabervon.org> <20071115153057.GE17180@thunk.org> <Pine.LNX.4.64.0711151034340.12193@iabervon.org> <1195201202.13688.10.camel@localhost> <Pine.LNX.4.64.0711161303440.12193@iabervon.org> <20071116194617.GI11339@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071116194617.GI11339@thunk.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 02:46:18PM -0500, Theodore Tso wrote:
> On Fri, Nov 16, 2007 at 01:20:16PM -0500, Daniel Barkalow wrote:
> > Compared to getting useful suggestions from a mailing list, especially 
> > before you've gotten anybody's attention? Hours or overnight isn't 
> > particularly long, and doesn't take up much of your time if you've got a 
> > working kernel to use while it's working.
> 
> But a bisect takes around 7 compiles.
>...

I don't understand that number.

The common case are regressions in -rc1, and a bisection of
at about 7000 commits takes around 13 compiles.

>    	      	   	       		       	  - Ted

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

