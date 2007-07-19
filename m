Return-Path: <linux-kernel-owner+w=401wt.eu-S940125AbXGSRE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940125AbXGSRE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933756AbXGSRET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:04:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933574AbXGSRES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:04:18 -0400
Date: Thu, 19 Jul 2007 10:03:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Josh Boyer" <jwboyer@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH -mm 0/5] Freezer update
Message-Id: <20070719100346.a9e8b12b.akpm@linux-foundation.org>
In-Reply-To: <625fc13d0707190930j381ea4f2x462a8269db269388@mail.gmail.com>
References: <200707180929.31511.rjw@sisk.pl>
	<20070718010353.27965df7.akpm@linux-foundation.org>
	<625fc13d0707190930j381ea4f2x462a8269db269388@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 11:30:54 -0500 "Josh Boyer" <jwboyer@gmail.com> wrote:

> On 7/18/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > so please consider them as 2.6.23 material.
> >
> > The door for new 2.6.23 material shut two weeks ago.  Here, at least.
> 
> So do you have a general guideline as to when you'd like patches sent
> to you for the next merge window?  The releases are fairly
> predictable, so perhaps something like one of the later -rc candidates
> for the upcoming release?
> 
> E.g. patches for 2.6.24 should be to you by 2.6.23-rc<N>?

That sounds about right.  But nothing is cast in stone here: one needs
to take into account the urgency/desirability of the change, the perceived
benefit and risk, etc.

I do prefer that material has been out in at least one -mm release before
it goes mainline.

