Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbZLLAkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbZLLAkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761455AbZLLAj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:39:59 -0500
Received: from kroah.org ([198.145.64.141]:56015 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758583AbZLLAj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:39:58 -0500
Date: Fri, 11 Dec 2009 16:39:16 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING patches for 2.6.33-git
Message-ID: <20091212003916.GA12240@kroah.com>
References: <20091211212704.GC6624@kroah.com>
 <alpine.LFD.2.00.0912111527480.3526@localhost.localdomain>
 <20091211234017.GA11006@kroah.com>
 <20091211162323.1ec395b6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211162323.1ec395b6.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 04:23:23PM -0800, Randy Dunlap wrote:
> On Fri, 11 Dec 2009 15:40:17 -0800 Greg KH wrote:
> 
> > On Fri, Dec 11, 2009 at 03:29:09PM -0800, Linus Torvalds wrote:
> > > 
> > > 
> > > On Fri, 11 Dec 2009, Greg KH wrote:
> > > >
> > > > Here is the big staging merge for the 2.6.33-git tree
> > > 
> > > "B.A.T.M.A.N. Advanced Meshing Protocol"?
> > 
> > I just take the patches, I don't pick the names :)
> > 
> > > Oh, and I think I found a bug in BATMAN already: if you say 'no' to him, 
> > > he still asks whether you want to debug him. 
> > > 
> > > Please, Greg, teach BATMAN that "No means no!". 
> > 
> > Doh, I have a patch for that around here from Randy, it didn't make it
> > in...  Hm, no, he didn't send the patch, just pointed it out.  Here it
> > is below, or you can pull from the same tree and get it:
> > 
> > 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/
> > 
> 
> but one of the maintainers did you send a patch for this...

Well, kind of.  It was stuck in the middle of a 10 patch series, 8 of
them didn't even apply to the tree at all as they were diffed against a
different kernel tree.  They said they would resubmit them soon when
they got the kinks worked out of their system...

thanks,

greg k-h
