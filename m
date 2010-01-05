Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800Ab0AEP0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0AEP0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339Ab0AEP0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:26:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab0AEP0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:26:05 -0500
Date: Tue, 5 Jan 2010 07:26:12 -0800
From: Greg KH <gregkh@suse.de>
To: Jake Edge <jake@lwn.net>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [PATCH 97/97] Linux 2.6.32.3-rc1
Message-ID: <20100105152612.GA18897@suse.de>
References: <20100105003133.GA7199@kroah.com> <1262651630-7354-97-git-send-email-gregkh@suse.de> <20100104181307.2eb47785@chukar> <20100105145854.GA11988@suse.de> <20100105081000.0c570fd2@chukar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105081000.0c570fd2@chukar>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 08:10:00AM -0700, Jake Edge wrote:
> On Tue, 5 Jan 2010 06:58:54 -0800 Greg KH wrote:
> > On Mon, Jan 04, 2010 at 06:13:07PM -0700, Jake Edge wrote:
> > > On Mon,  4 Jan 2010 16:33:50 -0800 Greg Kroah-Hartman wrote:
> > > 
> > > > +EXTRAVERSION = .3-rc1
> > > 
> > > This looks like a typo.  Why the '-rc1'?
> > 
> > I'm curious as to why you feel this is a typo when I was announcing
> > the release of the 2.6.32.3-rc1 kernel?
> 
> my apologies, i thought you were announcing the review of the 2.6.32.3
> kernel.  it would seem i misunderstood, but i hadn't noticed patches
> like this in previous stable reviews, and i thought that version string
> would end up in the 2.6.32.3 release, which, i think anyway, would be
> wrong.

Yes, I did do it differently this time, using git format-patch due to
the way some of the patches were, which made it easier this way.

Sorry for any confusion.

greg k-h
