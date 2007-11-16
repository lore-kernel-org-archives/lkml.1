Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbXKPTrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbXKPTrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbXKPTq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:46:58 -0500
Received: from thunk.org ([69.25.196.29]:39735 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbXKPTq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:46:57 -0500
Date: Fri, 16 Nov 2007 14:46:18 -0500
From: Theodore Tso <tytso@mit.edu>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Romano Giannetti <romanol@upcomillas.es>,
       Benoit Boissinot <bboissin@gmail.com>, Mark Lord <liml@rtr.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071116194617.GI11339@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Daniel Barkalow <barkalow@iabervon.org>,
	Romano Giannetti <romanol@upcomillas.es>,
	Benoit Boissinot <bboissin@gmail.com>, Mark Lord <liml@rtr.ca>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>, protasnb@gmail.com,
	linux-kernel@vger.kernel.org
References: <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <40f323d00711130752k19cab8eauc3456721274b3267@mail.gmail.com> <20071113171356.GA25824@thunk.org> <Pine.LNX.4.64.0711141810110.12193@iabervon.org> <20071115153057.GE17180@thunk.org> <Pine.LNX.4.64.0711151034340.12193@iabervon.org> <1195201202.13688.10.camel@localhost> <Pine.LNX.4.64.0711161303440.12193@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711161303440.12193@iabervon.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 01:20:16PM -0500, Daniel Barkalow wrote:
> Compared to getting useful suggestions from a mailing list, especially 
> before you've gotten anybody's attention? Hours or overnight isn't 
> particularly long, and doesn't take up much of your time if you've got a 
> working kernel to use while it's working.

But a bisect takes around 7 compiles.  And even when it takes only an
hour, that's enough time for you to get started working on something
else, and saving all of your context so you can at that point try
booting into a kernel really is quite annoying.  Hence the suggestion
for a way for users to download commonly used snapshot points for
bisect runs.  Yes, it will require some central infrastructure, but if
it allows for more distributed debugging, this would be a good thing.

   	      	   	       		       	  - Ted
