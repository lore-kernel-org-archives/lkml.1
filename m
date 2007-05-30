Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXE3Pxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXE3Pxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXE3Pxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:53:41 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbXE3Pxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:53:41 -0400
Date: Wed, 30 May 2007 08:53:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
cc: Bryan Wu <bryan.wu@analog.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] Blackfin update for 2.6.22-rc3
In-Reply-To: <200705300909.13419.rgetz@blackfin.uclinux.org>
Message-ID: <alpine.LFD.0.98.0705300842340.26602@woody.linux-foundation.org>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
 <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org>
 <200705300909.13419.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Robin Getz wrote:
> 
> In one of my (how did Andrew word it...) circumlocutious threads about 
> Blackfin a while ago, I offered hardware to anyone who wanted to try things 
> out. Greg KH was the only person who read through the entire thing, and asked 
> (and got one). Offer still good for qualified developers.

I applaud that, but I end up spending all my time on email, and I suspect 
that's true for most of the core developers. So I actually suspect that 
you'll get much better community and testing from offering these things at 
Linux users groups, and similar places where you find people who may be 
really interested in getting into something new, and don't already have 
some kernel subsystem that they are basically maintaining full time..

Not that offering them to known kernel developers is _bad_, mind you, but 
I think you'll actually find that a lot of them end up being so busy with 
their current thing that they don't have much time for another 
architecture. I know I do..

			Linus
