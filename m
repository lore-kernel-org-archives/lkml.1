Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXCUNvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXCUNvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXCUNvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:51:00 -0400
Received: from thunk.org ([69.25.196.29]:46552 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbXCUNu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:50:59 -0400
Date: Wed, 21 Mar 2007 09:50:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070321135033.GA7235@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Matt Mackall <mpm@selenic.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron> <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron> <20070320135231.GA6043@thunk.org> <1174406395.30079.139.camel@zod.rchland.ibm.com> <20070320220312.GC29493@thunk.org> <1174466675.17249.182.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174466675.17249.182.camel@sauron>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 10:44:35AM +0200, Artem Bityutskiy wrote:
> > As I mentioned to you in IRC, in the future if there is pending
> > changes in response to reviewer comments, it might be a good idea to
> > mention that, so that reviewers know not make those comments again, or
> > worry that the comments had been ignored.
> 
> Teo, I wrote you 2 times that your point was understood and this would
> be fixed. You should not think your comments are ignored because they
> are not.

Artem, no need to be defensive.  You did tell me that you were going
to address them; but then you resubmitted patches where they weren't
address.  Normally, patch authors take all of the comments, clear them
all, and then in the next repost of the patch, either explain why it
wasn't feasible to handle some of the comments, *OR* why some of the
comments were so hard to handle that they wouldn't be handled until a
future version of the patch.  Furthermore, in a patch of the size that
you are submitting, a listing of what you *did* fix would also be
good.  

And at this point, I don't doubt that you will at some point going to
heed my comments --- but note that doing so will involve a massive
refactorization of the code, which will tend to invalidate the reviews
done of this current (take 3) version of the patches; so I am bit
curious what was your motiviation in reposting this round of the
patches.  

Believe it or not, the people who are responding on this thread are
trying to help.  Otherwise they would just be ignoring you and UBI.
Keeping this thought in mind and trying to help them, where in some
cases perhaps they are lacking in the same knowledge and experience
and those who have been working on UBI and have spent many months
thinking about the problem, may help keep things more constructive.

Regards,

						- Ted
