Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbYJJSQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbYJJSQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbYJJSQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:16:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758460AbYJJSQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:16:30 -0400
Date: Fri, 10 Oct 2008 11:15:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull, take 2] x86 updates for v2.6.28, phase #2 - PAT
 updates
In-Reply-To: <20081010174131.GA8806@elte.hu>
Message-ID: <alpine.LFD.2.00.0810101114360.3503@nehalem.linux-foundation.org>
References: <20081009234951.GA24349@elte.hu> <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org> <20081010164537.GA23664@elte.hu> <20081010170426.GA5947@elte.hu> <20081010174131.GA8806@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Ingo Molnar wrote:
> 
> i'll re-roll the seven x86-v28-for-linus-phase3...phase10 trees as well.

Just checking: the scheduler/rcu trees you did pull requests for yesterday 
are all independent and I can pull those as-is, right?

		Linus
