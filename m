Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXGYGsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXGYGsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXGYGsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:48:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:54064 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752059AbXGYGsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:48:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1//aUZdyhv/7SXZr4EPy9Zej2Onw5Vba6/r2qHmrJ
	UciI9FLoWrjcwM
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
From: Mike Galbraith <efault@gmx.de>
To: Matthew Hawkins <darthmdh@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric St-Laurent <ericstl34@sympatico.ca>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>,
       linux-mm@kvack.org, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>
In-Reply-To: <b21f8390707242319gb17e4c9h274635b4c7fc1801@mail.gmail.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <46A57068.3070701@yahoo.com.au>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au>
	 <b21f8390707242319gb17e4c9h274635b4c7fc1801@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 08:47:56 +0200
Message-Id: <1185346076.6528.12.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 16:19 +1000, Matthew Hawkins wrote:
> On 7/25/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Not to say that neither fix some problems, but for such conceptually
> > big changes, it should take a little more effort than a constructed test
> > case and no consideration of the alternatives to get it merged.
> 
> Swap Prefetch has existed since September 5, 2005.  Please Nick,
> enlighten us all with your "alternatives" which have been offered (in
> practical, not theoretical form) in the past 23 months, along with
> their non-constructed benchmarks proving their case and the hordes of
> happy users and kernel developers who have tested them out the wazoo
> and given their backing.  Or just take a nice steaming jug of STFU.

Heh.  Here we have a VM developer expressing his interest in the problem
space, and you offer him a steaming jug of STFU because he doesn't say
what you want to hear.  I wonder how many killfiles you just entered.

	-Mike

