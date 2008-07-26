Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYGZUnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYGZUnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 16:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbYGZUmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 16:42:53 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48479 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbYGZUmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 16:42:53 -0400
Date: Sat, 26 Jul 2008 23:42:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
Message-ID: <20080726204218.GG9301@cs181140183.pp.htv.fi>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com> <20080726173832.GE9301@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0807261852050.582@blonde.site> <20080726125025.465d524b.akpm@linux-foundation.org> <Pine.LNX.4.64.0807262104060.13201@blonde.site> <20080726132610.6c583346.akpm@linux-foundation.org> <Pine.LNX.4.64.0807262132460.15972@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807262132460.15972@blonde.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 09:37:45PM +0100, Hugh Dickins wrote:
> On Sat, 26 Jul 2008, Andrew Morton wrote:
> > On Sat, 26 Jul 2008 21:15:47 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:
> > > 
> > > I'm still in favour the quick fs/exec.c build fixup for now.
> > 
> > Well, safe-simple-and-duck-the-issue has its merits.  My inbox awaits thee :)
> 
> I've trespassed on Adrian's good nature to ask him to run some builds
> on it, having demonstrated my incompetence twice already.  But he may
> well have better things to do with his time.  Hold on a mo, I'm just
> wrapping up the tmpfs BUG first.

Sorry, if you wanted to know anything from me anything except whether my 
patch is correct (as I already answered to Johannes it is not) I must 
have missed it.

What exactly do you want me to test?

> Hugh

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

