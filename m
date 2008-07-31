Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYGaDuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYGaDuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYGaDt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:49:57 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:50548 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbYGaDt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:49:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAHfQkEh5LDlw/2dsb2JhbACLHqVm
X-IronPort-AV: E=Sophos;i="4.31,283,1215354600"; 
   d="scan'208";a="161163191"
Date: Thu, 31 Jul 2008 13:49:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.27
Message-ID: <20080731034952.GC13395@disturbed>
Mail-Followup-To: Lachlan McIlroy <lachlan@sgi.com>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, akpm@linux-foundation.org
References: <20080731025328.6328358C4C3F@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731025328.6328358C4C3F@chook.melbourne.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 12:53:28PM +1000, Lachlan McIlroy wrote:
> The following changes since commit c9272c4f9fbe2087beb3392f526dc5b19efaa56b:
>   Linus Torvalds (1):
>         Merge branch 'hotfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6
> 
> are available in the git repository at:
> 
>   git://oss.sgi.com:8090/xfs/xfs-pull for-linus
.....
> 
> Lachlan McIlroy (11):
>       [XFS] Use the generic xattr methods.
.....
>       [XFS] Use the generic xattr methods.

BTW, that's a patch from Christoph, so there's a mistake in the
author of that patch. I don't know why there's duplicates of it
in the tree - the only thing I can see is that the committer's
email address is not stable. There is a growing number of
duplicate commits like this in the XFS tree.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
