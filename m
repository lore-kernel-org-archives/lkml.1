Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXC3U1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXC3U1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 16:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXC3U1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 16:27:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51635 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbXC3U1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 16:27:09 -0400
Date: Fri, 30 Mar 2007 13:24:13 -0700
From: Greg KH <greg@kroah.com>
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
Message-ID: <20070330202413.GA4040@kroah.com>
References: <20070330201017.GA21944@suse.de> <08FE5CC30C9A3F41BF819A502CF7BF6E0100371E@fmsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6E0100371E@fmsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 01:21:03PM -0700, Williams, Mitch A wrote:
> Greg KH wrote: 
> > 
> >> Perhaps we should put this into 2.6.22 then backport it to 
> >2.6.21.x once it
> >> seems safe to do so.  If we decide to go this way, we'll 
> >need to ask Mitch
> >> to remind us to do the backport at the appropriate time, 
> >else we'll surely
> >> forget.
> >
> >Yes, that's what I just asked him to do a message ago :)
> >
> Be happy to -- just give me a good definition of "appropriate
> time".

After it goes into Linus's tree, which will be usually the week after
2.6.21 is out.

thanks,

greg k-h
