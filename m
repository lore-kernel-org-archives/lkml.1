Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYGZUiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYGZUiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 16:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbYGZUiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 16:38:03 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51810 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbYGZUiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 16:38:02 -0400
Date: Sat, 26 Jul 2008 21:37:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Adrian Bunk <bunk@kernel.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
In-Reply-To: <20080726132610.6c583346.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0807262132460.15972@blonde.site>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
 <20080726173832.GE9301@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0807261852050.582@blonde.site>
 <20080726125025.465d524b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0807262104060.13201@blonde.site> <20080726132610.6c583346.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, Andrew Morton wrote:
> On Sat, 26 Jul 2008 21:15:47 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > I'm still in favour the quick fs/exec.c build fixup for now.
> 
> Well, safe-simple-and-duck-the-issue has its merits.  My inbox awaits thee :)

I've trespassed on Adrian's good nature to ask him to run some builds
on it, having demonstrated my incompetence twice already.  But he may
well have better things to do with his time.  Hold on a mo, I'm just
wrapping up the tmpfs BUG first.

Hugh
