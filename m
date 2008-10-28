Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYJ1QzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYJ1QzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYJ1QzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:55:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbYJ1QzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:55:01 -0400
Date: Tue, 28 Oct 2008 09:54:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC git pull] tracing fixes
In-Reply-To: <20081028164615.GA13425@elte.hu>
Message-ID: <alpine.LFD.2.00.0810280953250.3386@nehalem.linux-foundation.org>
References: <20081028164615.GA13425@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Oct 2008, Ingo Molnar wrote:

> While writing up this pull request i noticed that the diffstat of this 
> tree grew unusually large :-(
> 
> Hence i changed it to an RFC pull request - and if it's not acceptable 
> we will rebase it to be smaller.

The things that make it large are also the main things I like about it 
(that FTRACE config option confusion and the removal of the nasty daemon), 
so I pulled it.

		Linus
