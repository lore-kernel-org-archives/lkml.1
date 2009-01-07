Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbZAGBFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbZAGBFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbZAGBFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:05:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:55898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758662AbZAGBFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:05:02 -0500
Date: Wed, 7 Jan 2009 02:05:01 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090107010501.GA3390@wotan.suse.de>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106150804.2697e0c2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106150804.2697e0c2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:08:04PM -0800, Andrew Morton wrote:
> (suitable cc's added)
> 
> On Tue, 6 Jan 2009 17:57:44 -0500
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > > mm-invoke-oom-killer-from-page-fault.patch
> > > mm-invoke-oom-killer-from-page-fault-fix.patch
> > > mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
> > 
> > Just implementing this behaviour for x86 and uml is extremly
> > counter-productive.  Please fix up all architectures as this
> > behaviour needs to be the same on all ports (at least those
> > with a MMU)
> 
> Yes, that would be nice.  

Yes I will do that. I cc'ed the linux-arch list a few times with hints ;)
But if this is now going upstream I'll do a quick pass to convert the rest
for 2.6.29.

