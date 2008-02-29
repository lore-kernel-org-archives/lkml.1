Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbYB2XT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbYB2XT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 18:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbYB2XTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 18:19:50 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbYB2XTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 18:19:49 -0500
Date: Fri, 29 Feb 2008 15:18:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
In-Reply-To: <20080229224212.24A532700FE@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0802291509030.17889@woody.linux-foundation.org>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080229155207.GC27248@elte.hu> <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org> <20080229224212.24A532700FE@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Roland McGrath wrote:
> 
> I suppose I shouldn't be surprised at being harangued for making my log
> entries too informative.

No, no, no. We want them long and informative. 

The only thing I asked for was that text should have the visual separation 
also between different paragraphs.

I at no point asked you to make the thing shorter, I asked you to split it 
up and MAKE IT VISUALLY LONGER by adding the proper vertical whitespace 
(which is how we do paragraphs).

> If what you want is formulaic log text that always puts blank lines in
> between bug description, change description, and change justification, I
> can do that.  If there is any place that documents the conventions you
> want in log entries, I've overlooked it.

It's _purely_ an issue of overly long paragraphs, not about the language 
or any "formulaic" crap.

The fact is, paragraphs help make things more readable. 

What I find funny is how this email you just wrote actually has *much* 
shorter paragraphs than the changelog entry I replied to. 

Go back and look. The explanation I objected to was a single paragraph, 15 
lines long. That's about two thirds of the screen with no break.

And then, in the email reply you just sent (the one I'm replying to here), 
the longest one was nine lines and most were four or six lines, with one 
being three lines. Why? Because it's simply MORE READABLE.

I didn't ask you to write denser or less readable log messages, I asked 
for exactly the reverse. So I don't understand why you then made your 
reply be a rant about how you could make less explanatory changelog 
messages.

		Linus
