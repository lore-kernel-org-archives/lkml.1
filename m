Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbYGOQDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbYGOQDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYGOQD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:03:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981AbYGOQD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:03:27 -0400
Date: Tue, 15 Jul 2008 09:03:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20080715151312.GA27514@elte.hu>
Message-ID: <alpine.LFD.1.10.0807150901120.3017@woody.linux-foundation.org>
References: <20080715150137.GA22647@elte.hu> <20080715151312.GA27514@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Ingo Molnar wrote:
> 
> hm, you just pushed another fix for that out via:
> [...]
> that would collide. Here's a (separate) merged up tree that will pull 
> cleanly:

Heh, I just merged it myself - it happens all the time, I did't even think 
about it.

If it had been any more complex I would have emailed you (and hopefully 
noticed this follow-up email before doing that), but it was rather obvious 
enough, and I just picked your side.

		Linus
