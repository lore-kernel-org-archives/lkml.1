Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZFGXPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZFGXPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 19:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZFGXOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 19:14:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbZFGXOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 19:14:52 -0400
Date: Sun, 7 Jun 2009 16:14:29 -0700 (PDT)
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
In-Reply-To: <200906071955.42378.bzolnier@gmail.com>
Message-ID: <alpine.LFD.2.01.0906071613350.6847@localhost.localdomain>
References: <200906071444.33047.bzolnier@gmail.com> <200906071744.23629.bzolnier@gmail.com> <84144f020906070954p54cdfee4y62a51795be10b0d0@mail.gmail.com> <200906071955.42378.bzolnier@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Jun 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> My honest opinion is that it is as appropriate now as it will be 2.6.31.

No.

I['m not pulling new features after -rc8. It had better be a major bugfix 
to a major oops or security issue.

This is not a "2.6.30" vs "2.6.31" issue. It's a "before -rc1" vs "after 
-rc8" issue.

			Linus
