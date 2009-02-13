Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbZBMENx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbZBMENx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbZBMENn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 23:13:43 -0500
Received: from mx1.suse.de ([195.135.220.2]:49540 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758180AbZBMENm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 23:13:42 -0500
Date: Thu, 12 Feb 2009 20:07:47 -0800
From: Greg KH <gregkh@suse.de>
To: David Engel <david@istwok.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.16
Message-ID: <20090213040747.GA5033@suse.de>
References: <20090212180448.GC15341@kroah.com> <20090212180505.GD15341@kroah.com> <20090212180448.GC15341@kroah.com> <20090212230100.GA31159@opus.istwok.net> <20090213010827.GA8562@suse.de> <20090213011404.GB8562@suse.de> <20090213012955.GA14366@suse.de> <20090213032550.GB3721@opus.istwok.net> <20090213032958.GA4474@suse.de> <20090213034652.GA4203@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213034652.GA4203@opus.istwok.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 09:46:52PM -0600, David Engel wrote:
> On Thu, Feb 12, 2009 at 07:29:58PM -0800, Greg KH wrote:
> > On Thu, Feb 12, 2009 at 09:25:50PM -0600, David Engel wrote:
> > > On Thu, Feb 12, 2009 at 05:29:55PM -0800, Greg KH wrote:
> > > > Ok, I reverted the problem patch and released 2.6.27.17.  Please let me
> > > > know if you still have a problem with that kernel release.
> > > 
> > > I'm building 2.6.27.17 now, but I expect it to work since reverting
> > > that one patch is all I did to get 2.6.27.16 working for me.
> > 
> > Yeah, that's what I'm more concerned about.
> 
> It worked.

Great, thanks for telling me about the original problem, and testing it
out.  Sorry for the oops in the first place.

thanks,

greg k-h
