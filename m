Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZIRGHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZIRGHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZIRGHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:07:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:46998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZIRGHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:07:06 -0400
Date: Thu, 17 Sep 2009 22:54:23 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
	maintenance disaster
Message-ID: <20090918055423.GA7104@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ab0tcwep.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:29:18AM -0700, Eric W. Biederman wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Thu, Sep 17, 2009 at 01:23:39AM -0700, Eric W. Biederman wrote:
> >> 
> >> devtmpfs has numerous problems.  The once I see from a quick review.
> >
> > <snip>
> >
> > I'm confused, why did you not at least cc: Kay and I on this message, if
> > I was a paranoid person, I would think that you were somehow trying to
> > skirt around us for some unknown reason :(
> 
> You just aren't relevant to this discussion except where you
> repeatedly demonstrate you aren't willing to listen to anyone who
> hasn't drunk the devtmpfs coolaid.

Oh, we have official team drinks now?  Great, sign me up, can I pick a
t-shirt logo as well? :)

> If you were interested in honest review and feedback you would have
> copied me from the second review onward.  You didn't do that.  Why
> should I extend you the courtesy.  This isn't your decision to make.

I'm sorry I forgot to copy you, and the other people that provided
feedback on the original few versions, that's my fault.  I kind of
assumed that people found the first version on their own, the updates
would be in the same place as well.  I had not kept track of the
reviewers and commentors properly.

My fault, and I'm sorry.

But for you to think I was purposefully slighting you, or anyone else,
and that slight would justify completly ignoring the original authors
and submittors of the code, seems, well, a big streach.

> Greg this code does not live up to the standards you have repeatedly
> asserted are required for accepting core kernel code.  Neither you
> nor Kay show any interest in fixing even the most trivial of bugs.
> Must less discuss alternate solutions to the problem.

I'm really sorry, but I know of no existing bugs in this code.
Seriously, I thought we addressed everything that was pointed out.  A
large number of people have tested this in quite different environments,
and we got sign-off-bys by all of the boot logic infrastructure
maintainers from the major distros, as proof of that testing.

I don't know of any standards that we are not following here, what
specifically are you referring to?

thanks,

greg k-h
