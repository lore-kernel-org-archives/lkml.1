Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXBFW73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXBFW73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030309AbXBFW72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:59:28 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:60247 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030299AbXBFW70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:59:26 -0500
Date: Wed, 7 Feb 2007 09:58:57 +1100
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@osdl.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Subject: Re: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem
Message-ID: <20070206225857.GV44411608@melbourne.sgi.com>
References: <20070206054925.21042.50546.sendpatchset@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206054925.21042.50546.sendpatchset@linux.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 09:02:01AM +0100, Nick Piggin wrote:
> Still no independent confirmation as to whether this is a problem or not.
> I think it is, so I'll propose this patchset to fix it. Patch 1/3 has a
> reasonable description of the problem.
> 

Nick, can you include a diffstat at the head of your patches? Makes
it much easier to see what the scope of the changes are when you
are changing code in several filesystems....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
