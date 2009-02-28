Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZB1R1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZB1R1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZB1R1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:27:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752AbZB1R1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:27:46 -0500
Date: Sat, 28 Feb 2009 09:27:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alex Riesen <raa.lkml@gmail.com>
cc: trivial@kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use a format string for linux_banner
In-Reply-To: <20090228133602.GA28239@blimp.localdomain>
Message-ID: <alpine.LFD.2.00.0902280924150.3111@localhost.localdomain>
References: <81b0412b0902250104q53f38343o303e980c1446ed3e@mail.gmail.com> <49A92783.1010709@s5r6.in-berlin.de> <20090228133602.GA28239@blimp.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Feb 2009, Alex Riesen wrote:
> > 
> > Please send patches as inline text or at least as plaintext attachment
> > in ascii encoding.  linux/Documentation/email-clients.txt has help.
> 
> Couldn't. Had to either choose the corporate firewal and gmail, or the
> Exchange-thing. Both will corrupt patches, unless send as attachment.
> Decided not to expose the corporate mail address.

Well, I _can_ tell you that I just ignore patches that I can't see 
directly in my email reader. Others may pick them up, but for me it's an 
issue of "ok, I can't easily even see the patch, and the person didn't 
bother to do it right - it's not worth my time".

What people _can_ do is to send it both as a crazy attachment _and_ as 
plaintext. If they plaintext gets corrupted, the attachment still works, 
and the plaintext is at least somethign I can see and thus in my mail 
reader decide whether it's worth my time to save the attachment and look 
at it outside the mail reader.

		Linus
