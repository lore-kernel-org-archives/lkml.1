Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYIYU5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYIYU5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYIYU4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:56:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:55656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbYIYU4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:56:39 -0400
Date: Thu, 25 Sep 2008 13:53:28 -0700
From: Greg KH <gregkh@suse.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20080925205328.GB11225@suse.de>
References: <20080924230054.GA27730@suse.de> <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com> <20080925020608.GA13869@suse.de> <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com> <20080925042108.GA3931@suse.de> <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 07:02:28AM -0400, Parag Warudkar wrote:
> On Thu, Sep 25, 2008 at 12:21 AM, Greg KH <gregkh@suse.de> wrote:
> 
> >
> > It is not different, except by name only.  Don't bike-shed :)
> 
> The whole concept is a bike shed - disproportionate importance to
> labeling same things with different name.
> So it should come as no surprise that we are discussing the need for
> trivial duplications.

Heh, ok, so the basic premise of getting code that is not currently in
mergable shape into the tree earlier to get wider usage and testing is
something that you agree with?

If so, we can arm-wrestle over what to call it, one name is as good as
another, as long as we don't overload a currently used name like
EXPERIMENTAL, which Paul has so well explained is a mess right now.  And
I don't have the inclination to clean up that mess right now, I'm more
worried about bigger messes like these 15 horrible drivers I'm currently
sitting on in -staging.

If not, please let me know your objections.

thanks,

greg "green! The bikeshed must be green!" k-h
