Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYIZWIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYIZWIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYIZWHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:07:48 -0400
Received: from mx1.suse.de ([195.135.220.2]:46280 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbYIZWHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:07:48 -0400
Date: Fri, 26 Sep 2008 15:04:32 -0700
From: Greg KH <gregkh@suse.de>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20080926220432.GB9762@suse.de>
References: <20080925042108.GA3931@suse.de> <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com> <20080925205328.GB11225@suse.de> <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com> <20080925220454.GA12116@suse.de> <f7848160809251522s4e589b9eu7a4fc9566d2b25e9@mail.gmail.com> <48DD2BA3.7050808@s5r6.in-berlin.de> <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com> <20080926201917.GA2591@suse.de> <c384c5ea0809261400u43a3ee57y62083d20867f1cc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c384c5ea0809261400u43a3ee57y62083d20867f1cc6@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 11:00:17PM +0200, Leon Woestenberg wrote:
> Hello,
> 
> On Fri, Sep 26, 2008 at 10:19 PM, Greg KH <gregkh@suse.de> wrote:
> > On Fri, Sep 26, 2008 at 04:11:49PM -0400, Parag Warudkar wrote:
> >> On Fri, Sep 26, 2008 at 2:36 PM, Stefan Richter
> >> <stefanr@s5r6.in-berlin.de> wrote:
> >
> > If you really don't like it, just never enable any of these modules,
> > you'll never be bothered by it.
> >
> I would like new drivers for new devices to live into the wild.
> 
> Seriously, I think it's a good think to have new drivers lift along
> with the kernel source distribution to get *much* wider attention,
> testing, hacking and feedback.
> 
> I propose GREG_GOES_WILD and I will happily commit my
> driver-in-progress to the kernel staging areas instead of to some
> two-people-know-about-it-location.

Great, send them on over, I am already starting to queue them up (have 3
network drivers and one USB drivers in the tree, with more to come.)

thanks,

greg k-h
