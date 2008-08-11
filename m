Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYHKAF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYHKAF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 20:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYHKAFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 20:05:48 -0400
Received: from colo.lackof.org ([198.49.126.79]:52496 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbYHKAFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 20:05:47 -0400
Date: Sun, 10 Aug 2008 18:05:35 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Bdale Garbee <bdale@hp.com>, Grant Grundler <grundler@parisc-linux.org>,
       Adrian Bunk <bunk@kernel.org>, kyle@mcmartin.ca,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
Message-ID: <20080811000535.GB14163@colo.lackof.org>
References: <20080806211155.GV1702@cs181140183.pp.htv.fi> <20080810005511.GB2617@colo.lackof.org> <20080810010005.GL8618@parisc-linux.org> <1218375714.18157.56.camel@rover.gag.com> <20080810151433.GO8618@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810151433.GO8618@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 09:14:33AM -0600, Matthew Wilcox wrote:
...
> > If that is indeed the timing, I agree.  If not, let me know, and I'll
> > see if I can push the right buttons in HP.
> 
> http://cvs.parisc-linux.org/obsolete/linux-2.2/fs/binfmt_som.c?rev=1.8&view=log
> 
> indicates I first committed the file in June 1999 and was the majority
> committer to this file (prumpf also committed some code).  My last
> commit to it was in November 1999 (while I still worked for Genedata).

Ok - I didn't realize that.

> At some point around then, we moved to the 2.4 CVS tree:
> 
> http://cvs.parisc-linux.org/linux-2.4/fs/binfmt_som.c?rev=1.21&view=log
> 
> and there are some commits from other people at HP and myself while at
> Linuxcare and HP.

Thanks for digging this up.
I expect it should be easy for Bdale to get this rubber stamped
by any one of the HP linux kernel engineers.  HP legal shouldn't
need to be involved.



> 
> The 2.5 development tree:
> http://cvs.parisc-linux.org/linux-2.5/fs/binfmt_som.c?rev=1.3&view=log
> 
> doesn't show anything of great interest.
> 
> and the 2.6 tree represents accurately how much effort we put into SOM:
> http://cvs.parisc-linux.org/linux-2.6/fs/binfmt_som.c?rev=1.8&view=log
> 
> 
> So while HP has a legitimate claim to some parts of the file, my initial
> contributions before I worked for Linuxcare or HP were the largest and I
> don't think that anyone has a legitimate claim that this is not a
> derived work of GPL code, and hence I think Adrian's patch should be
> accepted.

I agree and apologize for my bad memory and lazy attitude. I didn't mean
to make a big deal of this - just assumed HP was the right party to
address this to.

cheers,
grant

> 
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
