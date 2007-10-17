Return-Path: <linux-kernel-owner+w=401wt.eu-S936586AbXJQRjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936586AbXJQRjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936472AbXJQRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:39:33 -0400
Received: from mail1.perex.cz ([212.20.107.53]:59984 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936465AbXJQRjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:39:32 -0400
Date: Wed, 17 Oct 2007 19:39:30 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl
Subject: Re: suspicious ALSA empty commit
In-Reply-To: <alpine.LFD.0.999.0710170854280.26902@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0710171928250.11118@tm8103.perex-int.cz>
References: <20071016.155044.82377336.davem@davemloft.net>
 <alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
 <Pine.LNX.4.61.0710170809580.11118@tm8103.perex-int.cz>
 <alpine.LFD.0.999.0710170854280.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Linus Torvalds wrote:

> On Wed, 17 Oct 2007, Jaroslav Kysela wrote:
> > 
> > I didn't notice, too. I've fixed this commit in my git tree.
> 
> More importantly, how did it get there in the first place?
> 
> As mentioned, normal git tools will not even *allow* you to create an 
> empty commit by default! So you must be using some really strange workflow 
> to get an empty commit, or be triggering a git bug, both of which should 
> be resolved first.

I'm using stg on top of git for merging and easy tree rebasing, but the 
version might be old (I'll try upgrade at first):

Stacked GIT 0.12
git version 1.5.0.3

stg import / refresh / pick commands are on way to move patches to linus 
branch.

						Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project
