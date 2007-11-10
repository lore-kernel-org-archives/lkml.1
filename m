Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbXKJPxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbXKJPxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXKJPx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:53:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52756 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbXKJPx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:53:27 -0500
Date: Sat, 10 Nov 2007 15:53:13 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110155313.GA22418@infradead.org>
References: <20071109230812.GA5176@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109230812.GA5176@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 12:08:12AM +0100, Sam Ravnborg wrote:
> With this patchset the former ARCH=i386 / ARCH=x86_64 are
> replaced by ARCH=x86.
> The rationale behind the patchset are that with a
> unified x86 architecture this should be reflected in
> the build commands.
> 
> With this patch set the 32/64 bit selection is done
> at configuration time like we know it from parisc and
> powerpc.
> 
> Please pull to your cleanup branch:
> 
> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/x86.git
> 
> I leave it to you (x86 maintainers) to decide when to push this to Linus.
> But I strongly suggest sooner is better so we finish the build parts
> of the x86 unification.

I'll second that request.  We should finish off the user-visible parts
of the merge in one release (2.6.24).

