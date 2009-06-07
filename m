Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZFGXQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZFGXQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 19:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZFGXQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 19:16:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZFGXQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 19:16:12 -0400
Date: Sun, 7 Jun 2009 16:15:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] IDE fixes
In-Reply-To: <200906072125.40784.bzolnier@gmail.com>
Message-ID: <alpine.LFD.2.01.0906071614560.6847@localhost.localdomain>
References: <200906071444.33047.bzolnier@gmail.com> <200906072100.10649.bzolnier@gmail.com> <84144f020906071209m51e5fd15jaa67f9143ab1d126@mail.gmail.com> <200906072125.40784.bzolnier@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Jun 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> To be perfectly clear on this:
> 
> * all patches were posted a week ago to the list (they replaced patches
>   from two weeks ago -- which were intended for -rc8 but thanks to feedback
>   I found a better way to do it).

Bartlomiej - if you want to add new features, they should have been posted 
on the list BEFORE THE MERGE WINDOW EVEN OPENED.

Not just after -rc7 or something like that.

			Linus
