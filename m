Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYHECIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYHECIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 22:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYHECFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 22:05:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:42342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYHECFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 22:05:41 -0400
Date: Tue, 5 Aug 2008 04:05:39 +0200
From: Nick Piggin <npiggin@suse.de>
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com,
       xen-devel@lists.xensource.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [rfc][patch 3/3] xfs: use new vmap API
Message-ID: <20080805020539.GA15075@wotan.suse.de>
References: <20080728123438.GA13926@wotan.suse.de> <20080728123703.GC13926@wotan.suse.de> <4896A197.3090004@sgi.com> <200808042057.20607.nickpiggin@yahoo.com.au> <4897B05A.7040002@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897B05A.7040002@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assuming patch 1 gets merged upstream, I think Andrew would normally send
off 2 and 3 to the XFS maintainers at that point (ie. when its prerequisites
are upstream) for you to merge. 

On Tue, Aug 05, 2008 at 11:43:54AM +1000, Lachlan McIlroy wrote:
> Okay.  When the time comes will you push the XFS changes to mainline
> or would you like us to?
> 
> Nick Piggin wrote:
> >Thanks for taking a look. I'll send them over to -mm with patch 1,
> >then, for some testing.
> >
> >On Monday 04 August 2008 16:28, Lachlan McIlroy wrote:
> >>Looks good to me.
> >>
> >>Nick Piggin wrote:
> >>>Implement XFS's large buffer support with the new vmap APIs. See the vmap
> >>>rewrite patch for some numbers.
