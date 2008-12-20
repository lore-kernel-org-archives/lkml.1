Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYLTWLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYLTWLp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 17:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYLTWLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 17:11:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699AbYLTWLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 17:11:37 -0500
Date: Sat, 20 Dec 2008 14:11:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20081220193106.GA19555@elte.hu>
Message-ID: <alpine.LFD.2.00.0812201409450.14014@localhost.localdomain>
References: <20081220134353.GA16399@elte.hu> <alpine.LFD.2.00.0812201112210.14014@localhost.localdomain> <20081220193106.GA19555@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Dec 2008, Ingo Molnar wrote:
> 
> You are right, this patch should have been delayed to .29. Should i 
> rebase the branch?

I pulled it. I don't think it is a huge deal - as mentioned, google didn't 
seem to find any mention of the message ever triggering, so I doubt it 
really matters. 

It just wasn't the right time for that kind of patch. But it's almost 
certainly harmless.

			Linus
