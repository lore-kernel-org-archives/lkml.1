Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYJQVsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYJQVsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYJQVsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:48:11 -0400
Received: from kroah.org ([198.145.64.141]:56383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752194AbYJQVsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:48:10 -0400
Date: Fri, 17 Oct 2008 14:44:09 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017214409.GB3585@kroah.com>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com> <20081017204723.15114eaa@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017204723.15114eaa@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 08:47:23PM +0100, Alan Cox wrote:
> > And that's my point here, do we want to change the current numbering
> > scheme as people have expressed annoyances of the current one.
> 
> But any new scheme will be just as annoying to someone and it messes up
> existing documentation, understanding and risks breaking third party
> tools.
> 
> Is it really worth the hassle, plus we'll have to change again if we use
> date/times because once we are shipping Linux out to Alpha Centauri with
> colonists there will be serious problems trying to compute the effect of
> tau on release numbering ...

Sure, but by then, the 2.6.521 release will be out and we could fix it
up by finally going to 3.0 :)

Seriously, am I the only one that is getting annoyed by our version
numbers?  If so, I can live with it, but I got the feeling that I wasn't
alone here.

thanks,

greg k-h
