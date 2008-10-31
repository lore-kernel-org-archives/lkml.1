Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYJaBsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYJaBsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYJaBr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:47:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033AbYJaBr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:47:59 -0400
Date: Thu, 30 Oct 2008 18:47:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "J.R. Mauro" <jrm8005@gmail.com>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: merging other repos into linux-2.6
In-Reply-To: <3aaafc130810301834w554fbd33p6f423ffef77e92aa@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810301843220.21084@nehalem.linux-foundation.org>
References: <20081030054944.GA19035@kroah.com> <3aaafc130810301834w554fbd33p6f423ffef77e92aa@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Oct 2008, J.R. Mauro wrote:
> 
> But if this is as hard to do properly as Linus says, I would be wary of 
> the precedent merging in their history might set. Suddenly we could have 
> tons of developers clamoring for the same treatment.

I don't think it's _hard_. But I think it does require some effort. 

Quite frankly, if it comes from CVS, I expect the logs, for example, to be 
totally inappropriate. I've never ever seen a CVS project that has sane 
commit messages (ok, so they're not "commits" in CVS, but you know what I 
mean).

That's just one example. I'm not willing to pull history if it's full of 
crap. Pulling history for "history's sake" is worthless. The end result 
has to actually be meaningful and help _future_. 

So I strongly suspect that an "automated" history merge is simply not 
appropriate, and almost certainly results in an end result that is not up 
to snuff. And the question is whether anybody is willing to actually put 
in the effort to make the history actually be useful.

		Linus
