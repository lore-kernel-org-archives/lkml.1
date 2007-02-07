Return-Path: <linux-kernel-owner+w=401wt.eu-S1030228AbXBGDNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030228AbXBGDNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 22:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965634AbXBGDNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 22:13:12 -0500
Received: from mx1.suse.de ([195.135.220.2]:37593 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965620AbXBGDNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 22:13:11 -0500
Date: Wed, 7 Feb 2007 04:13:04 +0100
From: Nick Piggin <npiggin@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@osdl.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Subject: Re: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem
Message-ID: <20070207031304.GB31074@wotan.suse.de>
References: <20070206054925.21042.50546.sendpatchset@linux.site> <20070206225857.GV44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206225857.GV44411608@melbourne.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 09:58:57AM +1100, David Chinner wrote:
> On Tue, Feb 06, 2007 at 09:02:01AM +0100, Nick Piggin wrote:
> > Still no independent confirmation as to whether this is a problem or not.
> > I think it is, so I'll propose this patchset to fix it. Patch 1/3 has a
> > reasonable description of the problem.
> > 
> 
> Nick, can you include a diffstat at the head of your patches? Makes
> it much easier to see what the scope of the changes are when you
> are changing code in several filesystems....

Good idea, I'll do that.

Thanks,
Nick
