Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYEaEf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYEaEf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbYEaEfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:35:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbYEaEfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:35:20 -0400
Date: Fri, 30 May 2008 21:34:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] 64-bit futexes: x86 support
In-Reply-To: <4840D335.6040406@redhat.com>
Message-ID: <alpine.LFD.1.10.0805302129240.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301923020.3141@woody.linux-foundation.org> <4840C394.2080807@redhat.com> <alpine.LFD.1.10.0805302056170.3141@woody.linux-foundation.org> <4840D335.6040406@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Ulrich Drepper wrote:
> 
> I guess have to expect to expect to be insulted by you.

Guess why? What comes around goes around. 

You just dismissed (without apparently even understanding them) my 
concerns about a patch that comes out of the blue, when I ask whether you 
really looked into trying to do it other ways.

You didn't even post the code that would _use_ this. You just blindly 
claim that you're the only one who can know things like this and can do 
serialization, and that your way is the only approach.

Color me not impressed. 

I did not insult you until you didn't even understand my first email. We 
have had an efficient 32-bit rwlock in the kernel for a long time. So I 
(quite naturally) questioned your statement (that had no backing up 
what-so-ever) that it cannot be done.

Sure, futex use and user space is not the same as the kernel code. It's 
possible that you really do need 64-bit futexes. But quite frankly, the 
only thing you have proven so far is that you're an ass.

			Linus
