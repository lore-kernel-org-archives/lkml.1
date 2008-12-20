Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYLTTQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYLTTQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 14:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYLTTQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 14:16:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbYLTTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 14:16:16 -0500
Date: Sat, 20 Dec 2008 11:16:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20081220134353.GA16399@elte.hu>
Message-ID: <alpine.LFD.2.00.0812201112210.14014@localhost.localdomain>
References: <20081220134353.GA16399@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Dec 2008, Ingo Molnar wrote:
> 
> Joerg Roedel (3):
>       AMD IOMMU: panic if completion wait loop fails

What's the advantage to this, especially this late in the game?

Now, I tried to google for the message (while ignoring the patches), and 
as far as I can tell, it has never happened that google has noticed. But 
still, why was this pushed as a "fix"?

		Linus
