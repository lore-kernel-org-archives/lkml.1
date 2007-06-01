Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbXFAROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbXFAROU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760348AbXFARON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:14:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:57432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028AbXFAROM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:14:12 -0400
Date: Fri, 1 Jun 2007 05:04:29 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       us15@os.inf.tu-dresden.de, davej@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reduce AER init error information
Message-ID: <20070601120429.GC7345@suse.de>
References: <1177832284.14017.270.camel@ymzhang> <465C3446.5020603@googlemail.com> <20070529155732.GA7068@suse.de> <alpine.LFD.0.98.0705291406000.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705291406000.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 02:06:52PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 29 May 2007, Greg KH wrote:
> > 
> > Care to forward the above patch to the stable@kernel.org address after
> > it goes into Linus's tree?
> 
> .. talking about going to my tree, where _is_ it? It's not in my mailbox, 
> at least..

I tried to get this to work for the last round of PCI patches that I
sent you yesterday, but it had build problems, which I need to spend
some time fixing up :(

thanks,

greg k-h
