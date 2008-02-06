Return-Path: <linux-kernel-owner+w=401wt.eu-S1763743AbYBFCT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763743AbYBFCT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761467AbYBFCTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:19:45 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:59930 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761365AbYBFCTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:19:44 -0500
Date: Tue, 5 Feb 2008 19:19:42 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Liam Howlett <howlett@gmail.com>
Subject: Re: Pull request: TASK_KILLABLE
Message-ID: <20080206021942.GA21509@parisc-linux.org>
References: <20080129000447.GC31101@parisc-linux.org> <alpine.LFD.1.00.0801292237480.3505@www.l.google.com> <20080131234504.GB25967@parisc-linux.org> <alpine.LFD.1.00.0802011146180.3198@www.l.google.com> <1201830304.3087.2.camel@heimdal.trondhjem.org> <20080131180205.20e7dece.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131180205.20e7dece.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 06:02:05PM -0800, Andrew Morton wrote:
> No such export was needed in the patches which I added to -mm.  So
> something changed between then and now.

Not sure abouut that problem -- still on holiday, so just checking ym
mail quickly.

> And going back through the mailing list all I can find is a series of five
> patches in October - it's unclear where and when the other 17 were
> reviewed, if they were.

A large number of these patches are just a resplit of the patches sent
back in October -- you complained they weren't split up enough.  So I
resplit them.  And sent them to you.  Asking if this was how you
preferred it.  Which you didn't reply to.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
