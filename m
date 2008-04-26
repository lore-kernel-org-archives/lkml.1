Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYDZRUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYDZRUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbYDZRUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:20:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757404AbYDZRUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:20:46 -0400
Date: Sat, 26 Apr 2008 10:20:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-Id: <20080426102024.4c65624d.akpm@linux-foundation.org>
In-Reply-To: <20080426171604.GN2252@cs181133002.pp.htv.fi>
References: <1209190455.14173.13.camel@brick>
	<20080426110044.GB2252@cs181133002.pp.htv.fi>
	<20080426075132.b0fdbe13.akpm@linux-foundation.org>
	<20080426152341.GI2252@cs181133002.pp.htv.fi>
	<20080426084420.8e61c379.akpm@linux-foundation.org>
	<20080426171604.GN2252@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008 20:16:04 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> On Sat, Apr 26, 2008 at 08:44:20AM -0700, Andrew Morton wrote:
> >...
> > git-tree owners might need, umm, some encouragement here.  It's much easier
> > for them to slap the oh-let's-fix-that-up commit at the tail of their
> > queue, which leaves us with the straggly commit record.
> 
> As far as I understand Linus on these matters people David Miller 
> mustn't edit older commits in their trees once their tree got pushed 
> out.

I expect that means "don't alter stuff after you've sent the pull request".
That'd be fairly dumb.

But during the two-month -rcX timeframe the patches in the git and quilt
trees get altered, dropped, reordered regularly.  Some of the git trees
don't really exist, I believe - their owners assemble them from a
quilt-based master tree for external sharing only.

