Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbXC3Tvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbXC3Tvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXC3Tvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:51:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:46009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXC3Tvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:51:44 -0400
Date: Fri, 30 Mar 2007 12:48:54 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mitch Williams <mitch.a.williams@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.20.4] Flush MSI-X table writes (rev 3)
Message-ID: <20070330194854.GA7857@suse.de>
References: <1175281427.17652.16.camel@strongmad> <20070330190951.GA18351@suse.de> <m1ejn6il0m.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejn6il0m.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 01:33:45PM -0600, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> >
> > Sorry, but this isn't going to go into 2.6.20 any time soon as it
> > doesn't fit the rules for the -stable tree.
> >
> > But I'll take an updated version for my pci tree to go to Linus after
> > 2.6.21 is out.
> 
> Greg this does fix a bug that affects 2.6.21.  We have hardware in 2.6.21 that
> is affected And it at least seems to meet the obviously correct
> criteria.  So at least for 2.6.21 I think it is interesting.

We do?  What hardware has this reported problem showed up on?  I haven't
seen any bug reports yet.

And I think it's way too late for something like this.  If it's really
needed, I don't have a problem adding it to the 2.6.21-stable tree in a
few weeks.

thanks,

greg k-h
