Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYJQVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYJQVsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYJQVsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:48:12 -0400
Received: from kroah.org ([198.145.64.141]:56387 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752194AbYJQVsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:48:11 -0400
Date: Fri, 17 Oct 2008 14:44:49 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017214449.GC3585@kroah.com>
References: <20081016002509.GA25868@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com> <20081017174657.GH2221@kroah.com> <200810172106.29154.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810172106.29154.bzolnier@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 09:06:28PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Friday 17 October 2008, Greg KH wrote:
> > On Fri, Oct 17, 2008 at 01:16:38AM -0700, Steven Noonan wrote:
> > > I believe some of Adrian's concerns are valid. Userspace programs will
> > > indeed break, largely because some depend on build-time and run-time
> > > checks for the kernel version being >=2.6.0 or >=2.4.0 and so forth. I
> > > suspect the best way to prove userspace breakage would be to make a
> > > branch of the kernel with a new versioning scheme (8.10, 2008.10,
> > > whatever) and use that as the installed kernel while building a Gentoo
> > > system. I suspect you'd see massive breakage.
> > 
> > That would be trivial for me to test, IFF we want to do something like
> > this.
> > 
> > But again, that's a technical thing, that can be solved _IFF_ we want to
> > change things.
> > 
> > And that's my point here, do we want to change the current numbering
> > scheme as people have expressed annoyances of the current one.
> 
> Numbering scheme?  I thought we should all be using the official
> kernel version NAME after the -final release?  Was I mistaken?
> 
> PS1 seems like somebody forgot to update it for 2.6.27...

Cool, that means I get to do it :)

thanks,

greg k-h
