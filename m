Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbXJQWzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbXJQWzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759133AbXJQWz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:55:28 -0400
Received: from thunk.org ([69.25.196.29]:38093 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759256AbXJQWz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:55:27 -0400
Date: Wed, 17 Oct 2007 18:55:19 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 update
Message-ID: <20071017225519.GA11267@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1Ii0UI-0007TW-IM@closure.thunk.org> <alpine.LFD.0.999.0710170857490.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710170857490.26902@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 08:59:53AM -0700, Linus Torvalds wrote:
> > Please pull from:
> > 
> >         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> This conflicts in nontrivial ways with
> 
> which I just merged from -mm.
> 
> I suspect it's trivial to fix up for somebody who knows/understands the 
> code, but I'm not that person, and I cannot verify the end result.
> 
> So can you please do the merge, and I'll pull the merged tree?
> 

OK, I've rebased and fixed up the patches with your latest git tree.

Could you please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

now?   Thanks!!

						- Ted
