Return-Path: <linux-kernel-owner+w=401wt.eu-S1762334AbYGOUZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762334AbYGOUZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYGOUZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:25:23 -0400
Received: from r00tworld.com ([212.85.137.21]:58678 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbYGOUZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:25:21 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jul 2008 22:23:45 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487D2371.10258.1BDBBC00@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.1.10.0807151317270.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D20EC.26203.1BD1E5C5@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151317270.2867@woody.linux-foundation.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Tue, 15 Jul 2008 22:24:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 13:18, Linus Torvalds wrote:

> 
> 
> On Tue, 15 Jul 2008, pageexec@freemail.hu wrote:
> >
> > in any case, i don't see why you can't put keywords into the commit
> > that say the bug being fixed is 'security related' or 'potentially 
> > exploitable', etc. people can then decide how to prioritize them.
> 
> Because I see no point. Quite often, we don't even realize some random bug 
> could have been a security issue.
> 
> It's not worth my energy, in other words. 

i understand and i think noone expects that. in fact, i know how much
expertise and time it takes to determine that. but what happens when
you do figure out the security relevance of a bug during bug submission
(say, it goes directly to security@kernel.org with a PoC to trigger it)
or while working out the fix or you see that it falls into an well-known
exploitable bug class? you have the information yet you still make no
mention of it. *that* at least can be fixed, if you chose so.

cheers,
 PaX Team

