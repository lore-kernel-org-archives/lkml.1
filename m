Return-Path: <linux-kernel-owner+w=401wt.eu-S1762142AbYECJiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762142AbYECJiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbYECJiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:38:11 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36330 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636AbYECJiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:38:10 -0400
Date: Sat, 3 May 2008 12:37:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080503093714.GI5838@cs181133002.pp.htv.fi>
References: <20080502133234.GA24080@logfs.org> <alpine.LFD.1.10.0805021010040.5994@woody.linux-foundation.org> <20080502202151.GB24080@logfs.org> <alpine.LFD.1.10.0805021328200.5994@woody.linux-foundation.org> <20080502213146.GD24080@logfs.org> <alpine.LFD.1.10.0805021438180.5994@woody.linux-foundation.org> <20080502215833.GG24080@logfs.org> <20080503070318.GR8474@1wt.eu> <20080503091111.GH5838@cs181133002.pp.htv.fi> <20080503091813.GA1829@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080503091813.GA1829@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 11:18:13AM +0200, Willy Tarreau wrote:
> On Sat, May 03, 2008 at 12:11:11PM +0300, Adrian Bunk wrote:
>...
> > What you call "more testers" would be people who try it in production
> > (e.g. to overcome shortcomings of JFFS2) thinking it was stable.
> 
> No, it is just to gain more exposure by easing tester's job. People
> packaging distros for embedded systems do a lot of R&D, and having
> new features to experiment with is very important to them. And no,
> that does not mean they'll immediately use it in production.

If it's in the kernel it will end in distribution kernels.

And people will then use it.

You might be right, they might not immediately use it in production. 
They might use the current version one year later in the then one year 
old kernel they will then be using. Or the one year old version plus 
some random set of vendor patches.

> And
> even if some did, they would know why they did it and it's their
> problem.

You want to put experimental code into stable kernels and then blame 
people using it that they shouldn't have used it?

> Willy

cu
Adrian

BTW: This is not meant against the LogFS merge.

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

